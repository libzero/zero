require_relative 'request/accept'
require_relative 'request/parameter'

module Zero
  # This class wraps around a rack environment for easier access to all data.
  class Request
    # create a new request object
    def initialize(env)
      @env = env
      @method = @env[CONST_REQUEST_METHOD].downcase.to_sym
    end

    # get the requested path
    # @return [String] returns the requested path
    def path
      @path ||= @env[CONST_PATH_INFO]
    end

    # get an object representing the parameters of the request
    # @return [Parameter] object having all parameters
    def params
      @params ||= Request::Parameter.new(@env)
    end

    # return the content type of the request
    # TODO change into its own object?
    # @return [String] returns the content type of the request
    def content_type
      @env[CONST_CONTENT_TYPE] if @env.has_key?(CONST_CONTENT_TYPE)
    end

    # get the media types
    # @return [Accept] on Accept object managing all types and their order
    def media_types
      @accept ||= Request::Accept.new(@env[CONST_HTTP_ACCEPT])
    end

    # get the method of the request
    # @return [Symbol] the symbol representation of the method
    attr_reader :method
    # is the method 'GET'?
    # @return true if this is a get request
    def get?;  @method == :get;  end
    # is the method 'POST'?
    # @return true if this is a post request
    def post?; @method == :post; end
    # is the method 'PUT'?
    # @return true if this is a put request
    def put?;  @method == :put;  end
    # is the method 'DELETE'?
    # @return true if this is a delete request
    def delete?; @method == :delete; end
    # is the method 'HEAD'?
    # @return true if this is a head request
    def head?; @method == :head; end
    # is the method 'PATCH'?
    # @return true if this is a patch request
    def patch?; @method == :patch; end

    private

    # constant for the content type key
    # @api private
    CONST_CONTENT_TYPE   = 'CONTENT_TYPE'
    # constant for the http accept key
    # @api private
    CONST_HTTP_ACCEPT    = 'HTTP_ACCEPT'
    # constant for the path info key
    # @api private
    CONST_PATH_INFO      = 'PATH_INFO'
    # constant for the request method key
    # @api private
    CONST_REQUEST_METHOD = 'REQUEST_METHOD'
  end
end
