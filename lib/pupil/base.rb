require "rubygems" if RUBY_VERSION < "1.9.0"
require "net/http"
require "uri"
require "oauth"
require "json"

class Pupil
  attr_reader :screen_name
  class NetworkError < StandardError ; end
  
  TWITTER_API_URL = "https://api.twitter.com"

  # @param [Hash] pupil_key
  def initialize key
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

    @screen_name = key[:screen_name] || nil
  end
  
  include Essentials
end