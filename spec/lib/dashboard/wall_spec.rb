require 'spec_helper'

describe Dashboard::Wall do

  before :each do
    @c1 = create :customer, name: "Jozko"
    @c2 = create :customer, name: "Marian"
    @e1 = create :employee, first_name: 'Fred', last_name: 'Fohu'
    @e2 = create :employee, first_name: 'Jo', last_name: 'Koono'
  end

  it 'should set all cookies' do
    params = {"customer_id" => 1, 'employee_id' => 1, 'time_interval' => 'week'}
    cookies, employee, customer = Dashboard::Wall.cookies params, {}
    expect(cookies[:filter_customer_id]).to eq 1
    expect(cookies[:filter_employee_id]).to eq 1
    expect(cookies[:filter_time_interval]).to eq 'week'
    expect(cookies[:filter_from_time]).to eq (Time.now - 7.days).strftime('%Y-%m-%d')
    expect(cookies[:filter_to_time]).to eq Time.now.strftime('%Y-%m-%d')
    expect(customer).to eq @c1
    expect(employee).to eq @e1
  end

  it 'should set default cookies' do
    params = {}
    cookies, employee, customer = Dashboard::Wall.cookies params, {}

    expect(cookies[:filter_customer_id]).to be_nil
    expect(cookies[:filter_employee_id]).to be_nil
    expect(customer).to be_nil
    expect(employee).to be_nil

    expect(cookies[:filter_time_interval]).to eq 'all'
    expect(cookies[:filter_from_time]).to be_nil
    expect(cookies[:filter_to_time]).to be_nil
  end

  it 'should get from params' do
    params = {"customer_id" => 2, 'employee_id' => 2, 'time_interval' => 'custom', 'from' => '2014-6-30', 'to' => '2014-7-7'}
    cookies = {filter_customer_id: 1, filter_employee_id: 1, filter_time_interval: 'custom', filter_from_time: '2013-6-30', filter_to_time: '2013-7-7'}

    cooks, customer, employee, interval, from, to = Dashboard::Wall.process_parameters params, cookies

    expect(employee).to eq @e2
    expect(customer).to eq @c2
    expect(interval).to eq 'custom'
    expect(from).to eq '2014-6-30'
    expect(to).to eq '2014-7-7'
  end

  it 'should get from cookies' do
    params = {}
    cookies = {filter_customer_id: 1, filter_employee_id: 1, filter_time_interval: 'custom', filter_from_time: '2013-6-30', filter_to_time: '2013-7-7'}

    cooks, customer, employee, interval, from, to = Dashboard::Wall.process_parameters params, cookies
    expect(customer).to eq @c1
    expect(employee).to eq @e1
    expect(interval).to eq 'custom'
    expect(from).to eq '2013-6-30'
    expect(to).to eq '2013-7-7'
  end


end