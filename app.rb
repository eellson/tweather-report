require 'sinatra'

require File.join(File.dirname(__FILE__), 'tweet_store')
require File.join(File.dirname(__FILE__), 'tweet_count')

STORE = TweetStore.new
COUNT = TweetCount.new

get '/' do
  @tweets = STORE.tweets
  @gb_count = COUNT.count('GB')
  @row_count = COUNT.count('ROW')
  @negative_gb_count = COUNT.negative_count('GB')
  @negative_row_count = COUNT.negative_count('ROW')
  @weather_gb_count = COUNT.weather_count('GB')
  @weather_row_count = COUNT.weather_count('ROW')
  @gb_percentage = COUNT.percentage('GB')
  @row_percentage = COUNT.percentage('ROW')
  erb :index
end

get '/latest' do
  # We're using a Javascript variable to keep track of the time the latest
  # tweet was received, so we can request only newer tweets here. Might want
  # to consider using Last-Modified HTTP header as a slightly cleaner
  # solution (but requires more jQuery code).
  @tweets = STORE.tweets(5, (params[:since] || 0).to_i)
  
  @tweet_class = 'latest'  # So we can hide and animate
  erb :tweets, :layout => false
end

get '/counts' do
  @gb_count = COUNT.count('GB')
  @row_count = COUNT.count('ROW')
  @negative_gb_count = COUNT.negative_count('GB')
  @negative_row_count = COUNT.negative_count('ROW')
  @weather_gb_count = COUNT.weather_count('GB')
  @weather_row_count = COUNT.weather_count('ROW')
  @gb_percentage = COUNT.percentage('GB')
  @row_percentage = COUNT.percentage('ROW')
  erb :counts, :layout => false
end