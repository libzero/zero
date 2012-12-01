# TODO should that go into the main zero file?
require 'set'

module Zero
  class Request
    # represents all parameter set in a session
    #
    # This class holds all parameters available in the rack environment, split
    # on query and payload parameters.
    class Parameter
      # they key for the query string
      ENV_KEY_QUERY   = 'QUERY_STRING'
      # the key for the payload
      ENV_KEY_PAYLOAD = 'rack.input'     
      # the key for custom parameters
      ENV_KEY_CUSTOM = 'zero.params.custom'
      # the key for the content type
      ENV_KEY_CONTENT_TYPE = 'CONTENT_TYPE'
      # all content types which used for using the body as a parameter input
      PAYLOAD_CONTENT_TYPES = [
        'application/x-www-form-urlencoded',
        'multipart/form-data'
      ].to_set

      # get the query parameters
      attr_reader :query
      alias_method(:get, :query)

      # get the payload or form data parameters
      attr_reader :payload
      alias_method(:post, :payload)

      # get all custom parameters
      attr_reader :custom

      # creates a new parameter instance
      #
      # This should never be called directly, as it will be generated for you.
      # This instance gives you the options to get query parameters (mostly
      # called GET parameters) and payload parameters (or POST parameters).
      # @param environment [Hash] the rack environment
      def initialize(environment)
        @query   = extract_query_params(environment)
        @payload = extract_payload_params(environment)
        if environment.has_key?(ENV_KEY_CUSTOM)
          @custom = environment[ENV_KEY_CUSTOM]
        else
          @custom  = {}
          environment[ENV_KEY_CUSTOM] = @custom
        end
      end

      # get a parameter
      #
      # With this method you can get the value of a parameter. First the
      # custom parameters are checked, then payload and after that the query
      # ones.
      #
      # *Beware, that this may lead to security holes!*
      #
      # @param key [String] a key to look for
      # @returns [String] the value of the key
      def [](key)
        @custom[key] || @payload[key] || @query[key]
      end

      # set a custom key/value pair
      #
      # Use this method if you want to set a custom parameter for later use. If
      # the key was already set it will be overwritten.
      # @param key [String] the key to use for saving the parameter
      # @param value [Object] the value for the key
      def []=(key, value)
        @custom[key] = value
      end

      private

      # extracts the key value pairs from the environment
      # @return Hash all key value pairs from query string
      def extract_query_params(environment)
        return {} if environment[ENV_KEY_QUERY].length == 0
        parse_string(environment[ENV_KEY_QUERY])
      end

      # extracts the key value pairs from the body
      # @return Hash all key value pairs from the payload
      def extract_payload_params(environment)
        return {} unless PAYLOAD_CONTENT_TYPES.include?(environment[ENV_KEY_CONTENT_TYPE])
        parse_string(environment[ENV_KEY_PAYLOAD].read)
      end

      # parse the query string like input to a hash
      # @param query [String] the query string
      # @return [Hash] the key/valuie pairs
      def parse_string(query)
        Hash[URI.decode_www_form(query)]
      end
    end
  end
end
