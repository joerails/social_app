class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

has_many :microposts, dependent: :destroy
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
    validates :password_confirmation, presence: true
    after_validation { self.errors.messages.delete(:password_digest) }


    def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end
    
private

	def create_remember_token
	#must use self to avoid creating a local variable
	  self.remember_token = SecureRandom.urlsafe_base64

	end
end
