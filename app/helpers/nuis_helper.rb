module NuisHelper
  def avatar_for(nui, size: 100)
    if nui.avatar.attached?
      image_tag nui.avatar.variant(resize_to_fill: [size, size]).processed,
                class: "rounded-circle",
                alt: "#{nui.name}のアイコン"
    else
      image_tag "no_image.svg", size: "#{size}x#{size}",
                class: "rounded-circle",
                alt: "デフォルトアイコン"
    end
  end
end
