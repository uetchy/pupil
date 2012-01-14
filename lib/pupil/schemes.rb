class Pupil
  class Scheme
    protected
    include Essentials
    
    def method_missing(action, *args)
      return @element[action.to_s] rescue nil
    end
    
    public
    
    def initialize(element, access_token=nil)
      @access_token = access_token
      @element = element
    end
    
    def methods() @element.keys.map{|k|k.to_sym} ; end
  end
  
  class User < Scheme
    def status
      Pupil::Status.new(@element["status"], @access_token) rescue nil
    end
    
    def reply(sentence, status=nil)
      response = self.post(
        "/1/statuses/update.json",
        "status"=> "@#{@element[:screen_name]} #{sentence}",
        "in_reply_to_status_id" => status
      )
      return response
    end
  end
  
  class Status < Scheme
    def user() Pupil::User.new(@element["user"], @access_token) rescue nil; end
    
    def source()
      @element["source"] =~ /href=\"(.+?)\".+?>(.+?)</
      {:url => $1, :name => $2}
    end
    
    def entities() Pupil::Entities.new(@element["entities"]) rescue nil; end
    
    def destroy()
      self.post("/1/statuses/destroy/#{@element["id"]}.json")
    end
    
    alias_method :delete, :destroy
  end
  
  class List < Scheme
    def user() Pupil::User.new(@element["user"], @access_token) rescue nil; end
    
    def statuses(param={})
      response = self.get("/1/lists/statuses.json", {:list_id => @element["id_str"]}.update(param))
      return false unless response
      statuses = []
      response.each do |status|
        statuses << Pupil::Status.new(status, @access_token)
      end
      return statuses
    end
    
    def subscribers(param={})
      response = self.get("/1/lists/subscribers.json", {:list_id => @element["id_str"]}.update(param))
      return false unless response
      users = []
      response["users"].each do |user|
        users << Pupil::User.new(user, @access_token)
      end
      return users
    end
    
    def members(param={})
      response = self.get("/1/lists/members.json", {:list_id => @element["id_str"]}.update(param))
      return false unless response
      users = []
      response["users"].each do |u|
        user = User.new(u.update("_list_id" => @element["id_str"]), @access_token)
        def user.destroy()
          response = self.post("/1/lists/members/destroy.json", {:list_id => @element["_list_id"], :user_id => @element["id_str"]})
        end
        users << user
      end
      return users
    end
    
    def add(param)
      response = self.post("/1/lists/members/create.json", {:list_id => @element["id_str"], guess_parameter(param) => param})
      return List.new(response)
    end
    
    def strike(param, opts={})
      response = self.post("/1/lists/members/destroy.json", {guess_parameter(param) => param, :list_id => @element["id_str"]}.update(opts))
      return response
    end
    
    alias_method :off, :strike
    
    def destroy()
      response = self.post("/1/lists/destroy.json", {:list_id => @element["id_str"]})
      return List.new(response)
    end
    
    alias_method :delete, :destroy
  end
  
  class Entities < Scheme
    def urls()
      urls = []
      @element["urls"].each do |url|
        urls << Pupil::URL.new(url)
      end
      return urls
    rescue
      nil
    end
    
    def hashtags()
      hashtags = []
      @element["hashtags"].each do |hashtag|
        hashtags << Pupil::Hashtag.new(hashtag)
      end
      return hashtags
    rescue
      nil
    end
    
    def user_mentions()
      user_mentions = []
      @element["user_mentions"].each do |user_mention|
        user_mentions << Pupil::UserMention.new(user_mention)
      end
      return user_mentions
    rescue
      nil
    end
  end
  
  class URL < Scheme; end
  class Hashtag < Scheme; end
  class UserMention < Scheme; end
  
  class DirectMessage < Scheme
    def sender() Pupil::User.new(@element["sender"], @access_token) rescue nil; end
    def recipient() Pupil::User.new(@element["recipient"], @access_token) rescue nil; end
  end
end