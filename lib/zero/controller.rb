module Zero
  # abstract class to make creation of controllers easier
  #
  # This abstract class creates an interface to make it easier to write
  # rack compatible controllers. It catches #call and creates a new instance
  # with the environment and calls #render on it.
  class Controller
    # initialize a new instance of the controller and call response on it
    def self.call(env)
      new(env).response
    end

    # set the class to use for responses
    def self.response=(response_class)
      @@response = response_class
    end

    # return the set response class
    def self.response
      @@response ||= Zero::Response
    end

    # set a class to use for requests
    def self.request=(request_class)
      @@request = request_class
    end

    # return the set request class
    def self.request
      @@request ||= Zero::Request
    end

    # set the renderer to use in the controller
    def self.renderer=(renderer)
      @@renderer = renderer
    end

    # get the renderer set in the controller
    def self.renderer
      @@renderer
    end

    # the renderer which can be used to render templates
    attr_reader :renderer

    # initialize the controller
    #
    # This creates a new controller instance using the defined classes of
    # renderer, request and response.
    # @param env [Hash] a rack compatible environment
    def initialize(env)
      @request  = self.class.request.new(env)
      @response = self.class.response.new
      @renderer = self.class.renderer
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
