# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  def facebook
    handle_auth "Facebook"
  end

  def google_oauth2
    handle_auth "Google"
  end

  def failure
    redirect_to root_path, alert: "Authentication failed, please try again."
  end

  private

  def handle_auth(kind)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      session["devise.#{kind.downcase}_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url, alert: "There was a problem signing you in through #{kind}. Please register or try signing in later."
    end
  end
end
