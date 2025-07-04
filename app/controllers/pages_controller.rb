class PagesController < ApplicationController
  # On ne s'authentifie pas pour la page d'accueil
  skip_before_action :authenticate_user!, only: :home

  def home
  end

  def dashboard
    # bookings que l'user a reservé ( hors cancelled)
    @bookings = current_user.bookings.where.not(status: "cancelled").includes(:instrument).order(starting_date: :asc)
  end
end
