class InstrumentsController < ApplicationController
  # On ne s'authentifie pas pour voir la liste des instruments
  # mais on doit être authentifié pour toute autre action concernant les instruments
  skip_before_action :authenticate_user!, only: :index

  def index
    @instruments = Instrument.all
  end

  def show
    @instrument = Instrument.find(params[:id])
    @bookings = @instrument.bookings if current_user == @instrument.user
  rescue ActiveRecord::RecordNotFound
    redirect_to instruments_path, alert: 'Instrument not found.'
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

  def destroy
    @instrument = current_user.instruments.find(params[:id])
    @instrument.destroy
    redirect_to dashboard_path, notice: 'Instrument supprimé avec succès.'
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_path, alert: 'Instrument not found or you do not have permission to delete it.'
  end

  private

  def instrument_params
    params.require(:instrument).permit(:name, :description, :size, :instrument_type, :price_per_day, photos: [])
  end
end
