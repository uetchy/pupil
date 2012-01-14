class Pupil
  class Keygen
    attr_reader :consumer_key
    attr_reader :consumer_secret
    attr_reader :access_token
    attr_reader :access_token_secret
    class MissingRequiredTokens < StandardError; end

    def initialize(opts={})
      @consumer_key = opts[:consumer_key] rescue nil
      @consumer_secret = opts[:consumer_secret] rescue nil
      @access_token = opts[:access_token] rescue nil
      @access_token_secret = opts[:access_token_secret] rescue nil
    end
    
    def auth_url
      raise MissingRequiredTokens, "Pupil::Keygen#auth_url require consumer_key and consumer_secret" unless @consumer_key || @consumer_secret
      consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret, :site => 'http://twitter.com')
      request_token = consumer.get_request_token
      return request_token.authorize_url
    end
    
    def issue_token verifier
      raise MissingRequiredTokens, "Pupil::Keygen#issue_token require consumer_key and consumer_secret" unless @consumer_key || @consumer_secret
      consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret, :site => 'http://twitter.com')
      request_token = consumer.get_request_token
      access_token = request_token.get_access_token(:oauth_verifier => verifier)
      @access_token = access_token.token
      @access_token_secret = access_token.secret
      return {:access_token => access_token.token, :access_token_secret => access_token.secret}
    end
    
    def pupilkey
      raise MissingRequiredTokens, "Pupil::Keygen#pupilkey require consumer_key, consumer_secret, access_token and access_token_secret" unless @consumer_key || @consumer_secret || @access_token || @access_token_secret
      return {
        :consumer_key => @consumer_key,
        :consumer_secret => @consumer_secret,
        :access_token => @access_token,
        :access_token_secret => @access_token_secret
      }
    end

    def interactive
      print "Enter OAuth Consumer Key: " unless @consumer_key
      @consumer_key = gets.chomp.strip unless @consumer_key
      print "Enter OAuth Consumer Secret: " unless @consumer_secret
      @consumer_secret = gets.chomp.strip unless @consumer_secret

      consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret, :site => 'http://twitter.com')

      request_token = consumer.get_request_token

      puts "Access to this URL and approve: #{request_token.authorize_url}"

      print "Enter OAuth Verifier: "
      oauth_verifier = gets.chomp.strip

      access_token = request_token.get_access_token(:oauth_verifier => oauth_verifier)
      @access_token = access_token.token
      @access_token_secret = access_token.secret
      
      puts "Process complete!"
      puts "Access token: #{access_token.token}"
      puts "Access token secret: #{access_token.secret}"
      return {:consumer_key => @consumer_key, :consumer_secret => @consumer_secret, :access_token => access_token.token, :access_token_secret => access_token.secret}
    end
  end
end