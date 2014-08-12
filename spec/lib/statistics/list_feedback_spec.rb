require 'rails_helper'

describe Statistics::ListFeedback do
  include FeatureMacros

  before :each do
    # @filtered_ratings = Dashboard::FilteredRatings.new "all", "all", "all", nil, nil
    @filtered_ratings = Dashboard::FilteredRatings.new nil, nil, "all", nil, nil
  end

  context '#initialize' do
    it 'should empty' do
      list = Statistics::ListFeedback.new @filtered_ratings.ratings, nil, 1
      expect(list.data.count).to eq 0
    end

    it 'should desc' do
      db_init
      list = Statistics::ListFeedback.new @filtered_ratings.ratings, "DESC", 1
      expect(list.data[0].created_at).to be > list.data[-1].created_at
    end

    it 'should asc' do
      db_init
      list = Statistics::ListFeedback.new @filtered_ratings.ratings, "ASC", 1
      expect(list.data.count).to be > 0
      expect(list.data[0].created_at).to be < list.data[-1].created_at
    end

    it 'should page change' do
      db_init
      list1 = Statistics::ListFeedback.new @filtered_ratings.ratings, "DESC", 1
      list2 = Statistics::ListFeedback.new @filtered_ratings.ratings, "DESC", 2

      expect(list1.data[1].id).to_not eq list2.data[1].id
    end


  end

end
