require 'lru_redux'

Dir["#{Rails.root}/app/sunny/**/*.rb"].each { |file| require file }
Dir["#{Rails.root}/config/exchanges/**/*.rb"].each { |file| require file }

Time::DATE_FORMATS[:moment_timestamp] = "%b %-d, %Y  @ %l:%M %p"

module Sunny

  include Facebook::Messenger

  Facebook::Messenger.config.access_token = ENV['FB_ACCESS_TOKEN']
  Facebook::Messenger.config.verify_token = ENV['FB_VERIFY_TOKEN']

  messageCache = LruRedux::Cache.new(100)

  messageHandler = lambda { |id, sender, at, text, attachments|
    unless isRepeatMessage(id)
      ProcessMessageJob.perform_later sender, at, text, attachments
    else
      Rails.logger.warn "(Discarding duplicate message #{id})"
    end
  }

  Bot.on :message do |message|
    unless isRepeatMessage(message)
      id = message.id
      sender = message.sender['id']
      at = message.sent_at.to_i
      text = message.text
      attachments = message.attachments
      messageHandler.call(id, sender, at, text, attachments)
    end
  end

  Bot.on :postback do |postback|
    id = message.id
    sender = postback.sender['id']
    at = postback.sent_at.to_i
    text = postback.payload
    messageHandler.call(id, sender, at, text, nil)
  end

  private

  def isRepeatMessage(id)
    result = cache[:id]
    cache[:id] = true
    result
  end
end
