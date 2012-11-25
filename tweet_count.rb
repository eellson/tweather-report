require 'redis'

class TweetCount
  
  def initialize
    @db = Redis.new
  end
  
  def incr(location)
    @db.incr(location)
  end
  
  def incr_negative(location)
    @db.incr(location + ' negative')
  end
  
  def count(location)
    @db.get(location)
  end
  
  def negative_count(location)
    @db.get(location + ' negative')
  end
end