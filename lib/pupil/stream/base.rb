class Pupil
  class Stream
    attr_reader :screen_name
    STREAM_APIS = {
      :userstream => "https://userstream.twitter.com/2/user.json",
      :search => "https://stream.twitter.com/1/statuses/filter.json%s"
    }
    
    include Essentials

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
      uri = URI.parse(STREAM_APIS[type] % serialize_parameter(param))
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      https.verify_depth = 5

      while true do
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
      end
    end

    def guess_event status
      if status["delete"]
        return Pupil::Stream::Hash.new(status["delete"]["status"], :delete)
      elsif status["friends"]
        return Pupil::Stream::Array.new(status["friends"], :friends)
      elsif status["event"] == "favorite"
        return Pupil::Stream::Hash.new(status, :favorite)
      elsif status["retweeted_status"]
        return Pupil::Stream::Status.new(status, @access_token, :retweeted)
      elsif status["text"]
        return Pupil::Stream::Status.new(status, @access_token)
      else
        return Pupil::Stream::Hash.new(status, :unknown)
      end
    end

    # Stream Status
    class Status < Pupil::Status
      attr_reader :event
      attr_reader :retweeted_status

      def initialize(status, access_token, event=nil)
        super(status, access_token)
        @event = (event)? event : :status
        #@retweeted_status = status["retweeted_status"]
      end
    end

    # Stream Hash
    class Hash < Hash
      attr_reader :event

      def initialize(status, event)
        super()
        self.update(status)
        @event = event
      end
    end

    # Stream Array
    class Array < Array
      attr_reader :event

      def initialize(status, event)
        super(status)
        #self.update(status)
        @event = event
      end
    end
  end
end
