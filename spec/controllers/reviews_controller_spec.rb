# encoding: utf-8

require 'rails_helper'
require 'vcr_setup'

describe ReviewsController, :vcr, :type => :controller do
  login_admin

  let(:rating) { create :rating }
  let(:rating_without_review) { create :rating }
  let(:review) { create :review, rating: rating, ignored_rating: true }


  describe "GET #new" do
    context 'valid parameters' do
      it "successfully responds to request" do
        get :new, rating_id: rating.id
        expect(response).to render_template :new
        xhr :get, :new, rating_id: rating.id
        expect(response).to render_template :new
      end

      it "assigns parameters" do
        get :new, rating_id: rating.id
        expect(assigns(:review)).to be_an_instance_of Review
        expect(assigns(:review).rating).to eq rating
        expect(assigns(:review).id).to be_nil
        xhr :get ,:new, rating_id: rating.id
        expect(assigns(:review)).to be_an_instance_of Review
        expect(assigns(:review).rating).to eq rating
        expect(assigns(:review).id).to be_nil
      end

    end

    context 'invalid parameters' do
      it 'wrong rating id' do
        get :new, rating_id: -1
        assert_response 404
        xhr :get, :new, rating_id: -1
        assert_response 404
      end
    end
  end

  describe "GET #edit" do
    context 'valid parameters' do
      it "successfully responds to request" do
        # get edit_rating_review_path(rating, review)
        get :edit, rating_id: rating, id: review
        expect(response).to render_template :new
        xhr :get, :edit, rating_id: rating, id: review
        expect(response).to render_template :new
      end

      it "assigns parameters" do
        get :edit, rating_id: rating, id: review
        expect(assigns(:review)).to be_an_instance_of Review
        expect(assigns(:review).rating).to eq rating
        expect(assigns(:review).id).to eq review.id
        xhr :get,:edit, rating_id: rating, id: review
        expect(assigns(:review)).to be_an_instance_of Review
        expect(assigns(:review).rating).to eq rating
        expect(assigns(:review).id).to eq review.id
      end
    end

    context 'invalid parameters' do
      it 'wrong review id' do
        get :edit, rating_id: rating, id: -1
        assert_response 404
        xhr :get, :edit, rating_id: rating, id: -1
        assert_response 404
      end
    end
  end

  describe "#UPDATE" do
    context 'valid parameters' do
      it 'should create new' do
        r_count = Review.count
        xhr :patch, :update, rating_id: rating_without_review, format: "js"
        expect(Review.count - r_count).to eq 1
      end

      it 'POST should update existing' do
        xhr :post, :update, rating_id: rating, review: {text: "Hello", ignored_rating: false}, format: "js"
        expect(assigns(:review).rating).to eq rating
        expect(assigns(:review).text).to eq "Hello"
        expect(assigns(:review).ignored_rating).to eq false
      end

      it 'PATCH should update existing' do
        xhr :patch, :update, rating_id: rating, review: {text: "Hello", ignored_rating: false}, format: "js"
        expect(assigns(:review).rating).to eq rating
        expect(assigns(:review).text).to eq "Hello"
        expect(assigns(:review).ignored_rating).to eq false
      end

      it 'PUT should update existing' do
        xhr :put, :update, rating_id: rating, review: {text: "Hello", ignored_rating: false}, format: "js"
        expect(assigns(:review).rating).to eq rating
        expect(assigns(:review).text).to eq "Hello"
        expect(assigns(:review).ignored_rating).to eq false
      end

      it 'should assigns parameters' do
        xhr :patch, :update, rating_id: rating_without_review, review: {text: "Hello", ignored_rating: true}, format: "js"
        expect(assigns(:review)).to be_an_instance_of Review
        expect(assigns(:review).rating).to eq rating_without_review
        expect(assigns(:review).text).to eq "Hello"
        expect(assigns(:review).ignored_rating).to eq true
      end
    end

    context 'invalid params' do
      it 'wrong rating' do
        xhr :post, :update, rating_id: -1
        assert_response 404
      end
    end
  end
end
