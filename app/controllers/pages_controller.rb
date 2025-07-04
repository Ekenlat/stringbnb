class PagesController < ApplicationController
  # On ne s'authentifie pas pour la page d'accueil
  skip_before_action :authenticate_user!, only: :home

  def home
  end

  def dashboard
    # bookings que l'user a reservé
    @bookings = current_user.bookings.includes(:instrument)
  end
end
