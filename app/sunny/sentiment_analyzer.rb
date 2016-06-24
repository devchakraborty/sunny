require 'indico'
Indico.api_key = ENV['INDICO_API_KEY']

module Sunny
  class SentimentAnalyzer
    NEUTRAL_THRESHOLD = 0.15
    POSITIVE_THRESHOLD = 0.75
    def self.score(text)
      Indico.sentiment_hq(text)
    end

    def self.analyze(text)
      s = score(text)
      if s > POSITIVE_THRESHOLD
        category = :positive
      elsif s > NEUTRAL_THRESHOLD
        category = :neutral
      else
        category = :negative
      end

      SentimentAnalyzerResult.new(category, s)
    end

    class SentimentAnalyzerResult
      attr_reader :category, :score
      def initialize(c, s)
        @category = c
        @score = s
      end
    end
  end
end
