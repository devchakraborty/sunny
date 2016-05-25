module Joy
  class Exchange
    attr_reader :messages
    def initialize
      @only_if_states = {}
      @only_if_not_states = {}
      @messages = []
      @add_states = {}
      @remove_states = []
      @label = ""
    end

    def setup(label, &block)
      @label = label
      instance_eval(&block)
      ExchangeRegistry.register(label, self)
      self
    end

    def only_if(state, &block)
      @only_if_states[state] = block
    end

    def only_if_not(state, &block)
      @only_if_not_states[state] = block
    end

    def message(&block)
      @messages.push(ExchangeMessage.new.config(&block))
    end

    def add_state(state, value=true)
      @add_states[state] = value
    end

    def remove_state(state)
      @remove_states.push(state)
    end

    # NON-DSL

    def invoke(fb_id, context)
      @only_if_states.each do |state, block|
        if context.key?(state)
          Exchange.new.setup("#{@label}_if_#{state}".to_sym, &block).invoke(fb_id, context)
        end
      end

      @only_if_not_states.each do |state, block|
        unless context.key?(state)
          Exchange.new.setup("#{@label}_if_not_#{state}".to_sym, &block).invoke(fb_id, context)
        end
      end

      @messages.each do |message|
        message.replace(context)
        Messager.message(fb_id, message)
      end

      context.merge(@add_states).except(*@remove_states)
    end
  end
end
