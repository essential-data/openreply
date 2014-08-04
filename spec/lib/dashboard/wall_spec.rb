require 'spec_helper'

describe Dashboard::Wall do

  before :each do
    @c1 = create :customer, name: "Jozko"
    @c2 = create :customer, name: "Marian"
    @e1 = create :employee, first_name: 'Fred', last_name: 'Fohu'
    @e2 = create :employee, first_name: 'Jo', last_name: 'Koono'
  end

  describe '#process_parameters' do
    it 'should get from params' do
      params = {"customer_id" => 2, 'employee_id' => 2, 'time_interval' => 'custom', 'from' => '2014-6-30', 'to' => '2014-7-7'}

      customer, employee, interval, from, to = Dashboard::Wall.process_parameters params

      expect(employee).to eq @e2
      expect(customer).to eq @c2
      expect(interval).to eq 'custom'
      expect(from).to eq '2014-6-30'
      expect(to).to eq '2014-7-7'
    end
  end
end