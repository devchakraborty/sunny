module Joy
  class ExchangeRegistry
    @registry = {}

    def self.register(label, exchange)
      @registry[label.to_sym] = exchange
    end

    def self.get(label)
      @registry[label]
    end

    def self.labels
      @registry.keys
    end
  end
end
