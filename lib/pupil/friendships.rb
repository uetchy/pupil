class Pupil
  def friends_ids name
    response = self.get("/friends/ids/#{name}.json")
    ids = Array.new
    response.each do |element|
      ids << element
    end
    return ids
  end

  def followers_ids name=@screen_name
    response = self.get("/1/followers/ids/#{name}.json")
    ids = Array.new
    response.each do |element|
      ids << element
    end
    return ids
  end
  
  # Check friendships
  # @param [String] src source screen_name
  # @param [String] dst destination screen_name
  # @return [Boolean] return true if paired users have friendship, or ruturn false
  def friendship?(src, dst)
    param = {:source_screen_name => src, :target_screen_name => dst}
    response = self.get("/friendships/show.json", param)
    if response["relationship"]["source"]["following"] == true && response["relationship"]["target"]["following"] == true then
      return true
    else
      return false
    end
  end
  
  alias_method "relationship?", "friendship?"
  alias_method "friendships_exists?", "friendship?"

  # Follow user for screen_name
  # @param [String] name screen_name
  # @return [Hash] response
  def follow param
    case param.keys[0].to_sym
    when :screen_name
      response = self.post("/friendships/create.json", {:screen_name => param.values[0]})
    when :id
      response = self.post("/friendships/create.json", {:user_id => param.values[0]})
    end
    
    if response.class == Hash && response["id"]
      return User.new response
    end
    return false
  end

  # Unfollow user for screen_name
  # @param [String] name screen_name
  # @return [Hash] response
  def unfollow param
    case param.keys[0].to_sym
    when :screen_name
      response = self.post("/friendships/destroy.json", {:screen_name => param.values[0]})
    when :id
      response = self.post("/friendships/destroy.json", {:user_id => param.values[0]})
    end
    
    if response.class == Hash && response["id"]
      return User.new response
    end
    return false
  end
end