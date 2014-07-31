class AddNewCustomerToRatioStatistics < ActiveRecord::Migration
  def change


    remove_column :ratio_statistics, :customer
  end
end
