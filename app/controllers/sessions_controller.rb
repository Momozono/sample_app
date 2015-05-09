class SessionsController < ApplicationController

	def new
	end

	def create #設計的にはSigninボタンを押すとcreateメソッドが呼び出されることになっている
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password]) #userがnilではなく、かつauthenticatでtrueが返ってきたら
			#ユーザをサインインさせる
			sign_in user
			redirect_back_or user
		else
			flash.now[:error] = "Invalid email/password combination"
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end

