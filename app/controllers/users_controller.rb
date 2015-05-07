class UsersController < ApplicationController

	def show
		@user = User.find(params[:id])
	end

    def new
    	@user = User.new
    end

    def create
    	@user = User.new(user_params) #同ファイル内で定義したprivateのuser_paramsメソッドで限られたパラメータのみフォームで受け取っている
    								  #こうすることによりadminパラメータなどをブロックしている。
    	if @user.save
    		flash[:success] = "Welcome to the Sample App!!!"
    		redirect_to @user
    	else
    		render 'new'
    	end
    end

    private

    def user_params
    	params.require(:user).permit(:name, :email, :password, :password_confirmation)
    	#ここでStrong Parameterの概念を取り込んでいる。必要なパラメータのみ与えている。
    end
end
