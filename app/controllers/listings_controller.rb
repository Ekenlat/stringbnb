class ListingsController < ApplicationController
  before_action :authenticate_user!

  def my_listings
    @listings = current_user.listings
  end
end
