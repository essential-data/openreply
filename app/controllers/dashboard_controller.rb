class DashboardController < ApplicationController
  require "browser"

  def employees_list
    @employees = Employee.all_statistics
  end

  def customers_list
    @customers = Customer.all_statistics
  end

  # statistics screen
  def wall
    customer, employee, interval, from, to = Dashboard::Wall.process_parameters(params)

    @filtered_ratings = Dashboard::FilteredRatings.new customer, employee, interval, from, to
    @all_time_statistics = Statistics::PersonStatistics.new Rating.all
  end

end
