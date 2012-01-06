#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

$LOAD_PATH << File.join(File.dirname(File.expand_path(__FILE__)), "../")
require "lib/pupil/keygen"

keygen = Pupil::Keygen.new
keygen.interactive