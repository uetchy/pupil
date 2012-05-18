# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pupil/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Oame"]
  gem.email         = ["oame@oameya.com"]
  gem.description   = %q{The "Lazy" Twitter API Library for Ruby 1.9.x. Easy to use.}
  gem.summary       = %q{The "Lazy" Twitter API Library for Ruby 1.9.x}
  gem.homepage      = "http://oame.github.com/pupil"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "pupil"
  gem.require_paths = ["lib"]
  gem.version       = Pupil::VERSION
  gem.add_dependency "oauth"
  gem.add_dependency "json"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "yard"
  gem.add_development_dependency "bundler"
end
