class Pupil
  def friends_ids(name=@screen_name)
    response = self.get("/friends/ids/#{name}.json")
    return false unless response
    ids = []
    response.each do |element|
      ids << element
    end
    return ids
  end

  def followers_ids(name=@screen_name)
    response = self.get("/1/followers/ids/#{name}.json")
    return false unless response
    ids = []
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
    param = {"source_#{guess_parameter(src)}" => src, "target_#{guess_parameter(dst)}" => dst}
    response = self.get("/friendships/show.json", param)
    return nil unless response
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
  def follow(param)
    response = self.post("/friendships/create.json", {guess_parameter(param) => param})
    return false unless response
    User.new(response, @access_token)
  end

  # Unfollow user for screen_name
  # @param [String] name screen_name
  # @return [Hash] response
  def unfollow(param)
    response = self.post("/friendships/destroy.json", {guess_parameter(param) => param})
    return false unless response
    User.new response
  end
end