require "rubygems"
require "net/http"
require "uri"
require "oauth"
require "json"

class Pupil
  attr_reader :screen_name
  class NetworkError < StandardError ; end
  
  TWITTER_API_URL = "http://api.twitter.com"

  # @param [Hash] pupil_key
  def initialize key
    @screen_name = key[:screen_name]

    @consumer = OAuth::Consumer.new(
      key[:consumer_key],
      key[:consumer_secret],
      :site => TWITTER_API_URL
    )
    @access_token = OAuth::AccessToken.new(
    @consumer,
      key[:access_token],
      key[:access_token_secret]
    )
  end
  
  include Essentials
end