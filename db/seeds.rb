# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'open-uri'
def create_users(num_of_users)
  num_of_users.times do |i|
    user = User.new(
      email: Faker::Internet.unique.email,
      password: Faker::Internet.password(min_length: 8),
      user_name: Faker::Internet.unique.username(specifier: 5..8),
      bio: Faker::Lorem.sentence(word_count: 10),
    )
    user.save!
    begin
      if user.persisted?
        #avatar_image = Faker::LoremFlickr.image(size: "100x100", search_terms: ['face'])
        user.image.attach(io: URI.open('https://picsum.photos/100'), filename: "avatar_#{i}.jpg")
      end
      sleep(3)
    rescue
      next
    end
  end
end

def create_posts(num_of_posts, users)
  num_of_posts.times do |i|
    post = Post.new(
      text: Faker::Lorem.paragraph(sentence_count: 5),
      user: users.sample,
    )
    post.save!
    begin
      if post.persisted?
        images = []
        rand(1..3).times do |j|
          #post_image = Faker::LoremFlickr.image(size: "600x400", search_terms: ['nature'])
          images << { io: URI.open('https://picsum.photos/600/400'), filename: "post_#{i}_image_#{j}.jpg" }
          sleep(2)
        end
        post.images.attach(images)
      end
    rescue
      next
    end
  end
end

def create_comments(num_of_comments, users, posts)
  num_of_comments.times do |i|
    comment = Comment.new(
      content: Faker::Lorem.sentence(word_count: 15),
      user: users.sample,
      post: posts.sample
    )
    comment.save!
  end
end

def create_likes(num_of_likes, users, posts)
  num_of_likes.times do |i|
    begin
      like = Like.new(
      user: users.sample,
      post: posts.sample
    )
    like.save!
    rescue 
      next
    end
  end
end

def create_follows(user, users)
  num = users.count / 3
  user_to_follow = users.where.not(id: user.id).sample(num)
  user_to_follow.each do |followed_user|
    Follow.find_or_create_by!(follower: user, following: followed_user)
  end
end
# Clear existing data
'''Like.delete_all
Comment.delete_all
Post.delete_all
'''
def create_seed_data
  create_users(100)
  users = User.all

  create_posts(500, users)
  posts = Post.all

  create_comments(200, users, posts)
  create_likes(300, users, posts)
  users.all.each do |user|
    create_follows(user, users)
  end
end

create_seed_data()