require 'rails_helper'

describe Dashboard::FilteredRatings do
  include FeatureMacros


  before :each do
    @from = 7.days.ago.strftime("%Y-%-m-%-d")
    @to = Date.current.strftime("%Y-%-m-%-d")
  end

  describe '#initialize' do
    it 'should assign parameters' do
      @filtered_ratings = Dashboard::FilteredRatings.new Customer.find_by_name("Janko Hraško"), Employee.find_by_first_name_and_last_name('Janko', 'Marienka'), "week", @from, @to
      expect(@filtered_ratings.ratings).to be_an_instance_of Rating::ActiveRecord_Relation
      expect(@filtered_ratings.ratings_older).to be_an_instance_of Rating::ActiveRecord_Relation
      expect(@filtered_ratings.filter).to be_an_instance_of Dashboard::Filter
    end

    it 'should assign parameters' do
      db_init
      @filtered_ratings = Dashboard::FilteredRatings.new Customer.find_by_name("Janko Hraško"), Employee.find_by_first_name_and_last_name('Janko', 'Marienka'), "week", @from, @to
      expect(@filtered_ratings.ratings.count).to eq 2
      expect(@filtered_ratings.ratings_older.count).to eq 1
      expect(@filtered_ratings.filter.customer_name).to eq "Janko Hraško"
    end


  end


end
