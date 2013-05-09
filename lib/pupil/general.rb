class Pupil
  def lookup(opts, option={})
    target, source = opts.to_a.first
    case target
    when :users
      users = Array.new
      source.each_slice(100) do |sliced|
        response = self.get("/1.1/users/lookup.json", {guess_parameter(sliced[0]) => sliced.join(",")}.update(option))
        return false unless response
        response.each do |element|
          user = User.new(element, @access_token)
          users << user
        end
      end
      
      return users
    when :friendships
      fs = Array.new
      source.each_slice(100) do |sliced|
        response = self.get("/1.1/friendships/lookup.json", {guess_parameter(sliced[0]) => sliced.join(",")}.update(option))
        return false unless response

        response.each do |element|
          fs << element
        end
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