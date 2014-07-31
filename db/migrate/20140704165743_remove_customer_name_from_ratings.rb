class RemoveCustomerNameFromRatings < ActiveRecord::Migration
  def change
    Rating.reset_column_information
    Rating.all.each do |r|
      c = Customer.find_or_create_by_name(r[:customer_name])
      r.update!(customer_id: c.id)
    end

    remove_column :ratings, :customer_name

  end
end
