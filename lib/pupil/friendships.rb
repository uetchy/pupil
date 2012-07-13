class Pupil
  def friends_ids(name=@screen_name)
    name ||= self.profile.screen_name
    response = self.get("/1/friends/ids.json", {guess_parameter(name) => name})
    return false unless response
    ids = []
    response["ids"].each do |element|
      ids << element
    end
    return ids
  end
  
  alias_method :following_ids, :friends_ids
  
  def friends(name=@screen_name)
    name ||= self.profile.screen_name
    ids = self.friends_ids(name)
    users = self.lookup :users => ids
    return users
  end
  
  alias_method :following, :friends

  def followers_ids(name=@screen_name)
    name ||= self.profile.screen_name
    response = self.get("/1/followers/ids.json", {guess_parameter(name) => name})
    return false unless response
    ids = []
    response["ids"].each do |element|
      ids << element
    end
    return ids
  end
  
  def followers(name=@screen_name)
    name ||= self.profile.screen_name
    ids = self.followers_ids(name)
    users = self.lookup :users => ids
    return users
  end
  
  def no_retweet_ids()
    response = self.get("/1/friendships/no_retweet_ids.json")
    return false unless response
    return response
  end
  
  def outgoing(param={})
    response = self.get("/1/friendships/outgoing.json")
    return false unless response
    ids = []
    response["ids"].each do |element|
      ids << element
    end
    return ids
  end
  
  def incoming(param={})
    response = self.get("/1/friendships/incoming.json")
    return false unless response
    ids = []
    response["ids"].each do |element|
      ids << element
    end
    return ids
  end
  
  # Check friendships
  # @param [String] src source screen_name
  # @param [String] dst destination screen_name
  # @return [Boolean] return true if paired users have friendship, or ruturn false
  def friendship?(src, dst)
    param = {"source_#{guess_parameter(src)}" => src, "target_#{guess_parameter(dst)}" => dst}
    response = self.get("/1/friendships/show.json", param)
    return nil unless response
    if response["relationship"]["source"]["following"] == true && response["relationship"]["target"]["following"] == true then
      return true
    else
      return false
    end
  end
  
  alias_method "relationship?", "friendship?"
  alias_method "friendships_exists?", "friendship?"
  
  def update_friendships(target, param)
    response = self.post("/1/friendships/update.json", param)
    return false unless response
    return response
  end

  # Follow user for screen_name
  # @param [String] name screen_name
  # @return [Hash] response
  def follow(param)
    response = self.post("/1/friendships/create.json", {guess_parameter(param) => param})
    return false unless response
    User.new(response, @access_token)
  end

  # Unfollow user for screen_name
  # @param [String] name screen_name
  # @return [Hash] response
  def unfollow(param)
    response = self.post("/1/friendships/destroy.json", {guess_parameter(param) => param})
    return false unless response
    User.new response
  end
end