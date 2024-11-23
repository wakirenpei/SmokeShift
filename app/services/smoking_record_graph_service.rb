class SmokingRecordGraphService
  class << self
    def fetch_daily_data(user, start_date, end_date)
      range = date_range_for(:day, start_date, end_date)
      user.smoking_records.in_range(range)
          .group_by_period(:day, :smoked_at, time_zone: 'Tokyo', range: range)
          .count
    end

    def fetch_weekly_data(user, start_date, end_date)
      range = date_range_for(:week, start_date, end_date)
      user.smoking_records.in_range(range)
          .group_by_period(:week, :smoked_at, time_zone: 'Tokyo', range: range)
          .count
    end

    def fetch_monthly_data(user, start_date, end_date)
      range = date_range_for(:month, start_date, end_date)
      user.smoking_records.in_range(range)
          .group_by_period(:month, :smoked_at, time_zone: 'Tokyo', range: range)
          .count
    end

    def fetch_hourly_data(user)
      data = user.smoking_records
                 .group_by_hour_of_day(:smoked_at, time_zone: 'Tokyo')
                 .count

      (0..23).each { |hour| data[hour] ||= 0 }
      data
    end

    private

    def date_range_for(period, start_date, end_date)
      case period
      when :day then start_date..end_date
      when :week then (end_date.end_of_week - 4.weeks)..end_date.end_of_week
      when :month then (end_date.end_of_month - 5.months)..end_date.end_of_month
      end
    end
  end
end
