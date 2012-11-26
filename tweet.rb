class Tweet
  
  def initialize(data)
    @data = data
  end

  def user_link
    "http://twitter.com/#{username}"
  end

  private
  
  # So we can call tweet.text instead of tweet['text']
  def method_missing(name)
    @data[name.to_s]
  end
  
end