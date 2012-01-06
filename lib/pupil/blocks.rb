class Pupil
  # @param [Fixnum] id id
  # @return [Pupil::User] response
  def block param
    case param.keys[0].to_sym
    when :screen_name
      response = self.post("/blocks/create.json", {:screen_name => param.values[0]})
    when :id
      response = self.post("/blocks/create.json", {:user_id => param.values[0]})
    end
    
    if response.class == Hash && response["id"]
      return User.new response
    end
    return false
  end

  # @param [Fixnum] id id
  # @return [Pupil::User] response
  def unblock param
    case param.keys[0].to_sym
    when :screen_name
      response = self.post("/blocks/destroy.json", {:screen_name => param.values[0]})
    when :id
      response = self.post("/blocks/destroy.json", {:user_id => param.values[0]})
    end
    
    if response.class == Hash && response["id"]
      return User.new response
    end
    return false
  end

  # @return [Array] list of blocking users
  def blocking
    response = self.get("/blocks/blocking.json")
    users = Array.new
    response["users"].each do |element|
      user = User.new element
      users << user
    end
    return users
  end
end