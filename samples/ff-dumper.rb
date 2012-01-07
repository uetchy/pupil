#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# only 1.9.2

$LOAD_PATH << File.join(File.dirname(File.expand_path(__FILE__)), "../")
require "lib/pupil"
require "yaml"

keygen = Pupil::Keygen.new({:consumer_key => "yIyK3TaGo5VJX7MdkS95g", :consumer_secret => "ukIvD6yqP8SNbFfaIqVNkqg08J33uvRvpGa1ktuRc"})
tokens = keygen.interactive

pupil = Pupil.new tokens
user = pupil.verify_credentials
friends = pupil.friends_ids user.screen_name
followers = pupil.followers_ids user.screen_name

open("ff.yml", "w") do |f|
  f.puts({:friends => friends, :followers => followers}.to_yaml)
end