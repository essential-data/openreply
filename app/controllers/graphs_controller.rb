class GraphsController < ApplicationController

  before_action do
    customer, employee, @interval, from, to = Dashboard::Wall.process_parameters params
    @filtered_ratings = Dashboard::FilteredRatings.new customer, employee, @interval, from, to
  end

  # JS render bar
  def bar
    @bar = Statistics::Bar.new @filtered_ratings
    respond_to do |format|
      format.html {}
      format.js { render partial: "dashboard/charts/bar" }
    end
  end

  # JS render histogram
  def histogram
    @histogram = Statistics::Histogram.new @filtered_ratings.ratings

    respond_to do |format|
      format.html { render_404 }
      format.js { render partial: "dashboard/charts/histogram" }
    end
  end

  # JS render timeline
  def time_line
    @time_line = Statistics::Timeline.new @filtered_ratings.ratings

    respond_to do |format|
      format.html { render_404 }
      format.js { render partial: "dashboard/charts/time_line" }
    end
  end

  # JS render detailed statistics in circles
  def detailed_statistics
    @detailed_statistics = Statistics::PersonStatistics.new @filtered_ratings.ratings, @filtered_ratings.ratings_older
    @should_switch = (@interval != 'all')
    respond_to do |format|
      format.html { render_404 }
      format.js { render partial: "dashboard/charts/statistics" }
    end
  end

end