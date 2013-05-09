require "pupil/keygen"
require "thor"

class Pupil
  class CLI < Thor
    desc "gen", "Generate OAuth Keys"
    def gen
      gen = Pupil::Keygen.new
      gen.interactive
    end
  end
end