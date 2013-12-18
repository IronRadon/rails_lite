require 'json'
require 'webrick'

class Session
  def initialize(req)
  	cookie = req.cookies.find {|cookie| cookie.name == '_rails_lite_app'}
  	if cookie
  		@cookie = JSON.parse(cookie.value)
  	else
  		@cookie = {}
  	end
  end

  def [](key)
  	@cookie[key]
  end

  def []=(key, val)
  	@cookie[key] = val
  end

  def store_session(res)
  	cookie = WEBrick::Cookie.new('_rails_lite_app', @cookie.to_json)
  	res.cookies << cookie
  end
end
