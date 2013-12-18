require 'webrick'

first_server = WEBrick::HTTPServer.new :Port => 8080#, :DocumentRoot => root

first_server.mount_proc '/' do |req, res|
	res.content_type = 'text/text'
	res.body = req.path
end

trap 'INT' do 
	first_server.shutdown
end
first_server.start