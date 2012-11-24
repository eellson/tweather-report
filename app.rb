require 'sinatra'

require File.join(File.dirname(__FILE__), 'tweet_store')
require File.join(File.dirname(__FILE__), 'tweet_count')

STORE = TweetStore.new
COUNT = TweetCount.new

get '/' do
  @tweets = STORE.tweets
  @gb_count = COUNT.gb_count
  @row_count = COUNT.row_count
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
  @gb_count = COUNT.gb_count
  puts "@gb_count " + @gb_count
  @row_count = COUNT.row_count
  erb :counts, :layout => false
end