class Post < ApplicationRecord
  belongs_to :nui 
  has_one_attached :image 

  has_many :comments, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  alias_attribute :body, :post  # post.body で本文にアクセスできる

  validates :post, presence: true   # ← これで空保存を防止
  
  enum status: { published: 0, draft: 1 }
  scope :published, -> { where(status: [Post.statuses[:published], nil]) }

end
