# -*- coding: utf-8 -*-

### WARNING ###
# pupil_spec require PUPIL_TESTKEY in spec_testkey.rb
# You should create file spec_testkey.rb into /spec to define PUPIL_TESTKEY with Pupil key.

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Pupil, "が #home_timeline を呼ぶ時は" do
  before do
    pupil = Pupil.new PUPIL_TESTKEY
    @home_timeline = pupil.home_timeline
  end
  
  it "Array型を返すこと" do
    @home_timeline.class.should == Array
  end
end
