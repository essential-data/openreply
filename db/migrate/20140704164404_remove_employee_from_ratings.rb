class RemoveEmployeeFromRatings < ActiveRecord::Migration
  def change
    Rating.reset_column_information
    Rating.all.each do |r|
      first_name = r[:employee].split[0]
      last_name = r[:employee].split[1..-1].join ' '
      e = Employee.find_or_create_by_first_name_and_last_name(first_name, last_name)
      r.employee_id = e.id
      r.customer_id = -1

      r.save!
    end

    change_table :ratings do |t|
      t.remove :employee
    end
  end
end
