module Sunny
  class ExchangeMessage
    attr_reader :buttons, :attachments, :moment_attachments
    def initialize
      @text_options = []
      @attachments = []
      @buttons = []
      @moment_attachments = false
    end

    def config(&block)
      instance_eval(&block)
      self
    end

    def text(t=nil)
      unless t.blank?
        @text_options.push(t)
      end
      @text_options.sample
    end

    def quoted_text(t=nil)
      unless t.blank?
        text "\"#{t}\""
      end
      text
    end

    def attachments(a=nil)
      unless a.blank?
        @attachments = a
      end
      @attachments
    end

    def moment_attachments(m=nil)
      unless m.blank?
        @moment_attachments = m
      end
      @moment_attachments
    end

    def button(label, text)
      button = ExchangeMessageButton.new(label, text)
      @buttons.push(button)
      button
    end

    def method_missing(m, *args, &block)
      "<%= #{m} %>"
    end

    def has_buttons?
      @buttons.length > 0
    end

    def has_attachments?
      @attachments.length > 0
    end

    def replace(context)
      @text_options.map! do |text|
        Erubis::Eruby.new(text).result(context)
      end
      @buttons.each do |button|
        button.replace(context)
      end
      self
    end
  end
end
