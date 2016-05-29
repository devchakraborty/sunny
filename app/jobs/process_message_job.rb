class ProcessMessageJob < ActiveJob::Base
  queue_as :default

  MESSAGE_TIMEOUT = 30.seconds

  def perform(fb_id, at, text)
    at = Time.at(at)
    Rails.logger.info "[ #{fb_id} @ #{at} ] >> #{text}"

    if Time.now - at > MESSAGE_TIMEOUT
      Rails.logger.warn "(Discarding message older than #{MESSAGE_TIMEOUT} seconds)"
    else
      user = User.find_or_create_by_fb_id(fb_id)
      user.context[:last_user_message] = text

      response = api_client.text_request text
      result = response[:result]

      p result

      action = result[:action] || "default"

      case action
      when "yes_no"
        user.context[:just_expressed_yes_no] = result[:parameters][:yes_no]
      when "remind_me"
        user.context[:just_expressed_remind_me] = result[:parameters]
      else
        user.context[:just_expressed_default] = true
      end

      new_context = Joy::ExchangeRegistry.get(action.to_sym).invoke(fb_id, user.context.with_indifferent_access)

      user.context = new_context

      user.save
    end
  end

  private

  def api_client
    @api_client ||= ApiAiRuby::Client.new(client_access_token: ENV['API_AI_ACCESS_TOKEN'])
  end
end
