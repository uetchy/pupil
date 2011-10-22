# -*- coding: utf-8 -*-

class Pupil
  class Keygen
    attr_reader :con_key
    attr_reader :con_sec
    attr_reader :act_key
    attr_reader :act_sec
    class MissingRequiredTokens < StandardError; end

    def initialize opts={}
      @con_key = opts[:consumer_key] rescue nil
      @con_sec = opts[:consumer_secret] rescue nil
      @act_key = opts[:access_token] rescue nil
      @act_sec = opts[:access_token_secret] rescue nil
    end
    
    def get_auth_url
      raise MissingRequiredTokens, "Pupil::Keygen#get_auth_url require consumer_key and consumer_secret when initialized" unless @con_key || @con_sec
      consumer = OAuth::Consumer.new(@con_key, @con_sec, :site => 'http://twitter.com')
      request_token = consumer.get_request_token
      return request_token.authorize_url
    end
    
    def issue_token verifier
      raise MissingRequiredTokens, "Pupil::Keygen#get_auth_url require consumer_key and consumer_secret when initialized" unless @con_key || @con_sec
      consumer = OAuth::Consumer.new(@con_key, @con_sec, :site => 'http://twitter.com')
      request_token = consumer.get_request_token
      access_token = request_token.get_access_token(:oauth_verifier => verifier)
      @act_key = access_token.token
      @act_sec = access_token.secret
      return {:access_token => access_token.token, :access_token_secret => access_token.secret}
    end

    def interactive
      print "Enter OAuth Consumer Key: " unless @con_key
      @con_key = gets.chomp.strip unless @con_key
      print "Enter OAuth Consumer Secret: " unless @con_sec
      @con_sec = gets.chomp.strip unless @con_sec

      consumer = OAuth::Consumer.new(@con_key, @con_sec, :site => 'http://twitter.com')

      request_token = consumer.get_request_token

      puts "Access to this URL and approve: #{request_token.authorize_url}"

      print "Enter OAuth Verifier: "
      oauth_verifier = gets.chomp.strip

      access_token = request_token.get_access_token(:oauth_verifier => oauth_verifier)
      @act_key = access_token.token
      @act_sec = access_token.secret

      puts "Process complete!"
      puts "Access token: #{access_token.token}"
      puts "Access token secret: #{access_token.secret}"
      return {:access_token => access_token.token, :access_token_secret => access_token.secret}
    end
  end
end