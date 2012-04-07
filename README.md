Pupil
=============

Pupil is "Lazy" Twitter API Library for Ruby 1.9.x.

Features
-------------

* Almost Twitter REST API are wrapped. However, some API does not support yet.
* Twitter Streaming API are supported experimentally.
* Intuitive syntax.

Problems
-------------

* Some REST API are not supported.

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
	
	oauth_key = {
		:consumer_key => "something",
		:consumer_secret => "something",
		:access_token => "something",
		:access_token_secret => "something"
	}
  
	pupil = Pupil.new oauth_key
	
	# Get timeline statuses without replies
	pupil.timeline :count => 50, :exclude => :replies
	
	# Follow User
	pupil.follow :twitterapi
	
	# Update URL on profile
	pupil.update_profile :url => "http://oameya.com"

Using Streaming API

	require "pupil/stream"
	
	oauth_key = {
		:consumer_key => "something",
		:consumer_secret => "something",
		:access_token => "something",
		:access_token_secret => "something"
	}
	
	stream = Pupil::Stream.new oauth_key
	
	# Userstream
	stream.start :userstream do |status|
		if status.event == :retweeted
			puts "This is retweeted status! => #{status.text}"
		end
	end
	
	# Search stream
	stream.start :search, :track => "#MerryChristmas" do |status|
		puts "Merry christmas, #{status.user.screen_name}!"
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

Credits
-------------

Developer: [Oame](http://twitter.com/o_ame)

License
-------------

Copyright (c) 2011 Oame. See LICENSE.txt for
further details.

