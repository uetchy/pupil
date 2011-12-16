class Pupil
  class User
    attr_reader :contributors_enabled
    attr_reader :created_at
    attr_reader :default_profile
    attr_reader :default_profile_image
    attr_reader :description
    attr_reader :favourites_count
    attr_reader :follow_request_sent
    attr_reader :followers_count
    attr_reader :following
    attr_reader :friends_count
    attr_reader :geo_enabled
    attr_reader :id
    attr_reader :id_str
    attr_reader :is_translator
    attr_reader :lang
    attr_reader :listed_count
    attr_reader :location
    attr_reader :name
    attr_reader :notifications
    attr_reader :profile_background_color
    attr_reader :profile_background_image_url
    attr_reader :profile_background_image_url_https
    attr_reader :profile_background_tile
    attr_reader :profile_image_url
    attr_reader :profile_image_url_https
    attr_reader :profile_link_color
    attr_reader :profile_sidebar_border_color
    attr_reader :profile_sidebar_fill_color
    attr_reader :profile_text_color
    attr_reader :profile_use_background_image
    attr_reader :protected
    attr_reader :screen_name
    attr_reader :show_all_inline_media
    attr_reader :status
    attr_reader :statuses_count
    attr_reader :time_zone
    attr_reader :url
    attr_reader :utc_offset
    attr_reader :verified

    def initialize j
      @contributors_enabled = j["contributors_enabled"] rescue nil
      @created_at = j["created_at"]
      @default_profile = j["default_profile"]
      @default_profile_image = j["default_profile_image"]
      @description = j["description"]
      @favourites_count = j["favourites_count"]
      @follow_request_sent = j["follow_request_sent"]
      @followers_count = j["followers_count"]
      @following = j["following"]
      @friends_count = j["friends_count"]
      @geo_enabled = j["geo_enabled"]
      @id = j["id"]
      @id_str = j["id_str"]
      @is_translator = j["is_translator"]
      @lang = j["lang"]
      @listed_count = j["listed_count"]
      @location = j["location"]
      @name = j["name"]
      @notifications = j["notifications"]
      @profile_background_color = j["profile_background_color"]
      @profile_background_image_url = j["profile_background_image_url"]
      @profile_background_image_url_https = j["profile_background_image_url_https"]
      @profile_background_tile = j["profile_background_tile"]
      @profile_image_url = j["profile_image_url"]
      @profile_image_url_https = j["profile_image_url_https"]
      @profile_link_color = j["profile_link_color"]
      @profile_sidebar_border_color = j["profile_sidebar_border_color"]
      @profile_sidebar_fill_color = j["profile_sidebar_fill_color"]
      @profile_text_color = j["profile_text_color"]
      @profile_use_background_image = j["profile_use_background_image"]
      @protected = j["protected"]
      @screen_name = j["screen_name"]
      @show_all_inline_media = j["show_all_inline_media"]
      @status = Status.new j["status"]
      @statuses_count = j["statuses_count"]
      @time_zone = j["time_zone"]
      @url = j["url"]
      @utc_offset = j["utc_offset"]
      @verified = j["verified"]
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
  
  class Status
    attr_reader :contributors
    attr_reader :coordinates
    attr_reader :created_at
    attr_reader :favorited
    attr_reader :geo
    attr_reader :id
    attr_reader :id_str
    attr_reader :in_reply_to_screen_name
    attr_reader :in_reply_to_status_id
    attr_reader :in_reply_to_status_id_str
    attr_reader :in_reply_to_user_id
    attr_reader :in_reply_to_user_id_str
    attr_reader :place
    attr_reader :retweet_count
    attr_reader :retweeted
    attr_reader :source
    attr_reader :text
    attr_reader :truncated
    attr_reader :user

    def initialize j
      @contributors = j["contributors"]
      @coordinates = j["coordinates"]
      @created_at = j["created_at"]
      @favorited = j["favorited"]
      @geo = j["geo"]
      @id = j["id"]
      @id_str = j["id_str"]
      @in_reply_to_screen_name = j["in_reply_to_screen_name"]
      @in_reply_to_status_id = j["in_reply_to_status_id"]
      @in_reply_to_status_id_str = j["in_reply_to_status_id_str"]
      @in_reply_to_user_id = j["in_reply_to_user_id"]
      @in_reply_to_user_id_str = j["in_reply_to_user_id_str"]
      @place = j["place"]
      @retweet_count = j["retweet_count"]
      @retweeted = j["retweeted"]
      j["source"] =~ /href=\"(.+?)\".+?>(.+?)</
      @source = {:url => $1, :name => $2}
      @text = j["text"]
      @truncated = j["truncated"]
      @user = User.new j["user"]  rescue nil
    end
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
end