class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name

      t.timestamps
    end

    change_table :ratings do |t|
      t.integer :customer_id, after: :id
    end

  end
end
