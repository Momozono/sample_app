namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

=begin  
    admin = User.create!(name: "Example User",
                         email: "example@railstutorial.jp",
                         password: "foobar",
                         password_confirmation: "foobar",
                         admin: true)
    User.create!(name: "Example User",
                 email: "example@railstutorial.jp",
                 password: "foobar",
                 password_confirmation: "foobar")

    10.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.jp"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
=end

    users = User.all(limit: 6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content) }
    end
  end
end