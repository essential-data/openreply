module Dashboard
  class Wall

    # Sets cookies to remember last used filtering
    #
    # @param [ActionController::Parameters] params
    # @param [ActionDispatch::Cookies::CookieJar] cookies
    # @return [Array] array that contains cookies, instance of Customer, Employee, time interval and from, to dates
    def self.process_parameters params, cookies
      # sets cookies and takes care of nil params
      cooks, employee, customer = self.cookies params, cookies

      # using cookies to remember last used filtering
      interval = cooks[:filter_time_interval]
      from = cooks[:filter_from_time]
      to = cooks[:filter_to_time]

      return cooks, customer, employee, interval, from, to
    end

    # Save cookies to store last used filtering
    #
    # @param [ActionController::Parameters] params
    # @param [ActionDispatch::Cookies::CookieJar] cookies
    # @return [Array] array that contains cookies, instance of Customer, Employee, time interval and from, to dates
    def self.cookies params, cookies
      # using cookies to save last used filtering
      cooks = {}

      customer = Customer.find_by_id(params["customer_id"] || cookies[:filter_customer_id])
      cooks[:filter_customer_id] = customer.id if customer

      employee = Employee.find_by_id(params["employee_id"] || cookies[:filter_employee_id])
      cooks[:filter_employee_id] = employee.id if employee

      cooks[:filter_time_interval] = params["time_interval"] || cookies[:filter_time_interval]

      if cooks[:filter_time_interval] == "custom"
        cooks[:filter_from_time] = params['from'] || cookies[:filter_from_time]
        cooks[:filter_to_time] = params["to"] || cookies[:filter_to_time]
      elsif params["time_interval"]
        cooks[:filter_from_time] = Statistics::Period.period_to_start_date params["time_interval"]
        cooks[:filter_to_time] = Time.now.strftime('%Y-%m-%d')
      end
      cooks[:filter_time_interval] = params["time_interval"] || cookies[:filter_time_interval] || "all"
      return cooks, employee, customer
    end
  end
end
