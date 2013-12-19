class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method = pattern, http_method
    @controller_class, @action_name = controller_class, action_name
  end

  def matches?(req)
    http_method.downcase.to_sym == req.request_method.downcase.to_sym &&
    pattern.match(req.path)
  end 

  def run(req, res)
    matches = pattern.match(req.path) #this is a MatchData object
    keys = matches.names
    values = matches.captures
    route_params = {}

    keys.each_with_index do |key, index|
      route_params[key.to_sym] = values[index]
    end
    p route_params
    controller = controller_class.new(req, res, route_params)
    controller.invoke_action(action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    # add these helpers in a loop here
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end  
  end

  def match(req)
    @routes.find do |route|
      route.matches?(req)
    end
  end

  def run(req, res)
    matched_route = match(req)
    if matched_route 
      matched_route.run(req, res)
    else
      res.status = 404
    end
  end
end
