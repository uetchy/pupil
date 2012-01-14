class Pupil
  # @return [Hash] lists
  def lists(param={})
    if param[:contains]
      response = self.get("/1/lists/memberships.json", param.reject{|p|p==:contains}.update(guess_parameter(param[:contains]) => param[:contains]))
      response = response["lists"]
    else
      response = self.get("/1/lists/all.json", param)
    end
    return [] unless response
    lists = Array.new
    response.each do |list|
      lists << List.new(list, @access_token)
    end
    return lists
  end
  
  def create_list(name, param={})
    response = self.post("/1/lists/create.json", {:name => name}.update(param))
    return List.new(response, @access_token)
  end
end