class Pupil
  # Returning direct messages
  # @param [Hash] param
  # @return [Hash] directmessages
  def direct_messages(param = {})
    response = self.get("/1/direct_messages.json", param)
    return false unless response
    directmessages = Array.new
    response.each do |element|
      dm = DirectMessage.new(element, @access_token)
      directmessages << dm
    end

    return directmessages
  end

  # Returning direct messages you sent
  # @param [Hash] param
  # @return [Hash] directmessage you sent
  def sent_direct_messages(param = {})
    response = self.get("/1/direct_messages/sent.json", param)
    return false unless response
    directmessages = Array.new
    response.each do |element|
      dm = DirectMessage.new(element, @access_token)
      directmessages << dm
    end

    return directmessages
  end
  
  def send_direct_message(sentence, opts)
    raise ArgumentError, ":to parameter not given" unless opts[:to]
    response = self.post("/1/direct_messages/new.json", {:text => sentence, guess_parameter(opts[:to]) => opts[:to]})
    return false unless response
    response
  end
end