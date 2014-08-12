require 'rails_helper'

describe Statistics::Timeline do
  include FeatureMacros

  before :each do
  end

  describe '#initialize' do

    it 'should empty' do
      @filtered_ratings = Dashboard::FilteredRatings.new Customer.find_by_name("Ignac"), nil, "all", nil, nil
      timeline = Statistics::Timeline.new @filtered_ratings.ratings
      expect(timeline.data).to eq "[]"
    end

    it 'should with values' do
      db_init
      @filtered_ratings = Dashboard::FilteredRatings.new Customer.find_by_name("Ignac"), nil, "all", nil, nil
      timeline= Statistics::Timeline.new @filtered_ratings.ratings
      expect(timeline.data).to match /\[\[\d+, 4\]\]/
    end

  end

end
