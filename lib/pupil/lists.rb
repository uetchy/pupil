class Pupil
  # @return [Hash] lists
  def lists(param={})
    if param[:contains]
      response = self.get("lists/memberships.json", param.reject{|p|p==:contains}.update(guess_parameter(param[:contains]) => param[:contains]))
      response = response["lists"]
    else
      response = self.get("lists/all.json", param)
    end
    return [] unless response
    lists = Array.new
    response.each do |list|
      lists << List.new(list, @access_token)
    end
    return lists
  end
  
  def create_list(name, option={})
    response = self.post("lists/create.json", {:name => name}.update(option))
    return List.new(response, @access_token)
  end
end