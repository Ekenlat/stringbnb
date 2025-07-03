class InstrumentsController < ApplicationController
  # On ne s'authentifie pas pour voir la liste des instruments
  # mais on doit être authentifié pour toute autre action concernant les instruments
  skip_before_action :authenticate_user!, only: :index

  def index
    @instruments = Instrument.all
  end

  def show
    @instrument = Instrument.find(params[:id])
    if user_signed_in?
    @booking = Booking.find_by(user: current_user, instrument: @instrument)
    end
  end

  def new
    @instrument = Instrument.new
  end

  def dashboard
    @instruments = current_user.instruments
  end

  def create
    @instrument = Instrument.new(instrument_params)
    @instrument.user = current_user

    if @instrument.save
      redirect_to @instrument, notice: 'Instrument was successfully created.'
    else
      flash.now[:alert] = 'There was an error while creating the instrument.'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @instrument = current_user.instruments.find(params[:id])
  end

  def update
    @instrument = current_user.instruments.find(params[:id])
    if @instrument.update(instrument_params)
      redirect_to @instrument, notice: "Instrument updated successfully."
    else
      flash.now[:alert] = "There was an error while updating the instrument."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def instrument_params
    params.require(:instrument).permit(:name, :description, :size, :instrument_type, :price_per_day, photos: [])
  end
end
