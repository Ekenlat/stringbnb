class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: -> { Rails.env.development? }
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters

    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :address, :phone_number])

    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :address, :phone_number])

  end

  if Rails.env.development?
    def current_user
      User.first # ou User.find_by(email: "audric@test.com")
    end

    def user_signed_in?
      true
    end
  end
end
