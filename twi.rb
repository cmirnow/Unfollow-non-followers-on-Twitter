require 'twitter'

class Twi
  def self.client
    config = {
      # Enter Twitter API access here:
      consumer_key: '******************',
      consumer_secret: '*******************',
      access_token: '***************************',
      access_token_secret: '************************'
    }
    Twitter::REST::Client.new config
  end

  def self.user_id
    # Enter your twitter nickname here:
    'twitter_nickname'
  end

  # Get a list of your account followers:
  def self.get_followers(*args)
    follower_ids = []
    next_cursor = -1
    while next_cursor != 0
      cursor = args[0].follower_ids(args[1], cursor: next_cursor)
      follower_ids.concat cursor.attrs[:ids]
      next_cursor = cursor.send(:next_cursor)
    end
    followers = []
    follower_ids.each_slice(100) do |ids|
      followers.concat args[0].users(ids)
    end
    followers.map { |user| puts "adding follower to an array: #{user.screen_name}" }
    followers
  end

  # Get a list of your account friends:
  def self.get_friends(*args)
    friend_ids = []
    next_cursor = -1
    while next_cursor != 0
      cursor = args[0].friend_ids(args[1], cursor: next_cursor)
      friend_ids.concat cursor.attrs[:ids]
      next_cursor = cursor.send(:next_cursor)
    end
    friends = []
    friend_ids.each_slice(100) do |ids|
      friends.concat args[0].users(ids)
    end
    friends.map { |user| puts "adding friend to an array: #{user.screen_name}" }
    friends
  end

  # Unfollowing Twitter accounts:
  def self.unfollow(client, list)
    list.take(1000).each do |user|
      client.unfollow(user.id)
      puts "unfollow: #{user.screen_name} #{Time.now}"
      sleep rand(1..5)
    end
  end

  # Get a list of unfollowing accounts
  def self.list
    get_friends(client, user_id) - get_followers(client, user_id)
  end
end

Twi.unfollow(Twi.client, Twi.list)
