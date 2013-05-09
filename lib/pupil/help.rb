class Pupil
  def configuration()
    response = self.get("/1.1/help/configuration.json")
    return response
  end
end