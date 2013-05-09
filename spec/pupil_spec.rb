# encoding: utf-8

# -*- coding: utf-8 -*-

### WARNING ###
# pupil_spec require PUPIL_TESTKEY in spec_testkey.rb
# You should create file spec_testkey.rb into /spec to define PUPIL_TESTKEY with Pupil key.

require "pp"

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Pupil, "が #verify_credentials を呼ぶ時は" do
  before do
    pupil = Pupil.new PUPIL_TESTKEY
    @vc = pupil.verify_credentials
  end
  
  it "Pupil::User型を返すこと" do
    @vc.class.should == Pupil::User
  end
end

describe Pupil, "が #home_timeline を呼ぶ時は" do
  before do
    pupil = Pupil.new PUPIL_TESTKEY
    @home_timeline = pupil.home_timeline :count => 20
  end
  
  it "Array型を返すこと" do
    @home_timeline.class.should == Array
  end
  
  it "sizeが50であること" do
    @home_timeline.size.should == 20
  end
end

describe Pupil, "が #mentions を呼ぶ時は" do
  before do
    pupil = Pupil.new PUPIL_TESTKEY
    @mentions = pupil.mentions :count => 1
  end
  
  it "Array型を返すこと" do
    @mentions.class.should == Array
  end
  
  it "sizeが1であること" do
    @mentions.size.should == 1
  end
end

describe Pupil, "が #user_timeline を呼ぶ時は" do
  before do
    pupil = Pupil.new PUPIL_TESTKEY
    @user_timeline = pupil.user_timeline pupil.profile.screen_name
  end
  
  it "Array型を返すこと" do
    @user_timeline.class.should == Array
  end
end

describe Pupil, "が #friendship? を呼ぶ時は" do
  before do
    pupil = Pupil.new PUPIL_TESTKEY
    @nonfriendship = pupil.friendship? pupil.profile.screen_name, KNOWN_NONFOLLOWED_USER
    @friendship = pupil.friendship? pupil.profile.screen_name, KNOWN_USER
  end
  
  it "フォロー関係に無い場合はFalseClass型を返すこと" do
    @nonfriendship.class.should == FalseClass
  end
  
  it "フォロー関係にある場合はTrueClass型を返すこと" do
    @friendship.class.should == TrueClass
  end
end

describe Pupil, "が #blocking を呼ぶ時は" do
  before do
    pupil = Pupil.new PUPIL_TESTKEY
    @blocking = pupil.blocking
  end
  
  it "Array型を返すこと" do
    @blocking.class.should == Array
  end
end

describe Pupil, "が #search を呼ぶ時は" do
  before do
    pupil = Pupil.new PUPIL_TESTKEY
    @search = pupil.search("Twitter", :rpp => 1)
  end
  
  it "Array型を返すこと" do
    @search.class.should == Array
  end
  
  it "sizeが1であること" do
    @search.size.should == 1
  end
end