Dir["#{Rails.root}/app/joy/**/*.rb"].each { |file| require file }
Dir["#{Rails.root}/config/exchanges/**/*.rb"].each { |file| require file }

module Joy

  include Facebook::Messenger

  Facebook::Messenger.config.access_token = ENV['FB_ACCESS_TOKEN']
  Facebook::Messenger.config.verify_token = ENV['FB_VERIFY_TOKEN']

  MESSAGE_TIMEOUT = 30.seconds

  @wit_actions = begin
    actions_dict = {
      say: -> (fb_id, context, msg) { raise JoyError.new("Should not receive say actions from Wit") },
      merge: -> (fb_id, context, entities, msg) { Merger.merge(fb_id, context.with_indifferent_access, entities, msg) },
      error: -> (fb_id, context, error) { raise JoyError.new(error) },
    }
    Joy::ExchangeRegistry.labels.each do |label|
      actions_dict[label] = -> (fb_id, context) {
        context = context.with_indifferent_access
        new_context = Joy::ExchangeRegistry.get(label).invoke(fb_id, context)
        Merger.set(fb_id, new_context)
      }
    end
    actions_dict
  end

  @wit = Wit.new(ENV['WIT_ACCESS_TOKEN'], @wit_actions)

  def self.handle_message(sender, at, text)
    Rails.logger.info "[ #{sender} @ #{at} ] >> #{text}"

    if Time.now - at > MESSAGE_TIMEOUT
      Rails.logger.warn "(Discarding message older than #{MESSAGE_TIMEOUT} seconds)"
    else
      @wit.run_actions(sender, text, {})
    end
  end

  Bot.on :message do |message|
    sender = message.sender['id']
    at = message.sent_at
    text = message.text
    handle_message(sender, at, text)
  end

  Bot.on :postback do |postback|
    sender = postback.sender['id']
    at = postback.sent_at
    text = postback.payload
    handle_message(sender, at, text)
  end
end
