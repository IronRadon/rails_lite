require 'uri'
require 'debugger'

class Params
  attr_accessor :params
  def initialize(req, route_params)
    req.query_string ||= ""
    body = req.body || ""

    @params = parse_www_encoded_form(req.query_string).merge!(parse_www_encoded_form(body))
  end

  def [](key)
  end

  def to_s
    @params.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    parsed = URI.decode_www_form(www_encoded_form)
    parsed_hash = {}
    parsed.each do |value_pair|
      parsed_key = parse_key(value_pair.first) 
      parsed_hash[parsed_key.first] ||= {}
      if parsed_key.last  
        parsed_hash[parsed_key.first][parsed_key.last] = value_pair.last
      else
        parsed_hash[parsed_key.first] = value_pair.last
      end
    end
    parsed_hash
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/) #returns array like ["cat", "name"]
  end
end
