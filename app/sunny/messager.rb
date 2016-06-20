module Sunny
  class Messager
    include Facebook::Messenger

    def self.message(fb_id, msg)
      if msg.has_buttons?
        message_with_buttons(fb_id, msg.text, msg.buttons)
      elsif msg.has_attachments?
        message_with_attachments(fb_id, msg.attachments)
      else
        message_with_text(fb_id, msg.text)
      end
    end

    def self.message_with_text(fb_id, text, attachments=[])
      Rails.logger.info "[ #{fb_id} @ #{Time.now} ] << #{text}"
      Bot.deliver(
        recipient: {
          id: fb_id
        },
        message: {
          text: text,
          attachment: attachments.first
        }
      )
      if attachments.length > 1
        message_with_attachments(fb_id, attachments.drop(1))
      end
    end

    def self.message_with_attachment(fb_id, attachment)
      Rails.logger.info "[ #{fb_id} @ #{Time.now} ] << #{attachment}"
      Bot.deliver(
        recipient: {
          id: fb_id
        },
        message: {
          attachment: attachment
        }
      )
    end

    def self.message_with_attachments(fb_id, attachments)
      attachments.each do |attachment|
        message_with_attachment(fb_id, attachment)
      end
    end

    def self.message_with_buttons(fb_id, text, buttons)
      buttons_text = buttons.map { |b| "[ #{b.text} ]"}.join(" ")
      Rails.logger.info "[ #{fb_id} @ #{Time.now} ] << #{text} #{buttons_text}"
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
