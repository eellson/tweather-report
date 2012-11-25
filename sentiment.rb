# This could work as a standalone for getting the sentiment of tweets with a 
# bit of tweaking, but I'm unsure of how I'd use it from the rest of the app 
# so for now this is unused.

require 'json'
require 'net/http'

uri = URI('http://www.sentiment140.com/api/bulkClassifyJson')
params = {'data' => [{'text' => 'I love Titanic.'}]}.to_json
req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
req.body = params

res = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.request(req)
end

p JSON.parse(res.body)['data'][0]['polarity']