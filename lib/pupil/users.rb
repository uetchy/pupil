class Pupil
  def user(target, option={})
    response = self.get("/1/users/show.json", {guess_parameter(target) => target}.update(option))
    return false unless response
    user = User.new(response, @access_token)
    return user
  end
  
  def search_user(keyword, option={})
    response = self.get("/1/users/search.json", {:q => keyword}.update(option))
    users = Array.new
    response.each do |element|
      user = User.new(element, @access_token)
      users << user
    end
    return users
  end
end