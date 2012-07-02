class RegistrationsController < Devise::RegistrationsController
  def create
    if !verify_recaptcha
      flash.delete :recaptcha_error
      build_resource
      resource.valid?
      resource.errors.add(:base, "There was an error with the recaptcha code below. Please re-enter the code.")
      clean_up_passwords(resource)
      render 'devise/sessions/new'
    else
      flash.delete :recaptcha_error
      super
    end
  end
    
  def after_inactive_sign_up_path_for(resource)
    waiting_for_confirmation_user_url(resource)
  end
end
