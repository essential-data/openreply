require 'rails_helper'

describe Dashboard::Filter do
  include FeatureMacros

  before :each do
    @customer = Customer.find_or_create_by_name 'Jano'
    @employee = create :employee, first_name: 'Jojo', last_name: 'J'
    @interval = 'all'
    @from = '2014-02-20'
    @to= '2014-12-20'
  end


  describe '#initialize' do
    it 'should assign parameters' do
      @f = Dashboard::Filter.new @customer, @employee, @interval, @from, @to
      expect(@f.customer).to be_an_instance_of Customer
      expect(@f.employee).to be_an_instance_of Employee
      expect(@f.interval).to eq 'all'
      expect(@f.from).to eq '2014-02-20'
      expect(@f.to).to eq '2014-12-20'
    end

    it 'should assign right values' do
      @f = Dashboard::Filter.new @customer, @employee, @interval, @from, @to
      expect(@f.customer_name).to eq 'Jano'
      expect(@f.employee_name).to eq 'Jojo J'
      expect(@f.customer_id).to eq 1
      expect(@f.employee_id).to eq 1
      expect(@f.employee_last_name).to eq 'J'
      expect(@f.employee_first_name).to eq 'Jojo'
    end

    it 'should assign default parameters' do
      @f = Dashboard::Filter.new nil, nil, 'all', nil, nil
      expect(@f.customer).to be_nil
      expect(@f.employee).to be_nil
      expect(@f.interval).to eq 'all'
      expect(@f.from).to be_nil
      expect(@f.to).to be_nil
    end

    it 'should assign right values' do
      @f = Dashboard::Filter.new nil, nil, 'all', nil, nil
      expect(@f.customer_name).to eq 'all'
      expect(@f.employee_name).to eq 'all'
      expect(@f.customer_id).to be_nil
      expect(@f.employee_id).to be_nil
      expect(@f.employee_first_name).to eq ''
      expect(@f.employee_last_name).to eq 'all'
    end

    context 'related people' do
      before(:each) do
        db_init
        @customer = Customer.find_by_name "Mikuláš"
        @customer2 = Customer.find_by_name "Starec"
        @employee = Employee.find_by_first_name_and_last_name 'Fero', 'K'
        @employee2 = Employee.find_by_first_name_and_last_name 'Jano', 'J'
      end

      it 'should return all related customers' do
        @f = Dashboard::Filter.new nil, nil, 'all', nil, nil
        expect(@f.employee_related_customers).to include [@customer.name, @customer.id]
        expect(@f.employee_related_customers).to include [@customer2.name, @customer2.id]
      end

      it 'should return related customers' do
        @f = Dashboard::Filter.new nil, @employee, 'all', nil, nil
        expect(@f.employee_related_customers).to include [@customer.name, @customer.id]
        expect(@f.employee_related_customers).to_not include [@customer2.name, @customer2.id]
      end

      it 'should return all related employees' do
        @f = Dashboard::Filter.new nil, nil, 'all', nil, nil
        expect(@f.customer_related_employees).to include [@employee.name, @employee.id]
        expect(@f.customer_related_employees).to include [@employee2.name, @employee2.id]
      end

      it 'should return related employees' do
        @f = Dashboard::Filter.new @customer, nil, 'all', nil, nil
        expect(@f.customer_related_employees).to include [@employee.name, @employee.id]
        expect(@f.customer_related_employees).to_not include [@employee2.name, @employee2.id]
      end

    end

  end
end
