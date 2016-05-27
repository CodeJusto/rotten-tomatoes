class Movie < ActiveRecord::Base
  validates :title, :director, :description, :release_date, :image, presence: true
  validates :runtime_in_minutes, numericality: { only_integer: true }
  validate :release_date_in_the_past

  has_many :reviews

  mount_uploader :image, ImageUploader

  scope :search, ->(search) { where("title LIKE ? OR director LIKE ?", "%#{search}%",  "%#{search}%") }
  
  # scope :title, ->(title) { where("title LIKE ?", "%#{title}%") }
  # scope :director, ->(director) { where('director LIKE ?', "%#{direcor}%") }
  
  def review_average
    if reviews.count > 0
      "#{reviews.sum(:rating_out_of_ten)/reviews.size}/10"
    else
      "No reviews submitted yet!"
    end
  end

  def self.movie_duration(duration)
    if duration == "90"
      where('runtime_in_minutes < ?', duration)
    elsif duration == "120"
      where('runtime_in_minutes > ?', duration)
    elsif duration == "between 90 and 120"
      where('runtime_in_minutes > 90')
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
