module Joy
  class Exchange
    attr_reader :messages
    def initialize(label, &block)
      @only_if_blocks = []
      @messages = []
      @set_states = {}
      @label = label
      @invoke_first = []
      @stores_moment = false
      instance_eval(&block)
      ExchangeRegistry.register(label, self)
      self
    end

    def only_if(conditions, &block)
      @only_if_blocks.push(conditions: conditions, block: block)
    end

    def otherwise(&block)
      only_if({}, &block)
    end

    def message(&block)
      m = ExchangeMessage.new.config(&block)
      @messages.push(m)
      m
    end

    def set_state(state, value=true)
      @set_states[state] = value
    end

    def unset_state(state)
      set_state(state, :unset)
    end

    def invoke_first(label)
      @invoke_first.push(label)
    end

    def store_moment
      @stores_moment = true
    end

    # NON-DSL

    def invoke(fb_id, context)

      Rails.logger.info "Invoking exchange: #{@label}"

      if @stores_moment
        MomentStorer.store(fb_id, context[:last_user_message])
      end

      @invoke_first.each do |label|
        context = ExchangeRegistry.get(label).invoke(fb_id, context)
      end
      @only_if_blocks.each do |only_if_block|
        begin
          conditions = only_if_block[:conditions]
          block = only_if_block[:block]
          conditions.each do |state, value|
            valid = case value
            when :unset
              !context.key?(state)
            when :set
              context.key?(state)
            else
              context[state] == value
            end
            raise ConditionNotMetError.new unless valid
          end
          states_name = conditions.length > 0 ? conditions.map { |k, v| "#{k}_is_#{v}"}.join("_and_") : "otherwise"
          context = Exchange.new("#{@label}_if_#{states_name}".to_sym, &block).invoke(fb_id, context)
          break # multiple only_ifs will never execute
        rescue ConditionNotMetError
          next
        end
      end

      @messages.each do |message|
        message.replace(context)
        Messager.message(fb_id, message)
      end

      @set_states.each do |state, value|
        if value == :unset
          context.except!(state)
        else
          context[state] = value
        end
      end

      context
    end
  end

  class ConditionNotMetError < StandardError
  end
end
