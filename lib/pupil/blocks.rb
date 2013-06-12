class Pupil
  # @param [Fixnum] id id
  # @return [Pupil::User] response
  def block(param)
    response = self.post("blocks/create.json", {guess_parameter(param) => param})
    
    if response.class == Hash && response["id"]
      return User.new response
    end
    return false
  end

  # @param [Fixnum] id id
  # @return [Pupil::User] response
  def unblock(param)
    response = self.post("blocks/destroy.json", {guess_parameter(param) => param})
    
    if response.class == Hash && response["id"]
      return User.new response
    end
    return false
  end

  # @return [Array] list of blocking users
  def blocking
    response = self.get("blocks/list.json")
    return [] if response["nilclasses"]
    users = Array.new
    response["users"].each do |element|
      user = User.new element
      users << user
    end
    return users
  end
end