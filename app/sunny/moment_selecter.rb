module Sunny
  class MomentSelecter
    include ActionView::Helpers::DateHelper
    attr_reader :fb_id
    def initialize(fb_id)
      @fb_id = fb_id
      @moment = nil
    end

    def select_time_range(from, to)
      @moment = Moment.created_by(fb_id).entered_between(from, to).shuffled.first
    end

    def select_date_range(from, to)
      Time.use_zone(ActiveSupport::TimeZone["UTC"]) do
        @moment = select_time_range (from.beginning_of_day - timezone.hours), (to.end_of_day - timezone.hours)
      end
    end

    def select_date(date)
      @moment = select_date_range date, date
    end

    def select
      @moment = Moment.created_by(fb_id).shuffled.first
    end

    def moment
      @moment
    end

    def moment?
      !@moment.nil?
    end

    def moment_text
      @moment.text
    end

    def moment_at
      "#{time_ago_in_words(@moment.created_at)} ago"
    end

    private
    def timezone
      @timezone ||= User.find_by(fb_id: @fb_id).timezone
    end
  end
end
