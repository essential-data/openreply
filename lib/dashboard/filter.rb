module Dashboard
  class Filter
    attr_accessor :customer, :employee, :interval, :from, :to

    # @param [Customer] customer
    # @param [Employee] employee
    # @param [Symbol] interval - can be: :week, :month, :year, :all
    # @param [String] from
    # @param [String] to
    def initialize(customer, employee, interval, from, to)
      @customer = customer
      @employee= employee
      @interval = interval
      @from = from
      @to = to
    end

    # Return customer name or 'all' if customer id equals -1
    #
    # @return [String]
    def customer_name
      customer && customer.id >= 0 ? customer.name : "all"
    end

    # Return customer id if customer is present
    #
    # @return [Fixnum]
    def customer_id
      customer.id if customer
    end

    # Return employee name or 'all' if employee id equals -1
    #
    # @return [String]
    def employee_name
      employee && employee.id >= 0 ? employee.name : "all"
    end

    # Return employee first name or an empty string
    #
    # @return [String]
    def employee_first_name
      employee && employee.id >= 0 ? employee.first_name : ""
    end

    # Return employee last name or an empty string
    #
    # @return [String]
    def employee_last_name
      employee && employee.id >= 0 ? employee.last_name : "all"
    end

    # Return employee id if employee is present
    #
    # @return [Fixnum]
    def employee_id
      employee.id if employee
    end

    # Return array of employees related to current customer
    #
    # @example [["Jano R", 1], ["Peter S", 2], ["Kubo S", 3]]
    # @return [Array]
    def customer_related_employees
      if customer
        customer.related_employees
      else
        Rating.employees
      end
    end

    # Return array of customers related to current employee
    #
    # @example: [["JánC", 1], ["KvetoslavC", 2]]
    # @return [Array]
    def employee_related_customers
      if employee
        employee.related_customers
      else
        Rating.customers
      end
    end
  end
end
