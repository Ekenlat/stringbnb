class InstrumentsController < ApplicationController
  # On ne s'authentifie pas pour voir la liste des instruments
  # mais on doit être authentifié pour toute autre action concernant les instruments
  skip_before_action :authenticate_user!, only: :index

  def index
    # affiche uniquement les instruments avec une adresse géocodée
    @instruments = Instrument.geocoded
    # Recherche globale sur nom, type, adresse
    if params[:search].present?
      @instruments = @instruments.where(
        "name ILIKE :query OR instrument_type ILIKE :query OR address ILIKE :query",
        query: "%#{params[:search]}%"
      )
    end

    # filtre par ville (city)
    if params[:city].present?
      @instruments = @instruments.where("address ILIKE ?", "%#{params[:city]}%")
    end

    # filtre prix min
    if params[:price_min].present?
      @instruments = @instruments.where("price_per_day >= ?", params[:price_min])
    end

    # filtre prix max
    if params[:price_max].present?
      @instruments = @instruments.where("price_per_day <= ?", params[:price_max])
    end

    # fFiltre catégorie/type
    if params[:category].present?
      @instruments = @instruments.where(instrument_type: params[:category])
    end

    # on prépare un tableau des marqueurs avec latitude/longitude pour mapbox
    @markers = @instruments.select { |i| i.latitude.present? && i.longitude.present? }.map do |instrument|
      {
        lat: instrument.latitude,
        lng: instrument.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { instrument: instrument }),
        marker_html: render_to_string(partial: "marker", locals: { instrument: instrument })
      }
    end
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
    params.require(:instrument).permit(
    :name, :address, :description, :size, :instrument_type, :price_per_day, :status, photos: [])
  end
end
