class RemoveRatioFromRatioStatistics < ActiveRecord::Migration
  def change
    change_table :ratio_statistics do |t|
      t.remove :ratio
    end
  end
end