class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  if defined? Devise
    before_action do
      RequestStore[:current_user] = current_user
    end
  end

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  after_action :verify_authorized, unless: [:devise_controller?, :pages_controller?]

  protected

  def analytics
    Analytics.new(current_user)
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def configure_permitted_parameters
    added_attributes = [:first_name, :last_name]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attributes)
  end

  def pages_controller?
    controller_name == 'pages'
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:alert] = t("#{policy_name}.#{exception.query}", scope: 'pundit', default: :default)
    redirect_to(request.referrer || root_path)
  end
end
