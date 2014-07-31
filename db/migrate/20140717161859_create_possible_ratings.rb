class CreatePossibleRatings < ActiveRecord::Migration
  def change
    create_table :possible_ratings do |t|
      t.date :date
      t.integer :count
      t.references :customer, index: true
      t.references :employee, index: true

      t.timestamps
    end
  end
end
