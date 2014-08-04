module Dashboard
  class Wall

    # process parameters and get filter values
    #
    # @param [ActionController::Parameters] params
    # @return [Array] array that contains instance of Customer, Employee, time interval and from, to dates
    def self.process_parameters params

      customer = Customer.find_by_id params["customer_id"] if params["customer_id"]
      employee = Employee.find_by_id params["employee_id"] if params["employee_id"]

      interval = params["time_interval"] || 'all'
      if interval == "custom"
        from = params['from']
        to = params["to"]
      else
        from = Statistics::Period.period_to_start_date interval
        to = Time.now.strftime('%Y-%m-%d')
      end

      return customer, employee, interval, from, to
    end

  end
end
