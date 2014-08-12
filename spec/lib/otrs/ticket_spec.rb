# encoding: utf-8

require 'rails_helper'
require 'vcr_setup'

describe Otrs::Ticket, :vcr, skip: !Otrs.using_otrs? do

  let(:ticket_id) { 3333 }
  let(:ticket_number) { "2008040710000171" }
  let(:customer) { "Coca Cola" }
  let(:employee_firstname) { "Testy" }
  let(:employee_lastname) { "Tester" }

  describe "::find" do
    context "ticket exists" do
      it "returns a ticket by id" do
        ticket = Otrs::Ticket.find(ticket_id)
        expect(ticket.id).to eq ticket_id
        expect(ticket.tn).to eq ticket_number
      end
    end

    context "ticket does not exist" do
      it "raises an error" do
        expect do
          ticket = Otrs::Ticket.find(999999999999999999999999999)
        end.to raise_error(Otrs::IDNotFoundError)
      end
    end
  end

  describe '::count' do
    it 'should return barely all count of tickets' do
      count= Otrs::Ticket.count '2014-02-17', '2014-07-20'
      expect(count).to eq 2909
    end
  end

  describe "::new" do
    it "creates a new instance of ticket" do
      ticket_hash = {id: ticket_id, tn: ticket_number, customer: customer,
                     employee_firstname: employee_firstname, employee_lastname: employee_lastname}
      ticket = Otrs::Ticket.new ticket_hash

      expect(ticket.id).to eq ticket_id
      expect(ticket.tn).to eq ticket_number
      expect(ticket.customer).to eq customer
      expect(ticket.employee_firstname).to eq employee_firstname
      expect(ticket.employee_lastname).to eq employee_lastname
    end
  end
end
