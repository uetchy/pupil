# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "pupil"
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Oame"]
  s.date = "2012-04-07"
  s.description = "The \"Lazy\" Twitter API Library for Ruby 1.9.x. Easy to use."
  s.email = "oame@oameya.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.ja.md",
    "README.md"
  ]
  s.files = [
    "CHANGELOG.md",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.ja.md",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/pupil.rb",
    "lib/pupil/account.rb",
    "lib/pupil/base.rb",
    "lib/pupil/blocks.rb",
    "lib/pupil/direct_messages.rb",
    "lib/pupil/essentials.rb",
    "lib/pupil/friendships.rb",
    "lib/pupil/general.rb",
    "lib/pupil/help.rb",
    "lib/pupil/keygen.rb",
    "lib/pupil/keygen/base.rb",
    "lib/pupil/lists.rb",
    "lib/pupil/schemes.rb",
    "lib/pupil/search.rb",
    "lib/pupil/statuses.rb",
    "lib/pupil/stream.rb",
    "lib/pupil/stream/base.rb",
    "lib/pupil/users.rb",
    "pupil.gemspec",
    "samples/key-generator.rb",
    "samples/userstream-test.rb",
    "spec/pupil_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/oame/pupil"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("~> 1.9.0")
  s.rubygems_version = "1.8.15"
  s.summary = "The \"Lazy\" Twitter API Library for Ruby 1.9.x"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<oauth>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.3.0"])
      s.add_development_dependency(%q<yard>, ["~> 0.6.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<oauth>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.3.0"])
      s.add_dependency(%q<yard>, ["~> 0.6.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<oauth>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.3.0"])
    s.add_dependency(%q<yard>, ["~> 0.6.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

