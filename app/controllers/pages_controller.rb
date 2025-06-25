class PagesController < ApplicationController
  # On ne s'authentifie pas pour la page d'accueil
  skip_before_action :authenticate_user!, only: :home

  def home
  end
end
