class Pupil
  # Verify credentials
  # @return [Pupil::User] User credentials
  def verify_credentials
    response = self.get("/account/verify_credentials.json")
    user = User.new response
    return user
  end

  # Rate limit statuses
  # @return [Hash] Rate limit statuses
  def rate_limit
    response = self.get("/account/rate_limit_status.json")
    return response
  end

  # End oauth session
  # @return [Hash] Result
  def end_session
    response = self.post("/account/end_session.json")
    return response
  end

  # Update profile
  # @return [Pupil::User] Updated profile
  # @param [Hash] param
  # @option param [String] :name
  # @option param [String] :url
  # @option param [String] :location
  # @option param [String] :description
  # @option param [String] :colors #=> :background
  # @option param [String] :colors #=> :link
  # @option param [String] :colors #=> :sidebar_border
  # @option param [String] :colors #=> :sidebar_fill
  # @option param [String] :colors #=> :text
  def update_profile param
    if param.key? :colors
      opt = Hash.new
      opt.update({:profile_background_color => param[:colors][:background]}) if param[:colors][:background]
      opt.update({:profile_link_color => param[:colors][:link]}) if param[:colors][:link]
      opt.update({:profile_sidebar_border => param[:colors][:sidebar_border]}) if param[:colors][:sidebar_border]
      opt.update({:profile_sidebar_fill => param[:colors][:sidebar_fill]}) if param[:colors][:sidebar_fill]
      oot.update({:profile_text_color => param[:colors][:text]}) if param[:colors][:text]
      param.delete :colors
      response = self.post("/account/update_profile_colors.json", opt)
      return User.new response if param.size <= 0
    end
    response2 = self.post("/account/update_profile.json", param)
    return User.new response2
  end
end