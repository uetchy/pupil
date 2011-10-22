#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "rubygems" if RUBY_VERSION < "1.9.0"
$LOAD_PATH << File.join(File.dirname(File.expand_path(__FILE__)), "../")
require "lib/pupil"

keygen = Pupil::Keygen.new
keygen.interactive