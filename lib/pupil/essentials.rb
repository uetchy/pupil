class Hash
  def method_missing(action, *args)
    return self[action.to_s] rescue raise NoMethodError
  end
end

class Pupil
  module Essentials
    # @param [Hash] parameter
    # @return [String] URL Serialized parameters
    def serialize_parameter parameter
      return "" unless parameter.class == Hash
      ant = Hash.new
      parameter.each do |key, value|
        case key.to_sym
        when :include
          if value.class == String || Symbol
            ant[:"include_#{value}"] = "true"
            break
          end
        when :exclude
          if value.class == String || Symbol
            ant[:"exclude_#{value}"] = "true"
            break
          end
        else
          ant[key.to_sym] = value.to_s
        end
      end
      param = ant.inject(""){|k,v|k+"&#{v[0]}=#{URI.escape(v[1])}"}.sub!(/^&/,"?")
      return param ? param : ""
    end

    def guess_parameter(parameter)
      case parameter.class.to_s
      when "Fixnum", "Bignum"
        :user_id
      when "Symbol", "String"
        :screen_name
      else
        false
      end
    end

    def get(url, param={})
      param_s = serialize_parameter(param)
      puts "/1.1/"+url+param_s
      begin
        response = @access_token.get("/1.1/"+url+param_s).body
      rescue => vars
        raise NetworkError, vars
      end
      
      result = JSON.parse(response)
      return (result["errors"].nil? rescue true)? result : false
    end

    def post(url, param={})
      param_s = serialize_parameter(param)
      begin
        response = @access_token.post(url+param_s).body
      rescue => vars
        raise NetworkError, vars
      end
      result = JSON.parse(response)
      return (result["errors"].nil? rescue true)? result : false
    end
  end
end