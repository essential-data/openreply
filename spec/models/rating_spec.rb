# encoding: utf-8

require 'rails_helper'
require 'vcr_setup'

describe Rating, :vcr, :type => :model do
  include FeatureMacros

  context "sculpture of rating" do
    it "should require a customer" do
      expect { create(:rating, customer_id: nil) }.to raise_exception
    end

    it "does not require a ticket id" do
      expect { create(:rating, ticket_id: nil) }.to_not raise_exception
    end

    it "should require a employee name" do
      expect { create(:rating, employee: nil) }.to raise_exception
    end

    it "should require an integer rated value" do
      expect { create(:rating, int_value: nil) }.to raise_exception
    end

    it "should require an integer value from range" do
      expect { create(:rating, int_value: 999) }.to raise_exception
      expect { create(:rating, int_value: -6) }.to raise_exception
    end
  end

  context "building" do

    context 'from ticket values ip ' do
      before :each do
        @ticket_details = {}
        @ticket_details['customer'] = "ED"
        @ticket_details['employee_first_name'] = ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME']
        @ticket_details['employee_last_name'] = ENV['OPENREPLY_OTRS_SPECS_LASTNAME']
        @ticket_details['ticket_id'] = '44312'
      end

      it 'from ticket values ip with otrs' do
        if Otrs.using_otrs?
          rating = Rating.new_from_ticket_and_rated_values_and_ip @ticket_details, 4, "Vsetko je super", '192.168.1.150'
          c = Customer.find_or_create_by_name "ED"
          e = Employee.find_or_create_by_first_name_and_last_name ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME'], ENV['OPENREPLY_OTRS_SPECS_LASTNAME']

          expect(rating.customer).to eq c
          expect(rating.ticket_id).to eq '44312'
          expect(rating.employee).to eq e
          expect(rating.int_value).to be 4
          expect(rating.text_value).to eq "Vsetko je super"
          expect(rating.client_ip).to eq "192.168.1.150"
        end
      end

      it 'from ticket values ip no otrs' do
        Settings.otrs_api.enabled = false
        @ticket_details['customer'] = "FX"
        @ticket_details['employee_first_name'] = "Marina"
        @ticket_details['employee_last_name'] = "Bodkova"
        @ticket_details['ticket_id'] = '1234'


        rating = Rating.new_from_ticket_and_rated_values_and_ip @ticket_details, 4, "Vsetko je super", '192.168.1.150'
        c = Customer.find_or_create_by_name "FX"
        e = Employee.find_or_create_by_first_name_and_last_name "Marina", "Bodkova"

        expect(rating.customer).to eq c
        expect(rating.ticket_id).to eq '1234'
        expect(rating.employee).to eq e
        expect(rating.int_value).to be 4
        expect(rating.text_value).to eq "Vsetko je super"
        expect(rating.client_ip).to eq "192.168.1.150"
      end

      context 'should not build', skip: !Otrs.using_otrs? do
        it 'wrong employee' do
          @ticket_details['employee_first_name'] = "Marian"

          Settings.otrs_api.enabled = true
          rating = Rating.new_from_ticket_and_rated_values_and_ip @ticket_details, 4, "Vsetko je super", '192.168.1.150'
          expect(rating).to be_nil
        end

        it 'wrong rating' do
          Settings.otrs_api.enabled = true
          rating = Rating.new_from_ticket_and_rated_values_and_ip @ticket_details, 999, "Vsetko je super", '192.168.1.150'
          rating.save
          expect(rating.errors.messages.count).to be > 0
        end

      end

    end

    context 'from name and ticket and employee' do

      it 'with otrs' do
        rating = Rating.new_from_customer_and_ticket_and_employee("ED", 44312, ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME'], ENV['OPENREPLY_OTRS_SPECS_LASTNAME'])
        c = Customer.find_or_create_by_name "ED"
        e = Employee.find_or_create_by_first_name_and_last_name ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME'], ENV['OPENREPLY_OTRS_SPECS_LASTNAME']

        expect(rating.customer).to eq c
        expect(rating.ticket_id).to eq 44312
        expect(rating.employee).to eq e
      end

      it 'without otrs' do
        Settings.otrs_api.enabled = false
        rating = Rating.new_from_customer_and_ticket_and_employee("ED", 1234, ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME'], ENV['OPENREPLY_OTRS_SPECS_LASTNAME'])
        c = Customer.find_or_create_by_name "ED"
        e = Employee.find_or_create_by_first_name_and_last_name ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME'], ENV['OPENREPLY_OTRS_SPECS_LASTNAME']
        expect(rating.customer).to eq c
        expect(rating.ticket_id).to eq 1234
        expect(rating.employee).to eq e
      end

      context 'should not build', skip: !Otrs.using_otrs? do
        it 'wrong otrs' do
          rating= Rating.new_from_customer_and_ticket_and_employee("ED", 4321, ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME'], ENV['OPENREPLY_OTRS_SPECS_LASTNAME'])
          expect(rating).to be_nil
        end

        it 'wrong employee' do
          Settings.otrs_api.enabled = true
          rating= Rating.new_from_customer_and_ticket_and_employee("ED", 44312, "Marian", "Maly")
          expect(rating).to be_nil
        end

        it 'wrong customer' do
          Settings.otrs_api.enabled = true
          rating= Rating.new_from_customer_and_ticket_and_employee("QW", 44312, ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME'], ENV['OPENREPLY_OTRS_SPECS_LASTNAME'])
          expect(rating).to be_nil
        end

        it 'wrong customer' do
          Settings.otrs_api.enabled = true
          rating= Rating.new_from_customer_and_ticket_and_employee("QW", 44312, ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME'], ENV['OPENREPLY_OTRS_SPECS_LASTNAME'])
          expect(rating).to be_nil
        end
      end
    end
  end

  context "filtering" do

    before :each do
      db_init
      @from = 7.days.ago.strftime("%Y-%-m-%-d")
      @to = Date.current.strftime("%Y-%-m-%-d")
    end

    it 'should filter from to detailed' do

      @from = 7.days.ago.strftime("%Y-%-m-%-d")

      rating = Dashboard::FilteredRatings.new Customer.find_by_name("Janko Hraško"), Employee.find_by_first_name_and_last_name('Janko', 'Marienka'), "week", @from, @to

      expect(rating.ratings.count).to be 2
      expect(rating.ratings_older.count).to be 1
      expect(rating.filter.employee_first_name).to eq 'Janko'
      expect(rating.filter.employee_last_name).to eq 'Marienka'

      @from = 2.days.ago.strftime("%Y-%-m-%-d")

      rating = Dashboard::FilteredRatings.new Customer.find_by_name("Janko Hraško"), Employee.find_by_first_name_and_last_name('Janko', 'Marienka'), "week", @from, @to
      expect(rating.ratings.count).to be 0
      expect(rating.ratings_older.count).to be 2

    end
    it 'should filter all customers' do
      rating = Dashboard::FilteredRatings.new nil, Employee.find_by_first_name_and_last_name('Janko', 'Marienka'), "week", @from, @to
      expect(rating.ratings.count).to be 2
      expect(rating.ratings_older.count).to be 3
    end

    it 'should filter all employees' do
      rating = Dashboard::FilteredRatings.new Customer.find_by_name("Janko Hraško"), nil, "week", @from, @to
      expect(rating.ratings.count).to be 3
      expect(rating.ratings_older.count).to be 2
    end

    it 'should filter all' do
      rating = Dashboard::FilteredRatings.new nil, nil, "week", @from, @to
      expect(rating.ratings.count).to be 24
      expect(rating.ratings_older.count).to be 4
    end

    it 'should contain filter' do
      rating = Dashboard::FilteredRatings.new Customer.find_by_name("Janko Hraško"), nil, "week", @from, @to

      expect(rating.filter.customer_name).to eq 'Janko Hraško'
      expect(rating.filter.employee_first_name).to eq ''
      expect(rating.filter.employee_last_name).to eq 'all'
      expect(rating.filter.interval).to eq 'week'
      @from = Date.parse @from
      @to = Date.parse @to
      expect(rating.filter.from).to eq @from
      expect(rating.filter.to).to eq @to
    end

  end

  context "rated rating" do
    it "should print short text rating of rated" do
      rating = build(:rated)
      expect(rating.text_value_short).to include("...")
    end
    it "should print full text rating of rated" do
      rating = build(:rated, text_value: "super")
      expect(rating.text_value_short).not_to include("...")
    end

    it "should save valid rating to DB" do
      expect { create(:rated) }.to change { Rating.count }.by(1)
    end

    it "should find all customers" do
      c1 = Customer.find_or_create_by_name "Janko Hraško"
      c2 = Customer.find_or_create_by_name "Jurko Hraško"
      c3 = Customer.find_or_create_by_name "Ferko Mrkvička"

      create(:rated, customer: c1)
      create(:rated, customer: c2)
      create(:rated, customer: c3)
      create(:rated, customer: c1)

      expect(Rating.customers).to match_array([["Janko Hraško", c1.id], ["Jurko Hraško", c2.id], ["Ferko Mrkvička", c3.id]])
    end

    it "should filter ratings based on customer" do
      c1 = Customer.find_or_create_by_name "Janko Hraško"
      c2 = Customer.find_or_create_by_name "Jurko Hraško"
      c3 = Customer.find_or_create_by_name "Ferko Mrkvička"

      create(:rated, customer: c1)
      create(:rated, customer: c2)
      create(:rated, customer: c3)
      create(:rated, customer: c1)
      expect(Rating.filter_by_customer(c1).length).to be(2)
    end

    it "should find all employees" do
      e1 = Employee.find_or_create_by_first_name_and_last_name "Janko", "Hraško"
      e2 = Employee.find_or_create_by_first_name_and_last_name "Ferko", "Mrkvička"
      e3 = Employee.find_or_create_by_first_name_and_last_name "Jurko", "Hraško"

      create(:rated, employee: e1)
      create(:rated, employee: e3)
      create(:rated, employee: e2)
      create(:rated, employee: e1)
      expect(Rating.employees).to match_array([["Janko Hraško", e1.id], ["Jurko Hraško", e3.id], ["Ferko Mrkvička", e2.id]])
    end

    it "should filter ratings based on employee" do
      e1 = Employee.find_or_create_by_first_name_and_last_name "Janko", "Hraško"
      e2 = Employee.find_or_create_by_first_name_and_last_name "Ferko", "Mrkvička"
      e3 = Employee.find_or_create_by_first_name_and_last_name "Jurko", "Hraško"

      create(:rated, employee: e1)
      create(:rated, employee: e3)
      create(:rated, employee: e2)
      create(:rated, employee: e1)
      expect(Rating.filter_by_employee(e1).length).to be(2)
    end

    it "should filter ratings based time" do
      create(:rated, created_at: "2014-02-1")
      create(:rated, created_at: "2014-01-1")
      create(:rated, created_at: "2014-02-5")
      create(:rated, created_at: "2014-01-12")
      expect(Rating.where(created_at: "2013-02-1" .. "2014-02-1").length).to be(3)
    end
  end

  describe "#employee_first_name" do
    it "returns first name" do
      e1 = Employee.find_or_create_by_first_name_and_last_name "Ferko", "Mrkvička"
      rating = build(:rating, employee: e1)
      expect(rating.employee_first_name).to eq "Ferko"
    end
  end

  describe "#employee_last_name" do
    it "returns last name" do
      e1 = Employee.find_or_create_by_first_name_and_last_name "Ferko", "Mrkvička"
      rating = build(:rating, employee: e1)
      expect(rating.employee_last_name).to eq "Mrkvička"
    end
  end
end