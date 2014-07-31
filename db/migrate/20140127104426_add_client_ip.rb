class AddClientIp < ActiveRecord::Migration
  
  def change
    drop_table :ratings
    create_table :ratings do |t|
      t.string :customer_name
      t.string :ticket_id
      t.string :employee
      t.integer :int_value, :default => 0, :null => false
      t.text :text_value
      t.string :client_ip
      t.timestamps
    end
  end

end
