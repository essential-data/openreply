module Statistics
  class Bar
    attr_accessor :not_rated, :ratings_count

    # Sets variables for index request ratio part
    #
    # @param [Dashboard::FilteredRatings] filtered_ratings
    def initialize(filtered_ratings)
      @not_rated, @ratings_count = calculate filtered_ratings
    end

    # Return rated and unrated ticket counts
    #
    # @param [Dashboard::FilteredRatings] filtered_ratings
    # @return [Array]
    def calculate(filtered_ratings)
      rated = filtered_ratings.ratings.where("ticket_id IS NOT NULL").distinct.count
      ticket_count = Otrs::Ticket.count filtered_ratings.filter.from, filtered_ratings.filter.to, filtered_ratings.filter.customer, filtered_ratings.filter.employee
      unrated = ticket_count - rated
      unrated = 0 if unrated < 0


      return unrated, rated
    end
  end
end
