#!/usr/bin/env ruby
# coding: utf-8
# tested on 1.9.x

require "pupil/stream"
require "yaml"

oauth_key = {
  :consumer_key => "",
  :consumer_secret => "",
  :access_token => "",
  :access_token_secret => ""
}

ps = Pupil::Stream.new oauth_key

ps.start :userstream do |status|
  puts "#{status.user.screen_name}: #{status.text}"
end
