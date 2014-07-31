require 'spec_helper'

describe Statistics::PersonStatistics do
  include FeatureMacros

  before :each do
    db_init

    @filtered_ratings = Dashboard::FilteredRatings.new Customer.find_by_name("Ignac"), nil, "week", nil, nil
  end

  context '#initialize' do

    it 'should empty' do
      @filtered_ratings = Dashboard::FilteredRatings.new Customer.find_by_name("Maros"),nil, "all",nil, nil

      stat = Statistics::PersonStatistics.new @filtered_ratings.ratings, @filtered_ratings.ratings_older
      expect(stat.count).to eq ({value: 0, color: "gray"})
      expect(stat.average).to eq ({value: "0.00", color: "pink"})
      expect(stat.median).to eq ({value: "0.00", color: "pink"})
      expect(stat.change).to eq ({value: "N/A", color: "gray"})

    end

    it 'should with values' do

      stat = Statistics::PersonStatistics.new @filtered_ratings.ratings, @filtered_ratings.ratings_older
      expect(stat.count).to eq ({value: 4, color: "gray"})
      expect(stat.average).to eq ({value: "2.75", color: "yellow"})
      expect(stat.median).to eq ({value: "2.50", color: "yellow"})
      expect(stat.change).to eq ({value: "N/A", color: "gray"})
    end


  end

end
