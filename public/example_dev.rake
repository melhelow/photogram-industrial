require_relative '../config/boot'
require_relative '../config/application'
Rails.application.require_environment!

desc "Fill the database tables with some sample data"
task :sample_data do
  starting = Time.now

  # Clean up existing uploaded files
  FileUtils.rm_rf(Rails.root.join("public", "uploads"))

  # Safely destroy records if associations exist
  if defined?(FollowRequest)
    FollowRequest.destroy_all
  end

  if defined?(Comment)
    Comment.destroy_all
  end

  if defined?(Like)
    Like.destroy_all
  end

  if defined?(Photo)
    Photo.destroy_all
  end

  if defined?(User)
    User.destroy_all
  end

  people = Array.new(10) do
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
    }
  end

  people << { first_name: "Alice", last_name: "Smith" }
  people << { first_name: "Bob", last_name: "Smith" }
  people << { first_name: "Carol", last_name: "Smith" }
  people << { first_name: "Dave", last_name: "Smith" }
  people << { first_name: "Eve", last_name: "Smith" }

  people.each do |person|
    username = person.fetch(:first_name).downcase
    secret = false

    if ["alice", "carol"].include?(username) 
      secret = true
    end

    # Use safe avatar path
    avatar_number = rand(1..10)
    avatar_path = "#{Rails.root}/public/avatars/#{avatar_number}.jpeg"
    
    user = User.create(
      email: "#{username}@example.com",
      password: "password",
      username: username.downcase,
      name: "#{person[:first_name]} #{person[:last_name]}",
      bio: Faker::Lorem.paragraph(
        sentence_count: 2,
        supplemental: true,
        random_sentences_to_add: 4
      ),
      website: Faker::Internet.url,
      private: secret,
      avatar_image: File.exist?(avatar_path) ? File.open(avatar_path) : nil
    )
  end

  users = User.all

  users.each do |first_user|
    users.each do |second_user|
      next if first_user == second_user
      
      if rand < 0.75
        status = "accepted"
        if second_user.private? && rand < 0.5
          status = "pending"
        end
        
        first_user.sent_follow_requests.create(
          recipient: second_user,
          status: status
        ) if first_user.respond_to?(:sent_follow_requests)
      end
    end
  end

  # Modified photo creation section
  users.each do |user|
    rand(15).times do
      # Use safe photo path
      photo_number = rand(1..10)
      photo_path = "#{Rails.root}/public/photos/#{photo_number}.jpeg"
      
      photo = Photo.create(
        caption: Faker::Quote.jack_handey,
        image: File.exist?(photo_path) ? File.open(photo_path) : nil,
        owner: user
      )

      # Use a random subset of users for likes and comments
      random_users = users.sample(rand(users.count))
      
      random_users.each do |random_user|
        # Create likes
        if rand < 0.5
          Like.create(photo: photo, fan: random_user)
        end

        # Create comments
        if rand < 0.25
          Comment.create(
            body: Faker::Quote.jack_handey,
            author: random_user,
            photo: photo
          )
        end
      end
    end
  end

  ending = Time.now
  puts "It took #{(ending - starting).to_i} seconds to create sample data."
  puts "There are now #{User.count} users."
  puts "There are now #{FollowRequest.count} follow requests." if defined?(FollowRequest)
  puts "There are now #{Photo.count} photos."
  puts "There are now #{Like.count} likes." if defined?(Like)
  puts "There are now #{Comment.count} comments." if defined?(Comment)
end
