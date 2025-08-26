# app/models/follow.rb
class Follow < ApplicationRecord
  belongs_to :user
  belongs_to :nui
  validates :user_id, uniqueness: { scope: :nui_id }
  # 自分のぬいをフォロー不可にしたいなら:
  # validate :not_own_nui
  # def not_own_nui; errors.add(:base, "自分のぬいはフォローできません") if nui.user_id == user_id; end
end
