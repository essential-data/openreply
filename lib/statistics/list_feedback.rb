module Statistics
  class ListFeedback
    attr_accessor :data

    # @param [ActiveRecord::Relation] ratings
    # @param [String] order
    # @param [String] page
    def initialize ratings, order, page
      rating = ratings.order(:created_at)
      rating = rating.reverse_order unless order == "ASC"
      @data = rating.page(page).includes(:employee, :customer)#.select('ratings.*, employees.first_name, employees.last_name, customers.name ')

    end
  end
end
