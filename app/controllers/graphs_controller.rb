class GraphsController < ApplicationController

  before_action do
    new_cookies, customer, employee, @interval, from, to = Dashboard::Wall.process_parameters(params, cookies)
    # this sets the cookies (it's not a local variable)
    new_cookies.each_pair { |k, v| cookies[k] = v }
    @filtered_ratings = Dashboard::FilteredRatings.new customer, employee, @interval, from, to
  end


  def bar
    @bar = Statistics::Bar.new @filtered_ratings
    respond_to do |format|
      format.html {}
      format.js { render partial: "dashboard/charts/bar" }
    end
  end

  def histogram
    @histogram = Statistics::Histogram.new @filtered_ratings.ratings

    respond_to do |format|
      format.html { render_404 }
      format.js { render partial: "dashboard/charts/histogram" }
    end
  end

  def time_line
    @time_line = Statistics::Timeline.new @filtered_ratings.ratings

    respond_to do |format|
      format.html { render_404 }
      format.js { render partial: "dashboard/charts/time_line" }
    end
  end

  def detailed_statistics
    @detailed_statistics = Statistics::PersonStatistics.new @filtered_ratings.ratings, @filtered_ratings.ratings_older
    @should_switch = (@interval != 'all')

    respond_to do |format|
      format.html { render_404 }
      format.js { render partial: "dashboard/charts/statistics" }
    end
  end


end