module Otrs
  class Ticket
    attr_reader :id, :tn, :customer, :employee_firstname, :employee_lastname, :meta

    URL = "#{Settings.otrs_api.url}/api/ticket/"

    # @param [Hash] params - containing all the information about the ticket:
    # :id, :tn, :customer, :employee_firstname, :employee_lastname and the :meta hash
    def initialize(params)
      @id = params[:id]
      @tn = params[:tn]
      @customer = params[:customer]
      @employee_firstname = params[:employee_firstname]
      @employee_lastname = params[:employee_lastname]
      @meta = params[:meta]
    end

    # Return an instance of Otrs::Ticket or raise Otrs::IDNotFoundError if the record does not exist
    # it's an activerecord-like finder method
    #
    # @param [Fixnum] id
    # @return [Otrs::Ticket]
    def self.find(id)
      # Call the OTRS API
      response = Otrs::Client.call(URL, id: id)

      tn = response["objects"].first["tn"]
      customer = customer_name(response)
      employee_firstname = response["objects"].first["user"]["first_name"]
      employee_lastname = response["objects"].first["user"]["last_name"]
      meta = response["meta"]

      # Return an instance of a Ticket
      self.new id: id, tn: tn, customer: customer, employee_firstname: employee_firstname,
               employee_lastname: employee_lastname, meta: meta
    end

    # Return the tickets count that match the given time period for a customer
    #
    # @param [String] from_date - example: '2014-02-17'
    # @param [String] to_date - example: '2015-01-01'
    # @param [String] customer
    # @return [Fixnum]
    def self.count(from_date = Settings.dates.app_deploy_date, to_date = Date.current, customer = nil, employee = nil)
      params = {}
      params[:create_time__gt] = from_date
      params[:create_time__lt] = to_date if to_date
      params[:customer] = customer.name if customer
      params[:user__first_name] = employee.first_name if employee
      params[:user__last_name] = employee.last_name if employee
      params[:limit] = 1

      begin
        response = Otrs::Client.call(URL, params)
        return response["meta"]["total"]
      rescue Otrs::IDNotFoundError => e
        return 0
      end
    end

    # Return an instance of Otrs::Ticket or nil if the record does not exist
    #
    # @param [Fixnum] id
    # @return [Otrs::Ticket]
    def self.find_by_id(id)
      begin
        return find(id)
      rescue Otrs::IDNotFoundError => e
        return nil
      end
    end

    private

    # Get customer name from the response hash or the unknown customer name from settings
    #
    # @param [Hash] response
    # @return [String]
    def self.customer_name response
      customer = response["objects"][0]["customer"]
      # test if customer is not blank, if so customer is replaced by string representation for unknown customer in config
      if Settings.otrs_api.unknown_customers.include? customer
        customer = Settings.otrs_api.unknown_customer_name
      end
      customer
    end
  end
end
