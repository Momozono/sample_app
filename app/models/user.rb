class User < ActiveRecord::Base

	has_many :microposts, dependent: :destroy

	before_save { self.email = email.downcase } #コールバック　DBに保存する前に必ずダウンケースしてくれる
	before_create :create_remember_token

	validates :name,  presence: true, length: { maximum: 50} #validate of name

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i #validate of email
	validates :email, presence: true, 
					  format: { with: VALID_EMAIL_REGEX },
					  uniqueness: { case_sensitive: false }

	has_secure_password #これによってauthenticate(digestと比較)を実装、password_onfirmaton検証
	validates :password, length: { minimum: 6 } #validate of password

	def User.new_remember_token
		SecureRandom.urlsafe_base64 #RubyのSecureRandomクラスのメソッド
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def feed
		Micropost.where("user_id = ?", id ) 
	end


	private

	  def create_remember_token
	  	self.remember_token = User.encrypt(User.new_remember_token)
	  end
end