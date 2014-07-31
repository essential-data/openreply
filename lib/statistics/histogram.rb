module Statistics
  class Histogram
    attr_accessor :data

    # @param [ActiveRecord::Relation] ratings
    def initialize(ratings)
      @data = calculate ratings
    end

    # Return array of sorted ratings
    #
    # @param [ActiveRecord::Relation] ratings
    def calculate(ratings)
      histogram_data = ratings.group(:int_value).count
      5.times { |i| histogram_data[i+1] = 0 if !histogram_data[i+1] }
      histogram_data.to_a.sort.to_s
    end
  end
end
