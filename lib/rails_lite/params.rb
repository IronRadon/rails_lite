require 'uri'
require 'debugger'

class Params
  attr_accessor :params
  def initialize(req, route_params)
    req.query_string ||= ""
    @params = parse_www_encoded_form(req.query_string)
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
      parsed_hash[value_pair.first] = value_pair.last
    end
    parsed_hash
  end

  def parse_key(key)
  end
end
