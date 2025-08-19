class Comment < ApplicationRecord
  belongs_to :nui
  belongs_to :post

  validates :content, presence: true, length: { maximum: 300 }
end
