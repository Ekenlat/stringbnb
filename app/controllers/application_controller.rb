class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: -> { Rails.env.development? } #this need to be removed in production
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :address, :phone_number])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :address, :phone_number])
  end

  if Rails.env.development? # all this need to be removed in production
    def current_user
      User.first || User.create!(
        email: "dev@test.com",
        first_name: "Dev",
        last_name: "User",
        address: "123 rue du Dev, Paris",
        phone_number: "0600000000",
        password: "azerty"
      )
    end

    def user_signed_in?
      true
    end
  end
end
