class RegistrationsController < Devise::RegistrationsController

  protected

    def after_inactive_sign_up_path_for(resource)
      new_user_session_path
    end

    def after_update_path_for(resource)
      account_path(resource)
    end

end
