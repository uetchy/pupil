Pupil
=============

Pupil はRuby 1.9.xのための"怠惰"なTwitter APIライブラリです。

フューチャー
-------------

* 殆どのREST APIをサポートしていますが、一部のAPIはサポートされていません。
* Twitter Streaming APIを実験的にサポート
* Rubyライクな直感的で書きやすい文法

問題
-------------

* 一部のAPIをサポートしていません

動作環境
-------------

* json及びoauth gem
* Ruby 1.9.x

インストール
-------------

	gem install pupil

簡単な使用例
-------------

	require "pupil"
	
	oauth_key = {
		:consumer_key => "something",
		:consumer_secret => "something",
		:access_token => "something",
		:access_token_secret => "something"
	}
  
	pupil = Pupil.new oauth_key
	
	# リプライが含まれないタイムラインを取得する
	pupil.timeline :count => 50, :exclude => :replies
	
	# @twitterapi をフォローする
	pupil.follow :twitterapi
	
	# プロフィールのURLをアップデートする
	pupil.update_profile :url => "http://oameya.com"

Streaming API を使ってみる

	require "pupil/stream"
	
	oauth_key = {
		:consumer_key => "something",
		:consumer_secret => "something",
		:access_token => "something",
		:access_token_secret => "something"
	}
	
	stream = Pupil::Stream.new oauth_key
	
	# ユーザーストリーム
	stream.start :userstream do |status|
		if status.event == :retweeted
			puts "これはリツイートされた呟きです！ => #{status.text}"
		end
	end
	
	# 検索ストリーム
	stream.start :search, :track => "#メリークリスマス" do |status|
		puts "メリー・クリスマス、#{status.user.screen_name}！"
	end

`oauth_key` を作る

	require "pupil/keygen"
	
	keygen = Pupil::Keygen.new
	keygen.interactive #=> インタラクティブにoauth_keyを生成

協力
-------------

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

クレジット
-------------

開発者: [おおあめ](http://twitter.com/o_ame)

ライセンス
-------------

Copyright (c) 2011 おおあめ. LICENSE を見て詳しい情報を得てください。

