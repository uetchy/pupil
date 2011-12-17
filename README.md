pupil
=============

Pupil is "Lazy" Twitter API Library for Ruby 1.9.x.
Easy to use.

Features/Problems
-------------

* Almost Twitter REST API are wrapped. However, some API does not support yet.
* Twitter Streaming API are supported experimentally.
* Intuitive syntax.

Requirement
-------------

* json and oauth gem
* Ruby 1.9.x

Installation
-------------

	gem install pupil

Examples
-------------
	require "pupil"
	
	CONSUMER = {
		:app_name => "Web Service",     # Optional
		:app_author => "o_ame",         # Optional
		:consumer_key => "something",   # Required
		:consumer_secret => "something" # Required
	}
	
	pupil_key = {
		:screen_name => "o_ame",            # Required
		:access_token => "something",       # Required
		:access_token_secret => "something" # Required
	}.update CONSUMER
	
	pupil = Pupil.new pupil_key
	
	# Get timeline status without replies
	pupil.home_timeline :count => 50, :exclude => :replies
	
	# Follow User
	pupil.follow :screen_name  => :twitterapi
	
	# Update URL on profile
	pupil.update_profile :url  => "http://oameya.com"

Using Streaming API

	require "pupil/stream"
	
	CONSUMER = {
		:app_name => "Web Service",
		:app_author => "o_ame",
		:consumer_key => "something",
		:consumer_secret => "something"
	}
	
	pupil_key = {
		:screen_name => "o_ame",
		:access_token => "something",
		:access_token_secret => "something"
	}.update CONSUMER
	
	stream = Pupil::Stream.new pupil_key
	
	# Userstream
	stream.start :userstream do |status|
		puts status.type #=> Show type of status
		if status.type == :retweeted
			puts "#{status.content['user']['screen_name']: #{status.content['text']}"
		end
	end
	
	# Search stream
	stream.start :filter, :track => "#MerryChristmas" do |status|
		puts "#{status['user']['screen_name']: #{status['text']}"
	end

Making `pupil_key`

	require "pupil/keygen"
	
	keygen = Pupil::Keygen.new
	keygen.interactive #=> Generate pupil_key interactively

Contributing to pupil
-------------

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
-------------

Copyright (c) 2011 Oame. See LICENSE.txt for
further details.

