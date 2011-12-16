class Pupil
  def lookup param={}
    response = self.get("/users/lookup.json", param)
    users = Array.new
    response.each do |element|
      user = User.new element
      users << user
    end
    return users
  end
  
  
end