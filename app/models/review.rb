class Review < ActiveRecord::Base
  belongs_to :rating

  validates_presence_of :rating_id

  def reviewed?
    !id.nil?
  end

end
