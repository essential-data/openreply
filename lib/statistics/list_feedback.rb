module Statistics
  class ListFeedback
    attr_accessor :data

    # @param [ActiveRecord::Relation] ratings
    # @param [String] order
    # @param [String] page
    def initialize ratings, order, page
      rating = ratings.order("created_at DESC")
      rating = rating.reverse_order if order == "DESC"
      @data = rating.page page
    end
  end
end
