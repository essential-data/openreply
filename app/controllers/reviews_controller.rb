class ReviewsController < ApplicationController

  def new
    rating = Rating.find_by_id(params[:rating_id])
    if !rating
      render_404
    else
      @review = rating.review || rating.build_review()
      respond_to do |format|
        format.html
      end
    end
  end

  def update
    rating = Rating.find_by_id(params[:rating_id])
    if !rating
      render_404
    else
      @review = rating.review || rating.build_review()
      @review.assign_attributes(ignored_rating: params[:review][:ignored_rating], text: params[:review][:text]) if params[:review]

      if @review.save
        respond_to do |format |
          format.js {flash.now[:notice] = (t "rating.review.success"); render "shared/messages"}
        end
      else
        respond_to do |format |
          format.js {flash.now[:error] = (t "rating.review.error"); render "shared/messages"}
        end
      end
    end
  end

  def edit
    @review = Review.find_by_id(params[:id])
    if @review
      respond_to do |format|
        format.html {  render :new }
      end
    else
      render_404
    end
  end
end
