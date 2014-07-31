require 'spec_helper'

describe Statistics::Histogram do
  include FeatureMacros

  before :each do
  end

  context '#initialize' do

    it 'should empty' do
      @filtered_ratings = Dashboard::FilteredRatings.new Customer.find_by_name("Ignac"), nil, "all", nil, nil
      histogram = Statistics::Histogram.new @filtered_ratings.ratings
      expect(histogram.data).to eq "[[1, 0], [2, 0], [3, 0], [4, 0], [5, 0]]"
    end

    it 'should with values' do
      db_init
      @filtered_ratings = Dashboard::FilteredRatings.new Customer.find_by_name("Ignac"), nil, "all", nil, nil
      histogram = Statistics::Histogram.new @filtered_ratings.ratings
      expect(histogram.data).to eq "[[1, 0], [2, 2], [3, 1], [4, 1], [5, 0]]"
    end

  end

end
