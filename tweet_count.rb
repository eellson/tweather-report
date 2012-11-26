require 'redis'

class TweetCount
  
  def initialize
    @db = Redis.new
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
  
  def ratio(location)
    negative = self.negative_count(location).to_f
    total = self.count(location).to_f
    (negative / total).round(4)
  end
  
  
end