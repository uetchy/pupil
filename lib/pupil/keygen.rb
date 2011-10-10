# -*- coding: utf-8 -*-

class Pupil
  class Keygen
    class MissingRequiedTokens < StandardError; end
    
    def initialize opts={}
      @con_key = opts[:consumer_key] rescue nil
      @con_sec = opts[:consumer_secret] rescue nil
      @act_key = opts[:access_token] rescue nil
      @act_sec = opts[:access_token_secret] rescue nil
    end
    
    def access_token
      raise MissingRequiedTokens, "Keygen#access_token require consumer_key and consumer_secret" unless @con_key && @con_sec
    end
    
    def interactive
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