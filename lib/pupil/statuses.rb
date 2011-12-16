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
  def home_timeline param={}
    response = self.get("/statuses/home_timeline.json", param)
    statuses = Array.new
    response.each do |element|
      status = Status.new element
      statuses << status
    end
    return statuses
  end
  
  # @return [Hash] mention
  # @param [Hash] param
  def mentions param={}
    response = self.get("/statuses/mentions.json", param)
    statuses = Array.new
    response.each do |element|
      status = Status.new element
      statuses << status
    end
    return statuses
  end
  
  # Returning user timeline
  # @return [Hash] timeline
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
  def user_timeline param={}
    response = self.get("/statuses/user_timeline.json", param)
    statuses = Array.new
    response.each do |element|
      status = Status.new element
      statuses << status
    end
    return statuses
  end
  
  def show_status status_id
    response = @access_token.get("/statuses/show/#{status_id}.json").body
    return response
    status = Status.new response
    return status
  end
  
  def update(status, irt='')
    response = self.post(
      "/statuses/update.json",
      "status"=> status,
      "in_reply_to_status_id" => irt
    )
    return response
  end
  
  alias_method :tweet, :update

  def destroy status_id
    response = self.post("/statuses/destroy/#{status_id}.json")
    return response
  end
end