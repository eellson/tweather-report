require 'redis'

class TweetCount
  
  redisUri = ENV["REDISTOGO_URL"] || 'redis://localhost:6379'
  uri = URI.parse(redisUri) 
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  
  def initialize
    @db = REDIS
  end
  
  def incr(location)
    @db.incr(location)
  end
  
  def incr_weather(location)
    @db.incr(location + ' weather')
  end
  
  def incr_negative(location)
    @db.incr(location + ' negative')
  end
  
  def count(location)
    @db.get(location)
  end
  
  def weather_count(location)
    @db.get(location + ' weather')
  end
  
  def negative_count(location)
    @db.get(location + ' negative')
  end
  
  def percentage(location)
    negative = self.negative_count(location).to_f
    total = self.count(location).to_f
    ((negative / total) * 100).round(3)
  end
end