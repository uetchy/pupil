# -*- coding: utf-8 -*-

require "net/http"
require "rexml/document"
require "uri"
require "rubygems" if RUBY_VERSION < "1.9.0"
require "oauth"
#require "pp"

$LOAD_PATH << File.dirname(File.expand_path(__FILE__)) if RUBY_VERSION >= "1.9.0"
require "pupil/keygen"

class Pupil
  attr_reader :screen_name
  class UnsupportedParameter < StandardError; end

  # @param [Hash] pupil_key
  def initialize(pupil_key)
    @screen_name = pupil_key[:screen_name]
    @client = nil
    @config = nil
    consumer = OAuth::Consumer.new(
    pupil_key[:consumer_key],
    pupil_key[:consumer_secret],
    :site => "http://api.twitter.com"
    )
    @access_token = OAuth::AccessToken.new(
    consumer,
    pupil_key[:access_token],
    pupil_key[:access_token_secret]
    )
  end

  # @param [Hash] parameter
  # @return [String] URL Serialized parameters
  def param_serializer parameter
    ant = Hash.new
    parameter.each do |key, value|
      case key.to_sym
      when :include
        if value.class == String || Symbol
          ant[:"include_#{value}"] = :true
          break
        end

        value.each do |element|
          raise UnsupportedParameter, 'include_entities is not supported.' if element.to_sym == :entities
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
        ant[key.to_sym] = value
      end
    end
    param = ant.inject(""){|k,v|k+"&#{v[0]}=#{v[1]}"}.sub!(/^&/,"?")
    return param ? param : ""
  end

  class REXML::Document
    def is_error?
      if self.root.get_text("error") then
        return true
      else
        return false
      end
    end

    def get_error_message
      return self.root.get_text("error")
    end
  end

  public

  # @return [Hash] User credentials
  def verify_credentials
    response = @access_token.get('/account/verify_credentials.xml')
    doc = REXML::Document.new(response.body)
    return false if doc.is_error?
    user = User.new(doc.elements['/user'])
    return user
  end

  # Alias to Pupil#home_timeline
  # @param [Hash] param
  # @return [Array] Timeline
  # @deprecated Use {#home_timeline} instead of this method because
  #   is was obsoleted.
  def friends_timeline(param = {})
    param_s = param_serializer(param)
    begin
      response = @access_token.get("http://api.twitter.com/1/statuses/friends_timeline.xml"+param_s)
    rescue
      return false
    end
    doc = REXML::Document.new(response.body)
    return false if doc.is_error?
    statuses = Array.new

    doc.get_elements('/statuses/status').each do |element|
      status = Status.new(element)
      statuses << status
    end

    return statuses
  end

  # @param [Hash] param
  # @return [Array] Timeline
  def home_timeline(param = {})
    param_s = param_serializer(param)
    begin
      response = @access_token.get("http://api.twitter.com/1/statuses/home_timeline.xml"+param_s)
    rescue
      return false
    end
    doc = REXML::Document.new(response.body)
    return false if doc.is_error?
    statuses = Array.new
    doc.get_elements('/statuses/status').each{|element|
      status = Status.new(element)
      statuses << status
    }
    return statuses
  end

  # Returning user timeline
  # @param [Hash] param
  # @return [Hash] timeline
  # @option param [Fixnum] :user_id The ID of user
  # @option param [String] :screen_name The Screen name of user
  # @option param [Fixnum] :since_id
  # @option param [Fixnum] :max_id
  # @option param [Fixnum] :count
  # @option param [Fixnum] :page Specifies
  # @option param [Symbol] :trim_user
  # @option param [Symbol] :include #=> [:rts]
  # @option param [Symbol] :exclude #=> [:replies]
  # @option param [Symbol] :contributor_details
  # @example
  #   twitter = Pupil.new PUPIL_KEY
  #   twitter.user_timeline(:screen_name => 'o_ame', :exclude => :replies).each do |status|
  #     puts "#{status.user.screen_name}: #{status.text}"
  #   end
  def user_timeline(param = {})
    param_s = param_serializer(param)
    begin
      response = @access_token.get("http://api.twitter.com/1/statuses/user_timeline.xml"+param_s)
    rescue
      return false
    end
    doc = REXML::Document.new(response.body)
    return false if doc.is_error?
    statuses = Array.new
    doc.get_elements('/statuses/status').each{|element|
      status = Status.new(element)
      statuses << status
    }
    return statuses
  end

  # @param [Hash] param
  # @return [Hash] mention
  def mentions(param = {})
    param_s = param_serializer(param)
    begin
      response = @access_token.get("http://api.twitter.com/1/statuses/mentions.xml"+param_s)
    rescue
      return false
    end
    doc = REXML::Document.new(response.body)
    return false if doc.is_error?
    statuses = Array.new

    doc.get_elements('/statuses/status').each{|element|
      status = Status.new(element)
      statuses << status
    }

    return statuses
  end

  # Returning direct messages
  # @param [Hash] param
  # @return [Hash] directmessages
  def dm(param = {})
    param_s = param_serializer(param)
    begin
      response = @access_token.get("http://api.twitter.com/1/direct_messages.xml"+param_s)
    rescue
      return false
    end
    doc = REXML::Document.new(response.body)
    return false if doc.is_error?
    directmessages = Array.new

    doc.get_elements('/direct-messages/direct_message').each{|element|
      dm = DirectMessage.new(element)
      directmessages << dm
    }

    return directmessages
  end

  # Returning direct messages you sent
  # @param [Hash] param
  # @return [Hash] directmessage you sent
  def dm_sent(param = {})
    param_s = param_serializer(param)
    begin
      response = @access_token.get("http://api.twitter.com/1/direct_messages/sent.xml"+param_s)
    rescue
      return false
    end
    doc = REXML::Document.new(response.body)
    return false if doc.is_error?
    directmessages = Array.new

    doc.get_elements('/direct-messages/direct_message').each{|element|
      dm = DirectMessage.new(element)
      directmessages << dm
    }

    return directmessages
  end

  # Delete direct message
  # @param [Fixnum] dm_id message id that you want to delete
  # @return [Hash] response
  def dm_destroy(dm_id)
    begin
      response = @access_token.post("http://api.twitter.com/1/direct_messages/destroy/#{dm_id}.xml")
    rescue
      return false
    end
    return response
  end

  # Check friendships
  # @param [String] src source user
  # @param [String] dst destination user
  # @return [Boolean] return true if paired users have friendship, or ruturn false
  def friendship_exists?(src, dst)
    begin
      response = @access_token.get("http://api.twitter.com/1/friendships/exists.xml?user_a=#{src}&user_b=#{dst}")
    rescue
      return false
    end
    doc = REXML::Document.new(response.body)
    return false if doc.is_error?
    if doc.elements["friends"].text() == "true" then
      return true
    else
      return false
    end
  end

  # Follow user for screen_name
  # @param [String] name screen_name
  # @return [Hash] response
  def follow name
    begin
      response = @access_token.post("http://api.twitter.com/1/friendships/create/#{name}.xml")
    rescue
      return false
    end
    return response
  end

  # Unfollow user for screen_name
  # @param [String] name screen_name
  # @return [Hash] response
  def unfollow name
    begin
      response = @access_token.post("http://api.twitter.com/1/friendships/destroy/#{name}.xml")
    rescue
      return false
    end
    return response
  end

  # @param [Fixnum] id id
  # @return [Hash] response
  def block(id)
    begin
      response = @access_token.post("http://api.twitter.com/1/blocks/create.xml?id=#{id}")
    rescue
      return false
    end
    return response
  end

  # @param [Fixnum] id id
  # @return [Hash] response
  def unblock(id)
    begin
      response = @access_token.post("http://api.twitter.com/1/blocks/destroy.xml?id=#{id}")
    rescue
      return false
    end
    return response
  end

  # @return [Hash] list of blocking users
  def blocking
    response = @access_token.get("http://api.twitter.com/1/blocks/blocking.xml")
    doc = REXML::Document.new(response.body)
    return false if doc.is_error?
    users = Array.new
    doc.get_elements('/users/user').each{|element|
      user = User.new(element)
      users << user
    }
    return users
  end

  # @param [Fixnum] id list id
  # @param [String] ids id comma separated
  # @return [Hash] response
  def addlist(listid,ids)
    response = @access_token.post("http://api.twitter.com/1/#{@username}/#{listid}/create_all.xml?user_id=#{ids}")
    return response
  end

  # @return [Hash] lists
  def lists
    response = @access_token.get("http://api.twitter.com/1/#{@username}/lists.xml")
    doc = REXML::Document.new(response.body)
    return false if doc.is_error?
    lists = Array.new
    doc.get_elements('/lists_list/lists/list').each{|element|
      list = List.new(element)
      lists << list
    }
    return lists
  end


  def lists_member_create(listid,id)
    begin
      response = @access_token.post("http://api.twitter.com/1/#{@username}/#{listid}/members.xml?id=#{id}")
    rescue
      return false
    else
      return response
    end

  end

  def lookup(param = [])
    param_s = param.join(",")
    begin
      response = @access_token.get("http://api.twitter.com/1/users/lookup.xml?user_id="+param_s)
    rescue
      return false
    end
    doc = REXML::Document.new(response.body)
    return false if doc.is_error?
    users = Array.new
    doc.get_elements('/users/user').each{|element|
      user = User.new(element)
      users << user
    }

    return users
  end

  def friends_ids(name)
    begin
      response = @access_token.get("http://api.twitter.com/1/friends/ids/#{name}.xml")
    rescue
      return false
    end
    doc = REXML::Document.new(response.body)
    return false if doc.is_error?
    ids = Array.new

    doc.get_elements('/ids/id').each{|element|
      ids << element.text()
    }

    return ids
  end

  def followers_ids(name)
    begin
      response = @access_token.get("http://api.twitter.com/1/followers/ids/#{name}.xml")
    rescue
      return false
    end
    doc = REXML::Document.new(response.body)
    if doc.is_error? then
      return doc.get_error_message
    end
    ids = Array.new

    doc.get_elements('/ids/id').each{|element|
      ids << element.text()
    }

    return ids
  end

  def rate_limit
    begin
      response = @access_token.get("http://api.twitter.com/1/account/rate_limit_status.xml")
    rescue
      return false
    end
    doc = REXML::Document.new(response.body)
    return false if doc.is_error?
    limit = doc.get_elements('/hash/hourly-limit').shift.text()

    return limit
  end

  def update(status,irt='')
    begin
      response = @access_token.post(
      'http://api.twitter.com/1/statuses/update.json',
      'status'=> status,
      'in_reply_to_status_id' => irt
      )
    rescue
      return false
    end
    return response
  end

  def destroy(status_id)
    begin
      response = @access_token.post("http://api.twitter.com/1/statuses/destroy/#{status_id}.xml")
    rescue
      return false
    end
    return response
  end

  def update_location(location='')
    location = URI.escape(location)
    begin
      response = @access_token.post("http://api.twitter.com/1/account/update_location.xml?location=#{location}")
    rescue
      return false
    end
    return response
  end

  class List
    attr_reader :id
    attr_reader :name
    attr_reader :full_name
    attr_reader :slug
    attr_reader :description
    attr_reader :subscriber_count
    attr_reader :member_count
    attr_reader :uri
    attr_reader :following
    attr_reader :mode
    attr_reader :user

    def initialize(element)
      @id = element.elements['id'].text()
      @name = element.elements['name'].text()
      @full_name = element.elements['full_name'].text()
      @slug = element.elements['slug'].text()
      @description = element.elements['description'].text()
      @subscriber_count = element.elements['subscriber_count'].text()
      @member_count = element.elements['member_count'].text()
      @uri = element.elements['uri'].text()
      @following = element.elements['following'].text()
      @mode = element.elements['mode'].text()
      @user = User.new(element.elements['user'])
    end
  end
  class DirectMessage
    attr_reader :id
    attr_reader :sender_id
    attr_reader :text
    attr_reader :recipient_id
    attr_reader :created_at
    attr_reader :sender_screen_name
    attr_reader :recipient_screen_name
    attr_reader :sender
    attr_reader :recipient

    def initialize(element)
      @id = element.elements['id'].text()
      @sender_id = element.elements['sender_id'].text()
      @text = element.elements['text'].text()
      @recipient_id = element.elements['recipient_id'].text()
      @created_at = element.elements['created_at'].text()
      @sender_screen_name = element.elements['sender_screen_name'].text()
      @recipient_screen_name= element.elements['recipient_screen_name'].text()
      @sender = User.new(element.elements['sender'])
      @recipient = User.new(element.elements['recipient'])
    end
  end
  class User
    attr_reader :id
    attr_reader :name
    attr_reader :screen_name
    attr_reader :description
    attr_reader :url
    attr_reader :followers_count
    attr_reader :friends_count
    attr_reader :statuses_count
    attr_reader :location
    attr_reader :profile_image_url
    attr_reader :profile_background_color
    attr_reader :profile_background_image_url
    attr_reader :profile_background_tile
    attr_reader :profile_text_color
    attr_reader :profile_link_color
    attr_reader :profile_sidebar_fill_color
    attr_reader :profile_sidebar_border_color
    attr_reader :protected
    attr_reader :created_at
    attr_reader :favourites_count
    attr_reader :utc_offset
    attr_reader :time_zone
    attr_reader :notifications
    attr_reader :geo_enabled
    attr_reader :verified
    attr_reader :lang
    attr_reader :contributors_enabled
    attr_reader :following
    attr_reader :follow_request_sent

    def initialize(element)
      @id = element.elements['id'].text()
      @name = element.elements['name'].text()
      @screen_name = element.elements['screen_name'].text()
      @location = element.elements['location'].text()
      @description = element.elements['description'].text()
      @profile_image_url = element.elements['profile_image_url'].text()
      @url = element.elements['url'].text()
      @protected = element.elements['protected'].text()
      @followers_count = element.elements['followers_count'].text()
      @friends_count = element.elements['friends_count'].text()
      @profile_background_color = element.elements['profile_background_color'].text()
      @profile_background_image_url = element.elements['profile_background_image_url'].text()
      @profile_background_tile = element.elements['profile_background_tile'].text()
      @profile_text_color = element.elements['profile_text_color'].text()
      @profile_link_color = element.elements['profile_link_color'].text()
      @profile_sidebar_fill_color = element.elements['profile_sidebar_fill_color'].text()
      @profile_sidebar_border_color = element.elements['profile_sidebar_border_color'].text()
      @statuses_count = element.elements['statuses_count'].text()
      @created_at = element.elements['created_at'].text()
      @favourites_count = element.elements['favourites_count'].text()
      @utc_offset = element.elements['utc_offset'].text()
      @time_zone = element.elements['time_zone'].text()
      @notifications = element.elements['notifications'].text()
      @geo_enabled = element.elements['geo_enabled'].text()
      @verified = element.elements['verified'].text()
      @lang = element.elements['lang'].text()
      @contributors_enabled = element.elements['contributors_enabled'].text()
      @following = element.elements['following'].text()
      @follow_request_sent = element.elements['follow_request_sent'].text()
    end
  end

  class Status
    attr_reader :created_at
    attr_reader :id
    attr_reader :text
    attr_reader :source
    attr_reader :truncated
    attr_reader :in_reply_to_status_id
    attr_reader :in_reply_to_user_id
    attr_reader :in_reply_to_screen_name
    attr_reader :favorited
    attr_reader :user
    attr_reader :geo
    attr_reader :place
    attr_reader :coordinates
    attr_reader :contributors
    attr_reader :annotations
    attr_reader :entities

    def initialize(element)
      @created_at = element.elements['created_at'].text()
      @id = element.elements['id'].text()
      @text = element.elements['text'].text()
      @source = element.elements['source'].text()
      @truncated = element.elements['truncated'].text()
      @in_reply_to_status_id = element.elements['in_reply_to_status_id'].text()
      @in_reply_to_user_id = element.elements['in_reply_to_user_id'].text()
      @in_reply_to_screen_name = element.elements['in_reply_to_screen_name'].text()
      @favorited = element.elements['favorited'].text()
      @user = User.new(element.elements['user'])
      @geo = element.elements['geo'].text()
      @place = element.elements['place'].text()
      @coordinates = (element.elements['coordinates'].nil?) ? nil : element.elements['coordinates'].text()
      @contributors = (element.elements['contributors'].nil?) ? nil : element.elements['contributors'].text()
      @annotations = (element.elements['annotations'].nil?) ? nil : element.elements['annotations'].text()
      @entities = (element.elements['entities'].nil?) ? nil : Entities.new(element.elements['entities'])
    end
  end

  class Entities
    attr_reader :user_mentions
    attr_reader :urls
    attr_reader :hashtags

    def initialize(element)
      @user_mentions = UserMention.new(element.elements['user_mention'])
      @urls = URL.new(element.elements['urls'])
      @hashtags = Hashtag.new(element.elements['hashtags'])
    end
  end

  class UserMention
    attr_reader :id
    attr_reader :screen_name
    attr_reader :name
    attr_reader :start
    attr_reader :end

    def initialize(element)
      @id = element.elements['id'].text()
      @screen_name = element.elements['screen_name'].text()
      @name = element.elements['name'].text()
      @start = element.attributes['start']
      @end = element.attributes['end']
    end
  end

  class URL
    attr_reader :url
    attr_reader :expanded_url
    attr_reader :start
    attr_reader :end

    def initialize(element)
      @url = element.elements['url'].text()
      @expanded_url = element.elements['expanded_url'].text()
      @start = element.attributes['start']
      @end = element.attributes['end']
    end
  end

  class Hashtag
    attr_reader :text
    attr_reader :start
    attr_reader :end

    def initialize(element)
      @text = element.elements['text'].text()
      @start = element.attributes['start']
      @end = element.attributes['end']
    end
  end
end