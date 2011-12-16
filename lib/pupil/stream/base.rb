class Pupil
  class Stream
    class StreamError < StandardError ; end
    STREAM_APIS = {
      :userstream => "https://userstream.twitter.com/2/user.json",
      :filter => "https://stream.twitter.com/1/statuses/filter.json%s"
    }

    def initialize key
      @screen_name = key[:screen_name]
      @client = nil
      @config = nil

      @consumer = OAuth::Consumer.new(
      key[:consumer_key],
      key[:consumer_secret],
      :site => TWITTER_API_URL
      )
      @access_token = OAuth::AccessToken.new(
      @consumer,
      key[:access_token],
      key[:access_token_secret]
      )
    end

    def start(type, param=nil, &block)
      raise ArgumentError unless block_given?
      
      run_get_stream type, param, &block
    end
    
    def run_get_stream(type, param=nil, &block)
      uri = URI.parse(STREAM_APIS[type] % Pupil.param_serializer(param))
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      https.verify_depth = 5

      while true do
        begin
          https.start do |https|
            request = Net::HTTP::Get.new(uri.request_uri)
            request["User-Agent"] = "Ruby/#{RUBY_VERSION} Pupil::Stream"
            request.oauth!(https, @consumer, @access_token)
            buf = ""
            https.request(request) do |response|
              response.read_body do |chunk|
                buf << chunk
                while (line = buf[/.+?(\r\n)+/m]) != nil
                  begin
                    buf.sub!(line,"")
                    line.strip!
                    status = JSON.parse(line)
                  rescue
                    break
                  end
                  
                  block.call StreamEvent.new(status)
                end
              end
            end
          end
        rescue => vars
          raise StreamError, "StreamError: #{vars}"
        end
      end
    end
    
    class StreamEvent
      attr_reader :type
      attr_reader :content
      
      def initialize status
        @type, @content = self.guess_event status
      end
      
      def guess_event status
        if status["delete"]
          return :delete, status["delete"]["status"]
        elsif status["friends"]
          return :friends, status["friends"]
        elsif status["event"] == "favorite"
          return :favorite, status
        elsif status["retweeted_status"]
          return :retweet, status
        elsif status["text"]
          return :status, status#Pupil::Status.new(status)
        else
          return :unknown, status
        end
      end
    end
  end
end
