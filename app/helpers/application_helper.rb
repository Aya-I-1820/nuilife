module ApplicationHelper
  def avatar_for(nui, size: 40)
    if nui.avatar.attached?
      image_tag nui.avatar.variant(resize_to_fill: [size, size]).processed, 
                class: "rounded-circle", 
                style: "width: #{size}px; height: #{size}px; object-fit: cover;"
    else
      content_tag :div, 
                  nui.name.first.upcase, 
                  class: "rounded-circle d-flex align-items-center justify-content-center text-white fw-bold",
                  style: "width: #{size}px; height: #{size}px; background-color: #6c757d; font-size: #{size * 0.4}px;"
    end
  end

  def nui_avatar_tag(nui, size: 40)
    if nui.avatar.attached?
      image_tag nui.avatar.variant(resize_to_fill: [size, size]).processed, 
                class: "rounded-circle", 
                style: "width: #{size}px; height: #{size}px; object-fit: cover;"
    else
      content_tag :div, 
                  nui.name.first.upcase, 
                  class: "rounded-circle d-flex align-items-center justify-content-center text-white fw-bold",
                  style: "width: #{size}px; height: #{size}px; background-color: #6c757d; font-size: #{size * 0.4}px;"
    end
  end

  def short_time(value)
    return "" if value.blank?
    I18n.l(value, format: :short)
  rescue StandardError
    if value.respond_to?(:strftime)
      value.strftime("%Y-%m-%d %H:%M")
    else
      value.to_s
    end
  end
end
