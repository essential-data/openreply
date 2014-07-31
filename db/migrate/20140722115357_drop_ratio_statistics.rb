class DropRatioStatistics < ActiveRecord::Migration
  def up
    drop_table :ratio_statistics
  end

  def down
    create_table "ratio_statistics", force: true do |t|
      t.integer  "customer_id"
      t.integer  "period_type"
      t.integer  "otrs_count"
      t.integer  "ratings_count"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index :ratio_statistics, :customer_id
  end
end
