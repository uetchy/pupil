class Pupil
  def lookup(opts, option={})
    target, source = opts.to_a.first
    case target
    when :users
      response = self.get("/1/users/lookup.json", {guess_parameter(source[0]) => source.join(",")}.update(option))
      return false unless response
      users = Array.new
      response.each do |element|
        user = User.new(element, @access_token)
        users << user
      end
      return users
    when :friendships
      response = self.get("/1/friendships/lookup.json", {guess_parameter(source[0]) => source.join(",")}.update(option))
      return false unless response
      fs = Array.new
      response.each do |element|
        fs << element
      end
      return fs
    else
      raise ArgumentError, "#{target} is invalid parameter"
    end
  end
  
  def method_missing(action, *args)
    # e.g. pupil.users_search("username", :method => :post)
    url = "/1/#{action.to_s.split('_').join('/')}.json"
    response = self.get(url, args)
    return response
  end
end