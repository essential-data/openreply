class Rating < ActiveRecord::Base
  belongs_to :customer
  belongs_to :employee
  has_one :review

  validates_presence_of :customer_id, :employee_id, :int_value

  validates :int_value, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: Settings.max_int_rating
  }

  # if does an article with customer, employee and ticket_id exist in OTRS
  def valid_personal_details?
    Otrs::Article.exist_any? ticket_id, customer.name, employee.first_name, employee.last_name
  end

  def employee_first_name
    employee.first_name
  end

  def employee_last_name
    employee.last_name
  end

  def employee_name
    employee.name
  end

  def customer_name
    customer.name
  end

  # set ticket_number from OTRS of the ticket
  def obtain_ticket_number
    self.ticket_number = Otrs::Ticket.find(ticket_id).tn
  end

  def review_text
    review.text
  end

  def ignored?
    !!(review && review.ignored_rating)
  end

  def created_at_text
    created_at.strftime("%d. %m. %Y")
  end

  def text_value_short
    first = text_value.first(10)
    if text_value.length > 10
      first+"..."
    else
      first
    end
  end

  # cookie key for disallowing voting twice for an article
  def cookie_key
    "Rated #{employee_name} by #{customer_name} on #{ticket_id}"
  end

  # text for notification mail
  def detailed_text
    text = "<p>Employee <b>#{employee_name}</b> was rated by <b>#{customer_name}</b> and got <b>#{int_value} stars</b><p>"
    text = text + "<p>Customer wrote: <i>#{text_value}</i></p>" if text_value
    text
  end

  # initialize rating with valid customer, employee and ticket details
  # @return [Rating]
  def self.new_from_customer_and_ticket_and_employee customer_name, ticket_id, employee_first_name, employee_last_name
    employee = Employee.find_or_create_by_first_name_and_last_name employee_first_name, employee_last_name
    customer = Customer.find_or_create_by_name customer_name

    rating = Rating.new(customer: customer, ticket_id: ticket_id.presence, employee: employee)

    if Otrs.using_otrs?
      # validation with otrs
      return nil if !rating.valid_personal_details?

      # receiving ticket number from otrs
      rating.obtain_ticket_number
    end
    rating
  end

  # initialize rating with valid customer, employee, ticket details and also filled rating values
  # @return [Rating]
  def self.new_from_ticket_and_rated_values_and_ip ticket_details, value, text_value, remote_ip
    rating = new_from_customer_and_ticket_and_employee ticket_details['customer'], ticket_details['ticket_id'], ticket_details['employee_first_name'], ticket_details['employee_last_name']
    return nil unless rating

    rating.int_value = value
    rating.text_value = text_value
    rating.client_ip = remote_ip

    rating
  end

  #array of name and id for dashboard selector
  # @return [Array]
  def self.customers
    joins(:customer).distinct.pluck('name, customers.id')
  end

  #array of name and id for dashboard selector
  # @return [Array]
  def self.employees
    joins(:employee).distinct.pluck("CONCAT(first_name,  ' ',   last_name), employees.id")
  end

  # @return [ActiveRecord_Relation]
  def self.filter_by_employee employee
    joins(:employee).where('employees.id = ?', employee.id)
  end

  # @return [ActiveRecord_Relation]
  def self.filter_by_customer customer
    joins(:customer).where('customers.id = ?', customer.id)
  end
end
