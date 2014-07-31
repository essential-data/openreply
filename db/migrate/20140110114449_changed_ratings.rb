class ChangedRatings < ActiveRecord::Migration
  	def change
		add_column :ratings, :ticket_id, :string
		add_column :ratings, :employee_id, :string
		add_column :ratings, :int_value, :integer
		add_column :ratings, :text_value, :text
  	end
end