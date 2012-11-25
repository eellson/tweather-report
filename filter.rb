require 'tweetstream'
require 'net/http'

require File.join(File.dirname(__FILE__), 'tweet_store')
require File.join(File.dirname(__FILE__), 'tweet_count')

load File.join(File.dirname(__FILE__), 'twitter_authentication.rb')

STORE = TweetStore.new
WORDS = IO.read('weather_words.txt')
COUNT = TweetCount.new
SENTIMENT_URI = URI('http://www.sentiment140.com/api/bulkClassifyJson?appid=eellson@gmail.com')
REQ = Net::HTTP::Post.new(SENTIMENT_URI.path, initheader = {'Content-Type' =>'application/json'})

TweetStream::Client.new.locations(-180,-90,180,90) do |status|
  
  # tally tweets for GB and ROW
  if status.place.country_code == 'GB'
    COUNT.incr('GB')
  else
    COUNT.incr('ROW')
  end
  
  # put tweets about the weather in the tweet store
  if status.text =~ /\s+(#{WORDS})\s+/i
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
          'coordinates' => status.place.bounding_box.coordinates,
          'country_code' => status.place.country_code
    )
    
    # get sentiment of weather related tweets
    REQ.body = {'data' => [{'text' => status.text}]}.to_json
    res = Net::HTTP.start(SENTIMENT_URI.hostname, SENTIMENT_URI.port) do |http|
      http.request(REQ)
    end
    sentiment = JSON.parse(res.body)['data'][0]['polarity']
    
    # if tweet has negative sentiment increase negative tally for GB or ROW
    if sentiment == 0
      if status.place.country_code == 'GB'
        COUNT.incr_negative('GB')
      else
        COUNT.incr_negative('ROW')
      end
    end
  end
end
