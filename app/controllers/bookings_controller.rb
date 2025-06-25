class BookingsController < ApplicationController
  before_action :set_instrument, only: %i[new create]
  before_action :authenticate_user!

  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.user = current_user
    @booking.instrument = @instrument
    @booking.total_price = (@booking.ending_date - @booking.starting_date).to_i * @instrument.price_per_day

    if @booking.save
      redirect_to dashboard_path, notice: "Booking created successfully !"
    else
      flash.now[:alert] = "The booking could not be created. Please check the fields below."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_instrument
    @instrument = Instrument.find(params[:instrument_id])
  end

  def booking_params
    params.require(:booking).permit(:starting_date, :ending_date)
  end
end
