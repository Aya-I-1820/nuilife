class UsersController < ApplicationController
  before_action :set_user

  def show
    # 管理しているぬい
    @managed_nuis = @user.nuis
                         .includes(avatar_attachment: :blob)
                         .order(created_at: :desc)

    # フォロー中のぬい
    @followed_nuis = @user.followed_nuis
                          .includes(avatar_attachment: :blob, user: {})
                          .order("follows.created_at DESC")
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
