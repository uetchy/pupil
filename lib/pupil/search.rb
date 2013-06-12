class Pupil
  # @param [String] keyword Search word
  # @param [Hash]  option
  # @return [Array] Tweets
  def search(keyword, option={})
    response = self.get("search/tweets.json", {:q => keyword}.update(option))
    statuses = Array.new
    response["statuses"].each do |element|
      status = Status.new element
      statuses << status
    end
    return statuses
  end
end