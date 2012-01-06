class Pupil
  # Returning direct messages
  # @param [Hash] param
  # @return [Hash] directmessages
  def dm(param = {})
    param_s = param_serializer(param)
    begin
      response = @access_token.get("http://api.twitter.com/1/direct_messages.xml"+param_s)
    rescue
      return false
    end
    doc = REXML::Document.new(response.body)
    return false if doc.is_error?
    directmessages = Array.new

    doc.get_elements('/direct-messages/direct_message').each{|element|
      dm = DirectMessage.new(element)
      directmessages << dm
    }

    return directmessages
  end

  # Returning direct messages you sent
  # @param [Hash] param
  # @return [Hash] directmessage you sent
  def dm_sent(param = {})
    param_s = param_serializer(param)
    begin
      response = @access_token.get("http://api.twitter.com/1/direct_messages/sent.xml"+param_s)
    rescue
      return false
    end
    doc = REXML::Document.new(response.body)
    return false if doc.is_error?
    directmessages = Array.new

    doc.get_elements('/direct-messages/direct_message').each{|element|
      dm = DirectMessage.new(element)
      directmessages << dm
    }

    return directmessages
  end

  # Delete direct message
  # @param [Fixnum] dm_id message id that you want to delete
  # @return [Hash] response
  def dm_destroy(dm_id)
    begin
      response = @access_token.post("http://api.twitter.com/1/direct_messages/destroy/#{dm_id}.xml")
    rescue
      return false
    end
    return response
  end
end