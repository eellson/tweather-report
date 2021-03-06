require 'json'
require 'redis'
require File.join(File.dirname(__FILE__), 'tweet')

class TweetStore

  redisUri = ENV["REDISTOGO_URL"] || 'redis://localhost:6379'
  uri = URI.parse(redisUri) 
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

  
  REDIS_KEY = 'tweets'
  NUM_TWEETS = 5
  MAX_SIZE = 50
  
  def initialize
    @db = REDIS
    @trim_count = 0
  end
  
  # Retrieves the specified number of tweets, but only if they are more recent
  # than the specified timestamp.
  def tweets(limit=15, since=0)
    @db.lrange(REDIS_KEY, 0, limit - 1).collect {|t|
      Tweet.new(JSON.parse(t))
    }.reject {|t| t.received_at <= since}
  end
  
  def push(data)
    @db.lpush(REDIS_KEY, data.to_json)
    @trim_count += 1
    if (@trim_count > MAX_SIZE)
      # Periodically trim the list so it doesn't grow too large.
      @db.ltrim(REDIS_KEY, 0, NUM_TWEETS)
      @trim_count = NUM_TWEETS
    end
  end
  
end
