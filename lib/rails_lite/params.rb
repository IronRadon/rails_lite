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
    parsed = URI.decode_www_form(www_encoded_form) #this is an array of [keys, value] pairs
    parsed_hash = {}
  
    parsed.each do |keyset, value|
      parsed_keys = parse_key(keyset)
      #parsed_keys is now an array of keys, e.g. ["cat", "name", "fname"]
      nesting_level = parsed_hash

      parsed_keys.each_with_index do |key, key_index|
        if key_index + 1 == parsed_keys.count
          nesting_level[key] = value
        else #set up the next level down
          nesting_level[key] ||= {}
          nesting_level = nesting_level[key]
        end
      end
    end
    parsed_hash
  end


  def parse_key(key)
    key.split(/\]\[|\[|\]/) #returns array like ["cat", "name"]
  end
end


  