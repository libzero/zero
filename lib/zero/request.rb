require_relative 'request/accept'
require_relative 'request/client'
require_relative 'request/parameter'
require_relative 'request/server'

module Zero
  # This class wraps around a rack environment for easier access to all data.
  class Request
    def self.create(environment)
      return environment['zero.request'] if environment.has_key?('zero.request')
      new(environment)
    end

    # create a new request object
    def initialize(env)
      @env = env
      @env['zero.request'] = self
    end

    # get the environment
    # @return [Hash] the environment hash
    attr_reader :env

    # get the requested path
    # @return [String] returns the requested path
    def path
      @path ||= @env[CONST_PATH_INFO]
    end

    # return all information about the client
    # @return [Client] an information object about the client
    def client
      @client ||= Request::Client.new(@env)
    end

    # get the information on the server
    # @return [Server] information on the running server
    def server
      @server ||= Request::Server.new(@env)
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
    def accept
      @accept ||= Request::Accept.new(@env)
    end

    # get the method of the request
    # @return [Symbol] the symbol representation of the method
    def method
      @method ||= @env[CONST_REQUEST_METHOD].downcase.to_sym
    end
    # is the method 'GET'?
    # @return [Boolean] true if this is a get request
    def get?;  method == :get;  end
    # is the method 'POST'?
    # @return [Boolean] true if this is a post request
    def post?; method == :post; end
    # is the method 'PUT'?
    # @return [Boolean] true if this is a put request
    def put?;  method == :put;  end
    # is the method 'DELETE'?
    # @return [Boolean] true if this is a delete request
    def delete?; method == :delete; end
    # is the method 'HEAD'?
    # @return [Boolean] true if this is a head request
    def head?; method == :head; end
    # is the method 'PATCH'?
    # @return [Boolean] true if this is a patch request
    def patch?; method == :patch; end

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
