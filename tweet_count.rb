require 'redis'

class TweetCount
  
  def initialize
    @db = Redis.new
  end
  
  def incr_gb(sentiment)
    @db.incrby('GB', sentiment)
    puts "GB count" + @db.get('GB')
  end
  
  def incr_row(sentiment)
    @db.incrby('ROW', sentiment)
    puts "ROW count" + @db.get('ROW')
  end
  
  def gb_count
    @db.get('GB')
  end
  
  def row_count
    @db.get('ROW')
  end
end