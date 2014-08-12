require 'rails_helper'

describe Customer, :type => :model do
  include FeatureMacros

  context "sculpture of customer" do
    it "should create just 1 customer" do

      expect(Customer.find_by_name("Jano0")).to be_nil
      Customer.find_or_create_by_name "Jano0"
      expect(Customer.find_by_name("Jano0")).to_not be_nil
      Customer.find_or_create_by_name "Jano0"
      expect(Customer.where(name: "Jano0").count).to eq 1
    end
  end
  context 'statistics' do

    it 'calculates person_statistics' do
      db_init

      entities= Customer.all_statistics
      customer_17 = entities.find { |i| i.name == 'Ignac' }
        expect(customer_17.median[:value]).to eq "2.50"
        expect(customer_17.average).to eq({:value=>"2.75", :color=>"yellow"})
        expect(customer_17.count).to eq({value: 4, color: "gray"})
        expect(customer_17.change[:value]).to eq "N/A"
        expect(customer_17.name).to eq "Ignac"
    end
  end

end
