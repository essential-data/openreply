module Statistics
  class Timeline
    attr_accessor :data

    # @param [ActiveRecord::Relation] ratings
    def initialize ratings
      calculate ratings
    end

    # Assign string representation of data array to the :data instance variable
    #
    # @param [ActiveRecord::Relation] ratings
    def calculate ratings
      tl_data = {}
      ratings.each { |r| tl_data[r.created_at.to_time.to_i * 1000] = r.int_value }
      @data = tl_data.to_a.to_s
    end
  end
end
