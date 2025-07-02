class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_instrument

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.user = current_user
    @review.instrument = @instrument
    if @review.save
      redirect_to @instrument, notice: "Review added!"
    else
      render :new, status: :unprocessable_entity
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
