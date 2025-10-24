class Post < ApplicationRecord
  validates :user_id, presence: true
  validates :text, presence: true, length: { maximum: 1000 }
  validates :images, presence: false
  validate :correct_image_mime_type
  validate :image_size_limit

  has_many_attached :images
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  scope :of_followed_users, ->(following_users) { where user_id: following_users }

  def correct_image_mime_type
    if images.attached?
      images.each do |img|
        unless img.content_type.in?(%w[image/jpeg image/png image/gif image/jpg])
          errors.add(:images, "must be JPEGs, PNGs, JPG or GIFs")
        end
      end
    end
  end

  def image_size_limit
    if images.attached?
      images.each do |img|
        if img.byte_size > 5.megabytes # Example: 5MB limit
          errors.add(:images, "each image size needs to be less than 5MB")
        end
      end
    end
  end
end
