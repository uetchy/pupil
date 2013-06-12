class Pupil
  def configuration()
    response = self.get("help/configuration.json")
    return response
  end
end