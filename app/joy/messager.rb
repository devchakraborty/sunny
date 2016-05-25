module Joy
  class Messager
    include Facebook::Messenger

    def self.message(fb_id, msg)
      if msg.has_buttons?
        message_with_buttons(fb_id, msg.text, msg.buttons)
      else
        message_with_text(fb_id, msg.text)
      end
    end

    def self.message_with_text(fb_id, text)
      Bot.deliver(
        recipient: {
          id: fb_id
        },
        message: {
          text: text
        }
      )
    end

    def self.message_with_buttons(fb_id, text, buttons)
      Bot.deliver(
        recipient: {
          id: fb_id
        },
        message: {
          attachment: {
            type: 'template',
            payload: {
              template_type: 'button',
              text: text,
              buttons: buttons.map { |button|
                {
                  type: 'postback',
                  title: button.text,
                  payload: button.label
                }
              }
            }
          }
        }
      )
    end
  end
end
