class Pupil
  class Stream
    attr_reader :screen_name
    class StreamError < StandardError ; end
    STREAM_APIS = {
      :userstream => "https://userstream.twitter.com/2/user.json",
      :filter => "https://stream.twitter.com/1/statuses/filter.json%s"
    }

    def initialize key
      @screen_name = key[:screen_name]

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
    
    # @return [Pupil::Stream::Shash, Pupil::Stream::Status] event variable supported :status, :retweeted, :favorite, :friends and :delete
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
                  
                  event = self.guess_event status
                  block.call event
                end
              end
            end
          end
        rescue => vars
          raise StreamError, "StreamError: #{vars}"
        end
      end
    end
    
    def guess_event status
      if status["delete"]
        return Shash.new(:delete, status["delete"]["status"])
      elsif status["friends"]
        return Shash.new(:friends, status["friends"])
      elsif status["event"] == "favorite"
        return Shash.new(:favorite, status)
      elsif status["retweeted_status"]
        return Status.new(status, :retweeted)
      elsif status["text"]
        return Status.new(status)
      else
        return Shash.new(:unknown, status)
      end
    end
    
    # Stream Status
    class Status < Pupil::Status
      attr_reader :event
      attr_reader :retweeted_status
      
      def initialize status, event=nil
        super(status)
        @event = (event)? event : :status
        @retweeted_status = status["retweeted_status"]
      end
    end
    
    # Stream Hash
    class Shash
      attr_reader :event
      
      def initialize event, status
        @hash = status
        @event = event
      end
      
      def [] param
        @hash[param]
      end
      
      def size
        @hash.size
      end
      
      alias_method :length, :size
    end
  end
end
