module Statistics
  module Period

    PERIOD_TYPE = {
        week: 0,
        month: 1,
        year: 2,
        all: 3
    }

    PERIOD_TYPE_REV = {
        0 => :week,
        1 => :month,
        2 => :year,
        3 => :all
    }

    # Return a start date from a period name
    #
    # @param [Symbol] period_name - is one of: :week, :month, :year or :all
    # @return [String] the return date for a period - e.g: 2014-01-01 for a :year
    def self.period_to_start_date(period_name)
      app_deploy_date = Settings.dates.app_deploy_date

      case period_name
        when :week,  "week"
          from = Time.now - 7.days
        when :month,"month"
          from = Time.now - 31.days
        when :year , "year"
          from = Time.now - 365.days
        when :all ,"all"
        else
          raise RuntimeError.new, "Unknown time period"
      end
      return app_deploy_date if !from || from < app_deploy_date
      return from.strftime('%Y-%m-%d')
    end
  end
end
