class AddTicketNumberToRating < ActiveRecord::Migration
	def up
		change_table :ratings do |t|
			t.column :ticket_number, :string
			t.change :ticket_number, :string, after: :ticket_id
		end
	end

	def down
		change_table :ratings do |t|
			t.remove :ticket_number
		end
	end
end