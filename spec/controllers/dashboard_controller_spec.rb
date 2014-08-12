# encoding: utf-8

require 'rails_helper'
require 'vcr_setup'

describe DashboardController, :vcr, :type => :controller do
  # let(:rating) { FactoryGirl.create ...}

  context "user logged in" do
    login_admin

    describe "admin actions" do
      render_views

      it "should have a current_user" do
        expect(subject.current_user).not_to be_nil
      end

    end

    describe "GET #employees_list" do
      it "successfully responds to request" do
        get :employees_list
        expect(response).to be_success
      end

      it "assigns employees with statistics" do
        get :employees_list
        expect(assigns(:employees)).to be_an_instance_of Array
      end

    end

    describe "GET #customers_list" do
      it "successfully responds to request" do
        get :customers_list
        expect(response).to be_success
      end

      it "assigns customers with statistics" do
        get :customers_list
        expect(assigns(:customers)).to be_an_instance_of Array
      end

    end

  end
end