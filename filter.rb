require 'tweetstream'

require File.join(File.dirname(__FILE__), 'tweet_store')
load File.join(File.dirname(__FILE__), 'twitter_authentication.rb')

STORE = TweetStore.new
WORDS = IO.read('weather_words.txt')

TweetStream::Client.new.locations(-180,-90,180,90) do |status|
  # Ignore replies
  if (status.text !~ /^@\w+/ && status.text =~ /\s+(#{WORDS})\s+/)
    STORE.push(
          'id' => status[:id],
          'text' => status.text,
          'username' => status.user.screen_name,
          'userid' => status.user[:id],
          'name' => status.user.name,
          'profile_image_url' => status.user.profile_image_url,
          'created_at' => status.created_at,
          'received_at' => Time.new.to_i,
          'place_name' => status.place.name,
          'coordinates' => status.place.bounding_box.coordinates
    )
  end
end
