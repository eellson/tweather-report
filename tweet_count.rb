require 'redis'

class TweetCount
  
  def initialize
    @db = Redis.new
  end
  
  def incr_gb
    @db.incr('GB')
    puts "GB count" + @db.get('GB')
  end
  
  def incr_row
    @db.incr('ROW')
    puts "ROW count" + @db.get('ROW')
  end
  
  def gb_count
    @db.get('GB')
  end
  
  def row_count
    @db.get('ROW')
  end
end