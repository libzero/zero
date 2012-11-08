# TODO should that go into the main zero file?
require 'set'

module Zero
  class Request
    # represents all parameter set in a session
    #
    # This class holds all parameters available in the rack environment, split
    # on query and payload parameters.
    class Parameter
      ENV_KEY_QUERY   = 'QUERY_STRING'
      ENV_KEY_PAYLOAD = 'rack.input'     
      ENV_KEY_CONTENT_TYPE = 'CONTENT_TYPE'
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

      # creates a new parameter instance
      #
      # This should never be called directly, as it will be generated for you.
      # This instance gives you the options to get query parameters (mostly
      # called GET parameters) and payload parameters (or POST parameters).
      # @param environment [Hash] the rack environment
      def initialize(environment)
        @query   = extract_query_params(environment)
        @payload = extract_payload_params(environment)
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
        params = query.split('&')
        params.map! {|part| part.split('=') }
        Hash[params]
      end
    end
  end
end
