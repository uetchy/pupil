#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'oauth'

class Pupil
  def self.keygen
    print "Enter OAuth Consumer_Key: "
    oauth_consumer_key = gets.chomp.strip
    print "Enter OAuth Consumer_Secret: "
    oauth_consumer_secret = gets.chomp.strip

    CONSUMER_KEY = oauth_consumer_key
    CONSUMER_SECRET = oauth_consumer_secret

    consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, :site => 'http://twitter.com')

    request_token = consumer.get_request_token

    puts "Access to this URL and approve: #{request_token.authorize_url}"

    print "Enter OAuth Verifier: "
    oauth_verifier = gets.chomp.strip

    access_token = request_token.get_access_token(:oauth_verifier => oauth_verifier)

    puts "Process complete!"
    puts "Access token: #{access_token.token}"
    puts "Access token secret: #{access_token.secret}"
  end
end