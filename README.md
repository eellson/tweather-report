Tweather report
===============

Tweather report aims to prove whether or not Brits moan about the weather more than 
average.

Tweather report combines basic redis usage with the Twitter streaming 
API (through the [TweetStream](https://github.com/intridea/tweetstream) gem), 
Google Maps Javascript API, and the [Sentiment140](http://help.sentiment140.com/api) 
API. It seems to work. Of course there's a touch of not-that-pretty styling. It 
probably has alot of room for improvement.

I used [twatcher-lite](https://github.com/digitalhobbit/twatcher-lite) to get 
started on a twitter streaming sinatra app. It needed a little fixing.

Should be able to get it running locally by ensuring you have redis server 
running and then running foreman start. You'll also have to put twitter 
application details in .env.

This is the first thing I've built really so comments are welcome.