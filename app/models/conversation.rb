# app/models/conversation.rb
class Conversation < ApplicationRecord
  belongs_to :user1, class_name: "User"
  belongs_to :user2, class_name: "User"
  has_many :messages, dependent: :destroy

  validate :different_users
  validates :user1_id, :user2_id, presence: true
  validates :user1_id, uniqueness: { scope: :user2_id }

  # 2人のidを昇順にして重複を防ぐ
  before_validation :normalize_pair

  def participants
    [user1, user2]
  end

  def includes?(user)
    user1_id == user.id || user2_id == user.id
  end

  private
  def normalize_pair
    return if user1_id.blank? || user2_id.blank?
    a, b = [user1_id, user2_id].minmax
    self.user1_id, self.user2_id = a, b
  end

  def different_users
    errors.add(:base, "自分自身とは会話を作成できません") if user1_id.present? && user1_id == user2_id
  end
end
