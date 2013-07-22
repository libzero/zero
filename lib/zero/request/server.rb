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

      # This creates a new server instance extracting all server related
      #  information from the environment.
      def initialize(environment)
        @hostname = environment[KEY_SERVER_NAME]
        @port     = environment[KEY_SERVER_PORT].to_i
        @protocol = environment[KEY_SERVER_PROTOCOL]
        @software = environment[KEY_SERVER_SOFTWARE]
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

      # returns the full name of the server
      # @return [String] the full address to the server
      def name
        return @name if @name
        @name = protocol + '://' + hostname + ':' + port.to_s
      end
    end
  end
end
