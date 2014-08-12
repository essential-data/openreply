require 'rails_helper'

describe Employee, :type => :model do
  include FeatureMacros


  context "sculpture of employee" do
    it "should create just 1 employee" do

      expect(Employee.find_by_first_name_and_last_name("Jano","O")).to be_nil
      Employee.find_or_create_by_first_name_and_last_name "Jano", "O"
      expect(Employee.find_by_first_name_and_last_name("Jano","O")).to_not be_nil
      Employee.find_or_create_by_first_name_and_last_name "Jano", "O"
      expect(Employee.where(first_name: "Jano", last_name: "O").count).to eq 1
    end

  end

  context "statistic functions" do
    it 'calculates_average' do
      e1  = Employee.find_or_create_by_first_name_and_last_name "Jozo", "Suchy"
      create(:rated, int_value: 1, employee: e1)
      create(:rated, int_value: 4, employee: e1)
      create(:rated, int_value: 4, employee: e1)
      create(:rated, int_value: 2, employee: e1)
      create(:rated, int_value: 5, employee: e1)
      expect(e1.average_ratings).to eq 3.2
    end

    it 'calculates person_statistics' do
      db_init
      entities= Employee.all_statistics

      employee_13 = entities.find { |i| i.name== 'Jožo J' }

      expect(employee_13.median[:value]).to eq "2.50"
      expect(employee_13.average).to eq({:value => "2.75", :color => "yellow"})
      expect(employee_13.count).to eq({value: 4, color: "gray"})
      expect(employee_13.change[:value]).to eq "N/A"
      expect(employee_13.name).to eq "Jožo J"

    end
  end

  describe "#first_name" do
    it "returns first name" do
      e1 = create :employee, first_name:"Ferko", last_name: "Starsi Mrkvička"
      expect(e1.first_name).to eq "Ferko"
    end
  end

end
