require 'spec_helper'

describe User do

	before do
		@user = User.new(name: "Example User", email: "user@example.com",
								password: "foobar", password_confirmation: "foobar") 
	end

	subject { @user }

	it { should respond_to(:name)  }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:remember_token) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:admin) }
	it { should respond_to(:microposts) }
	it { should respond_to(:feed) }




	it { should be_valid }
	it { should_not be_admin} 

	describe "with admin attribute set to 'true'" do
		before do
			@user.save!
			@user.toggle!(:admin)
		end

		it { should be_admin }
	end
	

	describe "when name is not present" do
		before { @user.name = " " }

		it { should_not be_valid }
	end

	describe "when name is not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end

	describe "when name is too long" do
		before { @user.name = "a" * 51 }
		it { should_not be_valid }
	end

	describe "when email format is inalid" do #ネストの一に気をつける
	  	it "shoudld be invalid" do 
			addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
		    addresses.each do | invalid_address |
		      @user.email = invalid_address
			  expect(@user).not_to be_valid
		    end
	  	end
	end

	describe "when email format is valid" do
		it " should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org foo.bar@foo.jp a+b@foobaz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				expect(@user).to be_valid
			end
		end
	end

	describe "when email is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it { should_not be_valid } #  beforeブロックで既に同じアドレスが保存されているので、無効となる。it => @user
	end

	describe "when password is not present" do
		before do
			@user = User.new(name: "Example User", email: "user@example.com",
									password: " ", password_confirmation: " " )
		end
		it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
		before do
			@user.password_confirmation = "mismatch"
		end
		it { should_not be_valid }
	end



	describe "with a password that's too short" do
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { should be_invalid }
	end

	describe "return value of authenticate method" do
		before { @user.save } #これで初めてfind_byメソッドが使えるようになる
		let(:found_user) { User.find_by(email: @user.email) } #@user.email => user@example.com

			describe "with valid password" do
				it { should eq found_user.authenticate(@user.password) } #@user.password => "foobar"
			end

			describe "with invalid password" do
				let(:user_for_invalid_password) { found_user.authenticate('invalid') } # "foobar"と"invalid"を比較してる
				it { should_not eq user_for_invalid_password }
				specify { expect(user_for_invalid_password).to be_false }
			end
	end

	describe "remember token" do
		before { @user.save }
		its(:remember_token) { should_not be_blank } #itsを使用すると@userではなく()で指定したsubjectで指定した@userのその属性について評価することができる
		
	end

	describe "micropost associations" do

		before { @user.save }
		let!(:older_micropost) do
			FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
		end

		let!(:newer_micropost) do
			FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
		end

		it "should have the right microposts in the right order" do
			expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
		end

		it "should destroy associated microposts" do
			microposts = @user.microposts.to_a
			@user.destroy
			expect(microposts).not_to be_empty
			microposts.each do |micropost|
				expect(Micropost.where(id: micropost.id)).to be_empty
			end
		end

		describe "status" do
	      let(:unfollowed_post) do
	        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
	      end

	      its(:feed) { should include(newer_micropost) }
	      its(:feed) { should include(older_micropost) }
	      its(:feed) { should_not include(unfollowed_post) }
	    end
	end
 end










