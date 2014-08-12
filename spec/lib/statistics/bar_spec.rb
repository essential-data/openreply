require 'rails_helper'
require 'vcr_setup'

describe Statistics::Bar, :vcr do
  include FeatureMacros

  before :each do
  end

  context '#initialize', skip: !Otrs.using_otrs? do

    it 'should empty' do
      @filtered_ratings = Dashboard::FilteredRatings.new Customer.find_or_create_by_name("Ignac"), nil, "all", nil, nil
      bar = Statistics::Bar.new @filtered_ratings
      expect(bar.not_rated).to eq 0
      expect(bar.ratings_count).to eq 0
    end

    it 'should with values' do
      db_init
      @filtered_ratings = Dashboard::FilteredRatings.new nil, nil, "week", nil, nil
      bar = Statistics::Bar.new @filtered_ratings
      expect(bar.ratings_count).to eq 24
    end

  end

end
