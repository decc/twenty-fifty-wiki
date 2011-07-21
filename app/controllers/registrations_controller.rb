class RegistrationsController < Devise::RegistrationsController
  def after_inactive_sign_up_path_for(resource)
    waiting_for_confirmation_user_url(resource)
  end
end