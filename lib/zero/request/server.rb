module Zero
  class Request
    # This class represents all server related information of a request.
    class Server
      # the key for the server name
      # @api private
      KEY_SERVER_NAME     = 'SERVER_NAME'
      # the key for the server port
      # @api private
      KEY_SERVER_PORT     = 'SERVER_PORT'
      # the key for the server protocol
      # @api private
      KEY_SERVER_PROTOCOL = 'SERVER_PROTOCOL'
      # the key for the server software
      # @api private
      KEY_SERVER_SOFTWARE = 'SERVER_SOFTWARE'
      # the key for https
      # @api private
      KEY_HTTPS           = 'HTTPS'
      # the https on switch
      # @api private
      KEY_HTTPS_ON_SWITCH = ['on', 'yes', '1']
      # the string for http
      # @api private
      HTTP                = 'http'
      # the string for https
      # @api private
      HTTPS               = 'https'
      # protocol seperator
      # @api private
      URI_SEP_PROTOCOL    = '://'
      # port separator
      # @api private
      URI_SEP_PORT        = ':'
      # default http port
      # @api private
      DEFAULT_PORT_HTTP   = 80
      # default https port
      # @api private
      DEFAULT_PORT_HTTPS  = 443

      # This creates a new server instance extracting all server related
      #  information from the environment.
      def initialize(environment)
        @hostname = environment[KEY_SERVER_NAME]
        @port     = environment[KEY_SERVER_PORT].to_i
        @protocol = environment[KEY_SERVER_PROTOCOL]
        @software = environment[KEY_SERVER_SOFTWARE]
        p environment[KEY_HTTPS]
        if KEY_HTTPS_ON_SWITCH.include?(environment[KEY_HTTPS])
          @is_https = true
        else
          @is_https = false
        end
      end

      # get the port
      # @return [Numeric] the port
      attr_reader :port
      # get the hostname of the server
      # @return [String] the hostname
      attr_reader :hostname
      # get the protocol of the server (normally it should be HTTP/1.1)
      # @return [String] the protocol
      attr_reader :protocol
      # get the server software
      # @return [String] the server software name
      attr_reader :software
      # get if the request is served through https
      # @return [Boolean] true if server got the request through https
      def is_https?; @is_https; end
      # get if the request is served through http
      # @return [Boolean] true if server got the request though http
      def is_http?; !@is_https; end

      # return the uri to the server
      # @return [String] the root uri to the server
      def uri
        uri = (is_https? ? HTTPS : HTTP) + URI_SEP_PROTOCOL + hostname
        if (port == DEFAULT_PORT_HTTP && is_http?) ||
                                    (port == DEFAULT_PORT_HTTPS && is_https?)
          return uri
        end
        uri + URI_SEP_PORT + port.to_s
      end
    end
  end
end
