class ProcessMessageJob < ActiveJob::Base
  queue_as :default

  MESSAGE_TIMEOUT = 1.minute

  def perform(fb_id, at, text, attachments)
    at = Time.at(at)
    Rails.logger.info "[ #{fb_id} @ #{at} ] >> #{text}"

    if Time.now - at > MESSAGE_TIMEOUT
      Rails.logger.warn "(Discarding message older than #{MESSAGE_TIMEOUT} seconds)"
    else
      user = User.find_or_create_by_fb_id(fb_id)

      user.context[:last_user_message_at] = at.to_i
      user.context[:last_user_message] = text
      user.context[:last_user_attachments] = attachments

      if text.blank? && attachments.blank?
        Rails.logger.warn "(Discarding blank message)"
        return
      end

      if text.blank?
        action = "attachments"
      else
        if text == "ADMIN_CLEAR_MEMORY"
          user.destroy
          Sunny::Messager.message_with_text(fb_id, "[admin] Cleared memory.")
          return
        end

        action = "default"

        if text.length < 256
          response = api_client.text_request text, {timezone: user.timezone}
          result = response[:result]
          Rails.logger.debug "API AI RESULT #{result}"
          unless result[:action].blank?
            action = result[:action]
          end
        end

        case action
        when "yes_no"
          user.context[:just_expressed_yes_no] = result[:parameters][:yes_no]
        when "remind_me"
          user.context[:just_expressed_remind_me] = result[:parameters]
        when "help"
          user.context[:just_expressed_help] = true
        else
          user.context[:just_expressed_default] = true
        end
      end

      new_context = Sunny::ExchangeRegistry.get(action.to_sym).invoke(fb_id, user.context.with_indifferent_access)

      user.context = new_context

      user.save
    end
  end

  private

  def api_client
    @api_client ||= ApiAiRuby::Client.new(client_access_token: ENV['API_AI_ACCESS_TOKEN'])
  end
end
