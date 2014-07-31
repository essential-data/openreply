# encoding: utf-8

require 'spec_helper'
require 'vcr_setup'

describe RatingsController, :vcr, :type => :controller do

  describe "GET #new_validated_by_hash" do

    it "successfully responds to request" do
      get :new_validated_by_hash, ticket_id: 44312, hash: 'b87a6e4a8f7ea94e32ef03313e29e8c9'
      if Otrs.using_otrs?
        expect(response).to be_success
        expect(response).to render_template :new
      else
        assert_response 404
      end
    end

    it "assigns parameters", skip: !Otrs.using_otrs? do
      get :new_validated_by_hash, ticket_id: 44312, hash: 'b87a6e4a8f7ea94e32ef03313e29e8c9'
      expect(assigns(:rating)).to be_an_instance_of Rating
    end

    context 'invalid parameters' do
      it 'has wrong hash' do
        get :new_validated_by_hash, ticket_id: 44312, hash: 'b87a6e4a8f7ea94e32ef03313e29e8c8'
        assert_response 404
      end

      it 'has wrong ticket_id' do
        get :new_validated_by_hash, ticket_id: 1234, hash: 'b87a6e4a8f7ea94e32ef03313e29e8c9'
        assert_response 404
      end

      it 'has no ticket_id' do
        expect(get: :new_validated_by_hash, hash: 'b87a6e4a8f7ea94e32ef03313e29e8c9').not_to be_routable
      end
      it 'has no hash' do
        expect(get: :new_validated_by_hash, ticket_id: 1234).not_to be_routable
      end
    end

  end

  describe "GET #new_from_personal_details" do
    context 'with otrs', skip: !Otrs.using_otrs? do

      it "successfully responds to request" do
        get :new_from_personal_details, {ticketID: '44426', firstname: ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME2'], lastname: ENV['OPENREPLY_OTRS_SPECS_LASTNAME2'], customer: 'essential-data'}
        expect(response).to be_success
        expect(response).to render_template :new
      end

      it "assigns parameters" do
        get :new_from_personal_details, {ticketID: '44426', firstname: ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME2'], lastname: ENV['OPENREPLY_OTRS_SPECS_LASTNAME2'], customer: 'essential-data'}
        expect(assigns(:rating)).to be_an_instance_of Rating
      end

      it 'no customer' do
        get :new_from_personal_details, {ticketID: '44426', firstname: ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME2'], lastname: ENV['OPENREPLY_OTRS_SPECS_LASTNAME2']}
        expect(response).to be_success
      end

      context 'wrong parameters' do
        it 'no ticket_id' do
          get :new_from_personal_details, {firstname: ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME2'], lastname: ENV['OPENREPLY_OTRS_SPECS_LASTNAME2'], customer: 'essential-data'}
          assert_response 404
        end

        it 'wrong ticket_id' do
          get :new_from_personal_details, {ticketID: '44425', firstname: ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME2'], lastname: ENV['OPENREPLY_OTRS_SPECS_LASTNAME2'], customer: 'essential-data'}
          assert_response 404
        end

        it 'no first name' do
          get :new_from_personal_details, {ticketID: '44426', lastname: ENV['OPENREPLY_OTRS_SPECS_LASTNAME2'], customer: 'essential-data'}
          assert_response 404
        end

        it 'no last name' do
          get :new_from_personal_details, {ticketID: '44426', firstname: ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME2'], customer: 'essential-data'}
          assert_response 404
        end
      end
    end

    context 'without otrs' do
      before :each do
        Otrs.stub(:using_otrs?).and_return false
      end

      it 'wrong ticket_id' do
        get :new_from_personal_details, {ticketID: '44425', firstname: "Pan", lastname: "Novy", customer: 'essential-data'}
        #expect(assigns(:rating)).to be_an_instance_of Rating
        expect(response).to render_template :new
      end

      it 'no ticket_id' do
        get :new_from_personal_details, {firstname: "Pan", lastname: "Novy", customer: 'essential-data'}
        expect(response).to render_template :new
      end
    end
  end

  describe "POST #create" do

    let(:params) do
      {
          rating: {
              text: "Super",
              value: "3",
              customer: "ED",
              ticket_id: "44312",
              employee_first_name: ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME'],
              employee_last_name: ENV['OPENREPLY_OTRS_SPECS_LASTNAME']
          }
      }
    end

    context "valid params" do
      it "successfully responds to request by redirect" do
        post :create, params
        expect(response).to redirect_to Settings.redirect_to_webpage
      end

      it "saves new rating to db" do
        expect { post(:create, params) }.to change { Rating.count }.by 1
      end

      it 'store cookies' do
        post :create, params
        expect(response.cookies["Rated #{ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME']} #{ENV['OPENREPLY_OTRS_SPECS_LASTNAME']} by ED on 44312"]).to eq "rated"
      end

      it 'sends mail' do
        Settings.new_rating_notifications_emails = true
        expect { post :create, params }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context "invalid ratings" do
      it "does not save to db invalid ticket", skip: !Otrs.using_otrs? do
        allow_any_instance_of(Rating).to receive(:valid_personal_details?).and_return(false)
        expect { post :create, params }.not_to change { Rating.count }
      end

      it 'rated recently' do
        request.cookies["Rated #{ENV['OPENREPLY_OTRS_SPECS_FIRSTNAME']} #{ENV['OPENREPLY_OTRS_SPECS_LASTNAME']} by ED on 44312"] ="rated"
        expect { post :create, params }.not_to change { Rating.count }
      end
    end
  end
end
