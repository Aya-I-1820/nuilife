class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :nuis, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_many :follows, dependent: :destroy
  has_many :followed_nuis, through: :follows, source: :nui

  has_one_attached :avatar 

  has_many :messages, dependent: :destroy

  
end
