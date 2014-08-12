require 'rails_helper'

RSpec.describe Review, :type => :model do
  describe '#reviewed?' do
    it 'should not be reviewed' do
      r= Review.new
      expect(r.reviewed?).to be false
    end

    it 'should be reviewed' do
      r= Review.create
      expect(r.reviewed?).to be false
    end
  end


end
