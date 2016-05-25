class Movie < ActiveRecord::Base
  validates :title, :director, :description, :release_date, presence: true
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

  def self.search(title=nil, director=nil, duration)
    if duration == "90"
      where('title LIKE ? AND director LIKE ? AND runtime_in_minutes < ?', "%#{title}%", "%#{director}%", duration)
    elsif duration == "120"
      where('title LIKE ? AND director LIKE ? AND runtime_in_minutes > ?', "%#{title}%", "%#{director}%", duration)
    elsif duration == "between 90 and 120"
      where('title LIKE ? AND director LIKE ? AND runtime_in_minutes between 90 and 120', "%#{title}%", "%#{director}%")
    else
      all
    end
  end

  protected

  def release_date_in_the_past
    if release_date.present?
      errors.add(:release_date, "should be in the past") if release_date > Date.today
    end
  end

end
