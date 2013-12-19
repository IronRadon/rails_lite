require 'erb'
require 'active_support/core_ext'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params
  attr_accessor :req, :res, :already_built_response

  def initialize(req, res, route_params = {})
    @req = req 
    @res = res
    @route_params = route_params
    @already_built_response = :false
    @params = Params.new(req, route_params)
  end

  def session
    @session ||= Session.new(@req)
  end

  def already_rendered?
  end

  def redirect_to(url)
    res.status = 302
    res['Location'] = url
    @already_built_response = :true
    session.store_session(@res)
  end

  def render_content(content, type)
    res.body = content
    res.content_type = type
    @already_built_response = :true
    session.store_session(@res)
  end

  def render(template_name)
    controller_name = self.class.name.underscore
    file_contents = File.read("views/#{controller_name}/#{template_name}.html.erb")
    erb_output = ERB.new(file_contents).result(binding)
    render_content(erb_output, 'text/text')
  end

  def invoke_action(name)
    send(name) 
    render(name) unless already_built_response == :true 
  end
end
