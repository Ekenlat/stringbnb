class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @instrument = Instrument.find(params[:instrument_id])
    @review = Review.new(review_params)
    @review.user = current_user
    @review.instrument = @instrument
    if review.save
      redirect_to instrument_path(@instrument)
    else
      @reviews = @instrument.reviews
      render 'instruments/show', status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating)
  end
end
