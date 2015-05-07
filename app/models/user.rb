class User < ActiveRecord::Base

	before_save { self.email = email.downcase } #コールバック　DBに保存する前に必ずダウンケースしてくれる

	validates :name,  presence: true, length: { maximum: 50} #validate of name

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i #validate of email
	validates :email, presence: true, 
					  format: { with: VALID_EMAIL_REGEX },
					  uniqueness: { case_sensitive: false }

	has_secure_password #これによってauthenticate(digestと比較)を実装、password_onfirmaton検証
	validates :password, length: { minimum: 6 } #validate of password
end