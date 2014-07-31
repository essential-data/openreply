module Otrs
  class Article
    URL = "#{Settings.otrs_api.url}/api/article/"

    # Finds out if there's an article for given combination of
    # ticket id, customer name and employee (by firstname and lastname)
    #
    # @param [Fixnum] ticket_id
    # @param [String] customer_name
    # @param [String] employee_firstname
    # @param [String] employee_lastname
    # @return [TrueClass | FalseClass]
    def self.exist_any? ticket_id, customer_name, employee_firstname, employee_lastname
      begin
        params = {ticket: ticket_id, create_by__first_name: employee_firstname,
                  create_by__last_name: employee_lastname, limit: 1}

        params[:ticket__customer] = customer_name if customer_name != Settings.otrs_api.unknown_customer_name

        response = Otrs::Client.call(URL, params)

        return response["meta"]["total"] > 0
      rescue Otrs::IDNotFoundError => e
        return false
      end
    end

    # Return the max possible ratings count for given time period and (non-mandatory) customer
    # in case no customer name is proveded, return the count for all customers
    #
    # @param [String] from_date - example: "2014-01-01"
    # @param [String] to_date - example: "2015-01-01"
    # @param [String] customer - default value is nil
    def self.max_ratings_count(from_date = Settings.dates.app_deploy_date, to_date = Date.current, customer = nil)
      params = {}
      params[:create_time__gt] = from_date
      params[:create_time__lt] = to_date if to_date
      params[:ticket__customer] = customer.name if customer
      params[:article_sender_type] = 1
      params[:article_type] = 1
      params[:limit] = 1


      begin
        response = Otrs::Client.call(URL, params)
        return response["meta"]["total"]
      rescue Otrs::IDNotFoundError => e
        return 0
      end
    end
  end
end
