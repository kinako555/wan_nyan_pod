User.create!(name:  "Example User",
    email: "example@railstutorial.org",
    password:              "foobar",
    password_confirmation: "foobar",
    admin: true,
    activation_state: 'active',
    activation_token_expires_at: Time.zone.now)

User.create!(name:  "わんにゃんぽっど太郎",
    email: Rails.application.credentials.yahoo[:address],
    password:              "foobar",
    password_confirmation: "foobar",
    activation_state: 'active',
    activation_token_expires_at: Time.zone.now)

30.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    User.create!(name:  name,
                    email: email,
                    password:              password,
                    password_confirmation: password,
                    activation_state: true,
                    activation_token_expires_at: Time.zone.now)
end

# User最初の6人を呼ぶ
users = User.order(:created_at).take(6)
10.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
end

# リレーションシップ
users = User.all
first_user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| first_user.follow(followed) }
followers.each { |follower| follower.follow(first_user) }

other_microposts = Micropost.all.where.not(user_id: first_user.id)
sharering_microposts = other_microposts[1..10]
favoriting_microposts = other_microposts[11..20]
sharering_microposts.each  { |shared|    first_user.share_micropost(shared) }
favoriting_microposts.each { |favorited| first_user.favorite_micropost(favorited) }

users.each { |user| user.activate! }

User.create!(name:  "NotActive User",
    email: "aaa@bbb.org",
    password:              "foobar",
    password_confirmation: "foobar",
    activation_state: 'pending',
    activation_token_expires_at: Time.zone.now)