module Sunny
  class ExchangeMessageButton
    attr_accessor :label, :text
    def initialize(label, text)
      @label = label
      @text = text
    end

    def replace(context)
      @text = Erubis::Eruby.new(@text).result(context)
      self
    end
  end
end
