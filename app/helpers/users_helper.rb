module UsersHelper
  def user_name(user)
    user.try(:name).presence || user.email
  end

  def user_avatar(user, size: 80)
    if user.respond_to?(:avatar) && user.avatar&.attached?
      image_tag user.avatar.variant(resize_to_fill: [size, size]).processed,
                class: "rounded-circle", alt: "#{user_name(user)}のアイコン"
    else
      image_tag "no_image.svg", size: "#{size}x#{size}",
                class: "rounded-circle", alt: "デフォルトアイコン"
    end
  end
end
