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
      if valid_uri?(text)
        s = 0.5
      else
        s = score(text)
      end
      if s > POSITIVE_THRESHOLD
        category = :positive
      elsif s > NEUTRAL_THRESHOLD
        category = :neutral
      else
        category = :negative
      end

      SentimentAnalyzerResult.new(category, s)
    end

    def self.NEUTRAL
      @@NEUTRAL ||= SentimentAnalyzerResult.new(:neutral, 0.5)
    end

    class SentimentAnalyzerResult
      attr_reader :category, :score
      def initialize(c, s)
        @category = c
        @score = s
      end
    end

    private

    def self.valid_uri?(uri)
      !!URI.parse(uri)
    rescue URI::InvalidURIError
      false
    end
  end
end
