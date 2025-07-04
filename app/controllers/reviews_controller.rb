class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_instrument

  def create
    @review = Review.new(review_params)
    @review.user = current_user
    @review.instrument = @instrument
    if @review.save
      redirect_to instrument_path(@instrument), notice: "Review added successfully!"
    else
      @reviews = @instrument.reviews.includes(:user)
      flash.now[:alert] = "There was a problem with your review. Please check the form."
      render "instruments/show", status: :unprocessable_entity
    end
  end

  private

  def set_instrument
    @instrument = Instrument.find(params[:instrument_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
