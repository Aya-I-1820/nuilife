class Nui < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  has_one_attached :avatar  # アイコン画像をつけたい場合（Active Storage）

  has_many :follows,   dependent: :destroy
  has_many :followers, through: :follows, source: :user
  
  validates :name, presence: true, length: { maximum: 30 }
  validates :profile, length: { maximum: 300 }, allow_blank: true

  validate :acceptable_avatar

  private
  def acceptable_avatar
    return unless avatar.attached?

    if avatar.byte_size > 3.megabytes
      errors.add(:avatar, "は3MB以下にしてください")
    end
    acceptable_types = ["image/png", "image/jpeg", "image/webp"]
    unless acceptable_types.include?(avatar.content_type)
      errors.add(:avatar, "は PNG/JPEG/WEBP をアップロードしてください")
    end
  end
end
