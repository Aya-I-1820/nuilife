# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # パスワード未入力なら current_password なしで更新
  def update_resource(resource, params)
    if params[:password].present? || params[:password_confirmation].present?
      super # ← パスワードを変えるときは従来通り（current_password 必須）
    else
      params.delete(:current_password)
      resource.update_without_password(params)
    end
  end

  # 更新後はユーザープロフィールに戻す（お好みで）
  def after_update_path_for(resource)
    user_path(resource)
  end
end
