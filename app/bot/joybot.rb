class Joybot
  include Facebook::Messenger

  ACTIONS = [:get_started, :menu]

  def initialize
    Facebook::Messenger.config.access_token = ENV['FB_ACCESS_TOKEN']
    Facebook::Messenger.config.verify_token = ENV['FB_VERIFY_TOKEN']

    @graph = Koala::Facebook::API.new(ENV['FB_ACCESS_TOKEN'])
    @wit = Wit.new(ENV['WIT_ACCESS_TOKEN'], wit_actions)

    Bot.on :message do |message|
      sender = message.sender['id']
      at = message.sent_at
      text = message.text
      Rails.logger.info "[ #{sender} @ #{at} ] >> #{text}"
      wit.run_actions(sender, text, {})
    end

    @config = YAML.load(File.read(Rails.root.to_s + "/config/joybot_config.yml"))[Rails.env].deep_symbolize_keys!
    @responses = config[:responses]
  end

  def say(session_id, context, msg)
    Bot.deliver(
      recipient: {
        id: session_id
      },
      message: {
        text: Erubis::Eruby.new(msg).result(context)
      }
    )
    return context
  end

  def say_with_buttons(session_id, context, msg, buttons)
    Bot.deliver(
      recipient: {
        id: session_id
      },
      message: {
        attachment: {
          type: 'template',
          payload: {
            template_type: 'button',
            text: Erubis::Eruby.new(msg).result(context),
            buttons: buttons.map { |button_label, button_text|
              {
                type: 'postback',
                title: button_text,
                payload: button_label
              }
            }
          }
        }
      }
    )
  end

  def merge(session_id, received_context, entities, msg)
    inject_context(session_id, received_context) { |context|
      unless entities[:intent].nil?
        case entities[:intent][0][:value]
        when "opt_in" # first message or greeting
          context.merge!(opted_in: true)
        end
      end
    }
  end

  def opt_in(session_id, received_context)
    inject_context(session_id, received_context) { |context|
      context.merge!(opted_in: true)
    }
  end

  def get_started(session_id, received_context)
    inject_context(session_id, received_context) { |context|
      Bot.deliver(
        recipient: {
          id: session_id
        },
        message: {
          attachment: {
            type: 'template',
            payload: {
              template_type: 'button',
              text: 'What would you like to do?',
              buttons: [
                { type: 'postback', title: 'Record an event', payload: 'RECORD_EVENT' },
                { type: 'postback', title: 'Look back', payload: 'LOOK_BACK' }
              ]
            }
          }
        }
      )
    }
  end

  def error(session_id, received_context, error)
    inject_context(session_id, received_context) { |context|
      p error, context
    }
  end

  private
  attr_accessor :graph, :wit, :config, :responses

  def wit_actions
    @wit_actions ||= begin
      actions = {
        say: -> (session_id, context, msg) { self.say(session_id, context, msg) },
        merge: -> (session_id, context, entities, msg) { self.merge(session_id, context, entities, msg) },
        error: -> (session_id, context, error) { self.error(session_id, context, error) },
      }

      ACTIONS.each do |action|
        actions[action] = -> (session_id, context) {
          process_action(action, session_id, context)
        }
      end

      actions
    end
  end

  def process_action(action, fb_id, received_context)
    inject_context(fb_id, received_context) do |context|
      response = responses[action]

      response.each do |message|
        # TODO: Add other message types
        message_text = message[:text]
        message_buttons = message[:buttons]
        if message_buttons.nil?
          say(fb_id, context, message[:text])
        else
          say_with_buttons(fb_id, context, message[:text], message[:buttons])
        end
      end
    end
  end

  def inject_context(fb_id, context)
    user = User.find_by(fb_id: fb_id)
    unless user.present?
      user = create_user(fb_id)
    end
    new_context = user.context.merge(context)
    new_context.merge!(no_memories: true) # TODO: Use actual records
    yield(new_context)
    unless user.context == new_context
      user.update(context: new_context)
    end
    return new_context
  end

  def create_user(fb_id)
    profile = graph.get_object(fb_id).with_indifferent_access
    User.create(
      fb_id: fb_id,
      first_name: profile[:first_name],
      last_name: profile[:last_name],
      gender: profile[:gender],
      locale: profile[:locale],
      timezone: profile[:timezone],
      context: { # add more as needed
        first_name: profile[:first_name]
      }
    )
  end
end

# Initial setup

joybot = Joybot.new
