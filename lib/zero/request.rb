require_relative 'request/accept'
require_relative 'request/parameter'

module Zero
  # This class wraps around a rack environment for easier access to all data.
  class Request
    CONST_CONTENT_TYPE   = 'CONTENT_TYPE'
    CONST_HTTP_ACCEPT    = 'HTTP_ACCEPT'
    CONST_PATH_INFO      = 'PATH_INFO'
    CONST_REQUEST_METHOD = 'REQUEST_METHOD'

    # create a new request object
    def initialize(env)
      @env = env
      @method = @env[CONST_REQUEST_METHOD].downcase.to_sym
    end

    # get the requested path
    def path
      @path ||= @env[CONST_PATH_INFO]
    end

    # returns a set of get and post variables
    def params
      @params ||= Request::Parameter.new(@env)
    end

    # return the content type of the request
    # TODO change into its own object?
    def content_type
      @env[CONST_CONTENT_TYPE] if @env.has_key?(CONST_CONTENT_TYPE)
    end

    # get the media types
    # @return Accept on Accept object managing all types and their order
    def media_types
      @accept ||= Request::Accept.new(@env[CONST_HTTP_ACCEPT])
    end

    # is the method 'GET'?
    def get?;  @method == :get;  end
    # is the method 'POST'?
    def post?; @method == :post; end
    # is the method 'PUT'?
    def put?;  @method == :put;  end
    # is the method 'DELETE'?
    def delete?; @method == :delete; end
    # is the method 'HEAD'?
    def head?; @method == :head; end
    # is the method 'PATCH'?
    def head?; @method == :patch; end
  end
end
