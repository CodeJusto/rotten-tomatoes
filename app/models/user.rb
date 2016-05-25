class User < ActiveRecord::Base
  has_secure_password

  has_many :reviews, dependent: :destroy

  def full_name
    "#{firstname} #{lastname}"
  end
  
end
