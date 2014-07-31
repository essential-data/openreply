class Customer < ActiveRecord::Base
  has_many :ratings

  validates :name, uniqueness: true
  validates_presence_of :name

  #names and ids of employees related to current customer through ratings
  # @return [Array[employee.name, employee.id] ]
  def related_employees
    ratings.employees
  end

  def self.find_or_create_by_name name
    where(name: name).first_or_create
  end

  # array list containing each customer's average, median, change, couunt statistics sorted by average value for all time
  # @return [Array]
  def self.all_statistics
    Statistics::PersonStatistics.of_many_persons all
  end
end
