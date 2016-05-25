module Joy
  class ExchangeMessage
    attr_reader :buttons
    def initialize
      @text = ""
      @buttons = []
    end

    def config(&block)
      instance_eval(&block)
      self
    end

    def text(t=@text)
      @text = t
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

    def replace(context)
      @text = Erubis::Eruby.new(@text).result(context)
      @buttons.each do |button|
        button.replace(context)
      end
      self
    end
  end
end
