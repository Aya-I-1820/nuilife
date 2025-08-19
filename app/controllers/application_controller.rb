class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :profile])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :profile])
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource)
    new_user_session_path  # 例：ログイン画面に飛ばす
  end

  def current_nui
    @current_nui ||= current_user.nuis.find_by(id: session[:current_nui_id])
  end
  helper_method :current_nui

end
