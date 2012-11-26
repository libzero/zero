module Zero
  # abstract class to make creation of controllers easier
  #
  # This abstract class creates an interface to make it easier to write
  # rack compatible controllers. It catches #call and creates a new instance
  # with the environment and calls #render on it.
  class Controller
    # initialize a new instance of the controller and call response on it
    def self.call(env)
      new(Zero::Request.new(env)).response
    end

    # set the renderer to use in the controller
    def self.renderer=(renderer)
      @@renderer = renderer
    end

    # get the renderer set in the controller
    def self.renderer
      @@renderer
    end

    # a small helper to get the actual renderer
    def renderer
      self.class.renderer
    end

    # initialize the controller
    # @param request [Request] a request object
    def initialize(request)
      @request  = request
      @response = Zero::Response.new
    end

    # build the response and return it
    #
    # This method calls #process if it was defined so make it easier to process
    # the request before rendering stuff.
    # @return Response a rack conform response
    def response
      process if respond_to?(:process)
      render
      @response.to_a
    end
  end
end
