class Pupil
  # @param [String] keyword Search word
  # @param [Hash]  option
  # @return [Array] Tweets
  def search(keyword, option={})
    response = self.get("http://search.twitter.com/search.json", {:q => keyword}.update(option))
    statuses = Array.new
    response["results"].each do |element|
      status = Status.new element
      statuses << status
    end
    return statuses
  end
end