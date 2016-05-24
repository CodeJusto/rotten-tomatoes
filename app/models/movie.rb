class Movie < ActiveRecord::Base
  validates :title, :director, :description, :poster_image_url, :release_date, presence: true
  validates :runtime_in_minutes, numericality: { only_integer: true }
  validate :release_date_in_the_past

  has_many :reviews

  mount_uploader :image, ImageUploader

  def review_average
    if reviews.count > 0
      reviews.sum(:rating_out_of_ten)/reviews.size
    else
      "No reviews have been submitted yet!"
    end
  end

  protected

  def release_date_in_the_past
    if release_date.present?
      errors.add(:release_date, "should be in the past") if release_date > Date.today
    end
  end

end
