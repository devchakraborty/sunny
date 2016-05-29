Dir["#{Rails.root}/app/joy/**/*.rb"].each { |file| require file }
Dir["#{Rails.root}/config/exchanges/**/*.rb"].each { |file| require file }

Time::DATE_FORMATS[:moment_timestamp] = "%b %-d, %Y  @ %l:%M %p"

module Joy

  include Facebook::Messenger

  Facebook::Messenger.config.access_token = ENV['FB_ACCESS_TOKEN']
  Facebook::Messenger.config.verify_token = ENV['FB_VERIFY_TOKEN']

  Bot.on :message do |message|
    sender = message.sender['id']
    at = message.sent_at.to_i
    text = message.text
    ProcessMessageJob.perform_later sender, at, text
  end

  Bot.on :postback do |postback|
    sender = postback.sender['id']
    at = postback.sent_at.to_i
    text = postback.payload
    ProcessMessageJob.perform_later sender, at, text
  end
end
