class Pupil
  # @return [Array] Timeline
  # @param [Hash] param
  # @option param [Fixnum] :count Number of tweets
  # @option param [Fixnum] :since_id
  # @option param [Fixnum] :max_id
  # @option param [Fixnum] :page
  # @option param [Symbol] :trim_user
  # @option param [Symbol] :include #=> [:rts]
  # @option param [Symbol] :exclude #=> [:replies]
  # @option param [Symbol] :contributor_details
  def timeline(param={})
    response = self.get("/1.1/statuses/home_timeline.json", param)
    return false unless response
    statuses = []
    response.each do |element|
      status = Status.new(element, @access_token)
      statuses << status
    end
    return statuses
  end
  alias_method :home_timeline, :timeline
  
  # @return [Array] Mention
  # @param [Hash] param
  def mentions(param={})
    response = self.get("/1.1/statuses/mentions_timeline.json", param)
    return false unless response
    statuses = []
    response.each do |element|
      status = Status.new(element, @access_token)
      statuses << status
    end
    return statuses
  end
  
  # Returning user timeline
  # @return [Array] timeline
  # @param [Hash] param
  # @option param [Fixnum] :user_id The ID of user
  # @option param [String] :screen_name The Screen name of user
  # @option param [Fixnum] :since_id
  # @option param [Fixnum] :max_id
  # @option param [Fixnum] :count
  # @option param [Fixnum] :page Specifies
  # @option param [Symbol] :trim_user
  # @option param [Symbol] :include #=> [:rts]
  # @option param [Symbol] :exclude #=> [:replies]
  # @option param [Symbol] :contributor_details
  # @example
  #   twitter = Pupil.new PUPIL_KEY
  #   twitter.user_timeline(:screen_name => 'o_ame', :exclude => :replies).each do |status|
  #     puts "#{status.user.screen_name}: #{status.text}"
  #   end
  def user_timeline(target, option={})
    response = self.get("/1.1/statuses/user_timeline.json", {guess_parameter(target) => target}.update(option))
    return false unless response
    statuses = []
    response.each do |element|
      status = Status.new(element, @access_token)
      statuses << status
    end
    return statuses
  end
  
  alias_method :timeline_for, :user_timeline
  
  # Returning public timeline
  # @return [Array] Timeline
  # @param [Hash] param
  def public_timeline(param={})
    response = self.get("/1.1/statuses/public_timeline.json", param)
    return false unless response
    statuses = Array.new
    response.each do |element|
      status = Status.new(element, @access_token)
      statuses << status
    end
    return statuses
  end
  
  def retweeted_by_me(param={})
    response = self.get("/1.1/statuses/retweeted_by_me.json", param)
    return false unless response
    statuses = Array.new
    response.each do |element|
      status = Status.new(element, @access_token)
      statuses << status
    end
    return statuses
  end
  
  def retweeted_to_me(param={})
    response = self.get("/1.1/statuses/retweeted_to_me.json", param)
    return false unless response
    statuses = Array.new
    response.each do |element|
      status = Status.new(element, @access_token)
      statuses << status
    end
    return statuses
  end
  
  def retweets_of_me(param={})
    response = self.get("/1.1/statuses/retweets_of_me.json", param)
    return false unless response
    statuses = Array.new
    response.each do |element|
      status = Status.new(element, @access_token)
      statuses << status
    end
    return statuses
  end
  
  def retweeted_to_user(param={})
    response = self.get("/1.1/statuses/retweeted_to_user.json", param)
    return false unless response
    statuses = Array.new
    response.each do |element|
      status = Status.new(element, @access_token)
      statuses << status
    end
    return statuses
  end
  
  def retweeted_by_user(param={})
    response = self.get("/1.1/statuses/retweeted_by_user.json", param)
    return false unless response
    statuses = Array.new
    response.each do |element|
      status = Status.new(element, @access_token)
      statuses << status
    end
    return statuses
  end
  
  def oembed(param={})
    response = self.get("/1.1/statuses/oembed.json", param)
    return response
  end
  
  def status(status_id, param={})
    response = self.get("/1.1/statuses/show/#{status_id}.json", param)
    return false unless response
    status = Status.new(response, @access_token)
    return status
  end
  
  def update(status, irt='')
    response = self.post(
      "/1.1/statuses/update.json",
      "status"=> status,
      "in_reply_to_status_id" => irt
    )
    return false unless response
    response
  end
  
  alias_method :tweet, :update

  def destroy(status_id)
    response = self.post("/1.1/statuses/destroy/#{status_id}.json")
    return false unless response
    response
  end
end