require "rubygems"
require "net/http"
require "uri"
require "oauth"
require "json"

class Pupil
  attr_reader :screen_name
  class UnsupportedParameter < StandardError ; end
  class NetworkError < StandardError ; end
  
  TWITTER_API_URL = "http://api.twitter.com"

  # @param [Hash] pupil_key
  def initialize key
    @screen_name = key[:screen_name]
    @client = nil
    @config = nil
    
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

  # @param [Hash] parameter
  # @return [String] URL Serialized parameters
  def self.param_serializer parameter
    return "" unless parameter.class == Hash
    ant = Hash.new
    parameter.each do |key, value|
      case key.to_sym
      when :include
        if value.class == String || Symbol
          ant[:"include_#{value}"] = :true
          break
        end

        value.each do |element|
          raise UnsupportedParameter, "include_entities is not supported." if element.to_sym == :entities
          ant[:"include_#{element}"] = :true
        end
      when :exclude
        if value.class == String || Symbol
          ant[:"exclude_#{value}"] = :true
          break
        end

        value.each do |element|
          ant[:"exclude_#{element}"] = :true
        end
      else
        ant[key.to_sym] = value.to_s
      end
    end
    param = ant.inject(""){|k,v|k+"&#{v[0]}=#{URI.escape(v[1])}"}.sub!(/^&/,"?")
    return param ? param : ""
  end
  
  def param_serializer parameter
    Pupil.param_serializer parameter
  end
  
  def get url, param={}
    param_s = param_serializer(param)
    begin
      response = @access_token.get(url+param_s).body
    rescue => vars
      raise NetworkError, vars
    end
    return JSON.parse(response)
  end
  
  def post url, param={}
    param_s = param_serializer(param)
    begin
      response = @access_token.post(url+param_s).body
    rescue => vars
      raise NetworkError, vars
    end
    return JSON.parse(response)
  end
end