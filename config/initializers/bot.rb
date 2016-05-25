Dir["#{Rails.root}/app/joy/**/*.rb"].each { |file| require file }
Dir["#{Rails.root}/config/exchanges/**/*.rb"].each { |file| require file }

module Joy

  include Facebook::Messenger

  Facebook::Messenger.config.access_token = ENV['FB_ACCESS_TOKEN']
  Facebook::Messenger.config.verify_token = ENV['FB_VERIFY_TOKEN']

  @wit_actions = begin
    actions_dict = {
      say: -> (session_id, context, msg) { raise JoyError.new("Should not receive say actions from Wit") },
      merge: -> (session_id, context, entities, msg) { Merger.merge(session_id, context, entities, msg) },
      error: -> (session_id, context, error) { raise JoyError.new(error) },
    }
    Joy::ExchangeRegistry.labels.each do |label|
      actions_dict[label] = -> (session_id, context) {
        Joy::ExchangeRegistry.get(label).invoke(session_id, context)
      }
    end
    actions_dict
  end

  @wit = Wit.new(ENV['WIT_ACCESS_TOKEN'], @wit_actions)

  Bot.on :message do |message|
    sender = message.sender['id']
    at = message.sent_at
    text = message.text
    Rails.logger.info "[ #{sender} @ #{at} ] >> #{text}"
    @wit.run_actions(sender, text, {})
  end
end
