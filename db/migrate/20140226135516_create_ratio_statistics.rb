class CreateRatioStatistics < ActiveRecord::Migration
  def change
    create_table :ratio_statistics do |t|
      t.string :customer
      t.integer :period_type
      t.integer :otrs_count
      t.integer :ratings_count
      t.float :ratio

      t.timestamps
    end
  end
end
