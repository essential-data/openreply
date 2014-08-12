# encoding: utf-8

require 'rails_helper'
require 'vcr_setup'

describe Otrs::Article, :vcr do

  let(:ticket_id) { 45420 }
  let(:invalid_ticket_id) { 12345 }
  let(:customer) { ENV['OPENREPLY_OTRS_SPECS_CUSTOMER'] }
  let(:employee_firstname) { ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME3'] }
  let(:employee_lastname) { ENV['OPENREPLY_OTRS_SPECS_LASTNAME3'] }

  describe '::alternative_possible_max_ratings_amount' do
    it 'should return barely all count of tickets' do
      if (Otrs.using_otrs?)
        count = Otrs::Article.max_ratings_count('2014-02-17', '2014-07-20')
        expect(count).to eq ENV['OPENREPLY_OTRS_SPECS_ARTICLES_COUNT'].to_i
      end
    end

    it 'should return 0 because of wrong customer' do
      if (Otrs.using_otrs?)
        count = Otrs::Article.max_ratings_count('2014-02-17', '2014-07-20', Customer.find_or_create_by_name('asdas'))
        expect(count).to eq 0
      end
    end
  end

end
