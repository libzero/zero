module Zero
  # abstract class to make creation of controllers easier
  #
  # This abstract class creates an interface to make it easier to write
  # rack compatible controllers. It catches #call and creates a new instance
  # with the environment and calls #render on it.
  class Controller
    extend ClassOptions::Options
    # initialize a new instance of the controller and call response on it
    def self.call(env)
      new(env).response
    end

    # set the class to use for responses
    options :response

    # set a class to use for requests
    options :request

    # set the renderer to use in the controller
    options :renderer

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
    # This method calls #process. #process has to be provided by the actual
    # implementation and should do all processing necessary to provide the
    # content.
    # @return Response a rack conform response
    def response
      process
      @response.to_a
    end

    # renders a template
    #
    # This method calls #render of the provided renderer and gives it the
    # template name and accept types, so that the renderer can search for the
    # appropiate template to render.
    def render(template)
      @renderer.render(template, @request.accept.types, self)
    end
  end
end
