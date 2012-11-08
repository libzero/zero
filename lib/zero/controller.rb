module Zero
  # abstract class to make creation of controllers easier
  #
  # This abstract class creates an interface to make it easier to write
  # rack compatible controllers. It catches #call and creates a new instance
  # with the environment and calls #render on it.
  class Controller
    # initialize a new instance of the controller and call response on it
    def self.call(env)
      new(Rack::Request.new(env)).response
    end

    # initialize the controller
    # @param request [Request] a request object
    def initialize(request)
      @request  = request
      @response = Rack::Response.new
    end

    # build the response and return it
    # @return Response a rack conform response
    def response
      raise NotImplementedError.new("Not Implemented in ${__FILE__}")
    end
  end
end
