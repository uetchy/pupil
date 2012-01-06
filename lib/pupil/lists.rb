class Pupil
  # @param [Fixnum] id list id
  # @param [String] ids id comma separated
  # @return [Hash] response
  def addlist(listid,ids)
    response = @access_token.post("http://api.twitter.com/1/#{@username}/#{listid}/create_all.xml?user_id=#{ids}")
    return response
  end

  # @return [Hash] lists
  def lists
    response = @access_token.get("http://api.twitter.com/1/#{@username}/lists.xml")
    doc = REXML::Document.new(response.body)
    return false if doc.is_error?
    lists = Array.new
    doc.get_elements('/lists_list/lists/list').each{|element|
      list = List.new(element)
      lists << list
    }
    return lists
  end

  def lists_member_create(listid,id)
    begin
      response = @access_token.post("http://api.twitter.com/1/#{@username}/#{listid}/members.xml?id=#{id}")
    rescue
      return false
    else
      return response
    end
  end
  
  
end