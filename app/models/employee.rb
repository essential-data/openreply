class Employee < ActiveRecord::Base
  has_many :ratings

  validates :first_name, uniqueness: {scope: :last_name}
  validates_presence_of :first_name, :last_name

  def name
    "#{first_name} #{last_name}"
  end

  #average of rated values
  def average_ratings
    ratings.average(:int_value)
  end

  #name and id of customers related to current employee through ratings
  # @return [Array[customer.name, customer.id]]
  def related_customers
    ratings.customers
  end

  def self.find_or_create_by_first_name_and_last_name first_name, last_name
    where(first_name: first_name, last_name: last_name).first_or_create
  end

  # array list containing each employee's person statistics: average, median, change, couunt statistics sorted by average value for all time
  # @return [Array]
  def self.all_statistics
    Statistics::PersonStatistics.of_many_persons all
  end

end
