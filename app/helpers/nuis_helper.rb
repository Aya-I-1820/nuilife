module NuisHelper
  # 丸アイコンを出す共通ヘルパー
  #   size: ピクセル（整数）…例: 40, 64, 128
  #   class_name: 追加クラス
  def avatar_for(nui, size: 64, class_name: "")
    if nui.avatar.attached?
      # 正方形にトリミングしてから表示（顔が中心に来やすい）
      image_tag nui.avatar.variant(resize_to_fill: [size, size]),
                class: "avatar-circle #{class_name}",
                alt: nui.name
    else
      # 画像が無い時のプレースホルダー（頭文字）
      content_tag :div, nui.name.to_s.first(2),
        class: "avatar-circle avatar-placeholder #{class_name}",
        style: "width:#{size}px;height:#{size}px;line-height:#{size}px;",
        title: nui.name
    end
  end
end
