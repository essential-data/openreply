module Statistics
  class PersonStatistics
    attr_reader :person

    # @param [ActiveRecord::Relation] ratings
    # @param [ActiveRecord::Relation] ratings_older
    def initialize ratings, ratings_older = nil, person = nil
      calculate ratings, ratings_older
      @person = person
    end

    # Return person name or an ampty string
    #
    # @return [String] person name
    def name
      if person
        person.name
      else
        ""
      end
    end

    # Return result hash with :value and :color keys
    #
    # @return [Hash]
    def average
      { value: "%0.2f" % @average, color: Openreply::Color.color(@average) }
    end

    # Return result hash with :value and :color keys
    #
    # @return [Hash]
    def median
      { value: "%0.2f" % @median, color: Openreply::Color.color(@median) }
    end

    # Return result hash with :value and :color keys
    #
    # @return [Hash]
    def change
      { value: (@change == :unknown ? "N/A" : "%0.1f" % @change + " %"), color: Openreply::Color.color_change(@change) }
    end

    # Return result hash with :value and :color keys
    #
    # @return [Hash]
    def count
      { value: @count, color: "gray" }
    end

    def calculate(ratings, ratings_older)
      @average = ratings.average(:int_value).to_f
      @median = calculate_median(ratings).to_f
      @change = calculate_period_change ratings, ratings_older
      @count = ratings.count
    end

    def calculate_period_change ratings_this_period, ratings_older_period
      # ratings_this_period, ratings_older_period = rating_of_periods ratings, ratings_older_period
      return :unknown if ratings_this_period.empty? || !ratings_older_period || ratings_older_period.empty?

      last_period_avg = ratings_older_period.average(:int_value).to_f
      this_period_avg = ratings_this_period.average(:int_value).to_f

      (this_period_avg/last_period_avg-1) * 100 if last_period_avg != 0
    end

    def rating_of_periods ratings, ratings_older_period
      if ratings_older_period.nil?
        default_time_period = Settings.dates.default_time_period
        this_period = (Time.now - default_time_period.day)..Time.now
        last_period = (Time.now - (default_time_period*2).day)...(Time.now - default_time_period.day)
        ratings_this_period = ratings.where(created_at: this_period)
        ratings_older_period = ratings.where(created_at: last_period)
      else
        ratings_this_period = ratings
      end

      return ratings_this_period, ratings_older_period
    end

    # Return calculated median
    #
    # @param [Array] ratings
    # @return [Float]
    def calculate_median ratings
      # puts ratings.length
      if !ratings || ratings.empty?
        0
      else
        ratings = ratings.sort { |r1, r2| r1.int_value <=> r2.int_value }
        len = ratings.length
        (ratings[(len - 1) / 2].int_value + ratings[len / 2].int_value)/ 2.0
      end
    end

    def self.of_many_persons persons
      persons.to_a.map! { |e| Statistics::PersonStatistics.new e.ratings, nil, e }
      persons.sort { |c1, c2| c2.average[:value]<=>c1.average[:value] }
    end
  end
end
