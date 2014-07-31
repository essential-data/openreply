class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :first_name, after: :id
      t.string :last_name, after: :id
      t.timestamps
    end

    change_table :ratings do |t|
      t.integer :employee_id, after: :id
    end


  end
end
