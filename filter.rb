require 'tweetstream'
require 'net/http'
require 'json'

require File.join(File.dirname(__FILE__), 'tweet_store')
require File.join(File.dirname(__FILE__), 'tweet_count')

load File.join(File.dirname(__FILE__), 'twitter_authentication.rb')

STORE = TweetStore.new
WORDS = IO.read('weather_words.txt')
COUNT = TweetCount.new
SENTIMENT_URI = URI('http://www.sentiment140.com/api/bulkClassifyJson?appid=eellson@gmail.com')
REQ = Net::HTTP::Post.new(SENTIMENT_URI.path, initheader = {'Content-Type' =>'application/json'})


# These puts are for debugging really, but as they are super handy I have left 
# them in for now.
TweetStream::Client.new.on_limit {|skip_count|
  puts "hey!"
}.on_enhance_your_calm {
  puts "calm " + Time.now.to_s
}.on_error {|message| 
  puts message
}.on_reconnect {|timeout, retries| 
  puts "Timeout: " + timeout.to_s + ", Retries: " + retries.to_s
}.locations(-180,-90,180,90) do |status|
  puts "yay! " + Time.now.to_s
  
  # filter only tweets with the 'place' field set. This seems to get rid of 
  # our reconecting/calm enhancing issues
  
  if status.place != nil
  
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
            'profile_image_url' => status.user.profile_image_url,
            'received_at' => Time.new.to_i,
            'place_name' => status.place.name,
            'coordinates' => status.place.bounding_box.coordinates,
            'country_code' => status.place.country_code
      )
  
      # tally weather related tweets
      if status.place.country_code == 'GB'
        COUNT.incr_weather('GB')
      else
        COUNT.incr_weather('ROW')
      end
  
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
end
