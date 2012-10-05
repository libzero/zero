module Zero

  # abstract class to make creation of controllers easier
  #
  # This abstract class creates an interface to make it easier to write
  # rack compatible controllers. It catches #call and creates a new instance
  # with the environment and calls #render on it.
  class Controller
    def self.call(env)
      new(Request.new(env)).render
    end

    def initialize(request)
      @request  = request
      @code     = 200
      @header   = {}
      @body     = ''
    end

    def response
      render
      [@code, @header, [@body]]
    end

    def render
      raise NotImplementedError
    end
  end
end
