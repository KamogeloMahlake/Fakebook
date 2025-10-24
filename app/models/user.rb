class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [ :google_oauth2, :github ]

  validate :correct_image_mime_type
  validate :image_size_limit
  has_one_attached :image

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :follower_relationships, foreign_key: :following_id, class_name: "Follow"
  has_many :followers, through: :follower_relationships, source: :follower
  has_many :following_relationships, foreign_key: :follower_id, class_name: "Follow"
  has_many :following, through: :following_relationships, source: :following
  has_many :likes, dependent: :destroy

  def follow(user_id)
    following_relationships.create(following_id: user_id)
  end

  def unfollow(user_id)
    following_relationships.find_by(following_id: user_id).destroy
  end

  def correct_image_mime_type
    if image.attached? && !image.content_type.in?(%w[image/jpeg image/png image/gif image/jpg image/webp])
      errors.add(:image, "must be a JPEG, JPG, PNG, or GIF")
    end
  end

  def image_size_limit
    if image.attached? && image.byte_size > 5.megabytes # Example: 5MB limit
      errors.add(:image, "size needs to be less than 5MB")
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.user_name = auth.info.name
    end
  end
end
