class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.string :customer_name
      t.timestamps
    end
  end
end

