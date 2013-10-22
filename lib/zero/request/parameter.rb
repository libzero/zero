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
      # the key to cookie heaven
      ENV_KEY_COOKIES = 'HTTP_COOKIE'
      # the separator of the type and charset
      #   for example multipart/form-data; charset=UTF-8
      CONTENT_TYPE_SEPERATOR = ';'
      # all content types which used for using the body as a parameter input
      PAYLOAD_CONTENT_TYPES = [
        'application/x-www-form-urlencoded',
        'multipart/form-data'
      ].to_set
      # match keys for list attribute
      REGEX_MATCH_LIST = /\[\]$/
      # split cookie header on =
      REGEX_SPLIT_COOKIE = /=/
      # split cookie seperator
      REGEX_SPLIT_COOKIES = /;\s*/

      # get the query parameters
      attr_reader :query
      alias_method(:get, :query)

      # get the payload or form data parameters
      attr_reader :payload
      alias_method(:post, :payload)

      # get all custom parameters
      attr_reader :custom

      # get all cookie parameters
      attr_reader :cookie

      # creates a new parameter instance
      #
      # This should never be called directly, as it will be generated for you.
      # This instance gives you the options to get query parameters (mostly
      # called GET parameters) and payload parameters (or POST parameters).
      # @param environment [Hash] the rack environment
      def initialize(environment)
        @query   = extract_query_params(environment)
        @payload = extract_payload_params(environment)
        @cookie  = extract_cookie_params(environment)
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
      # @return [String] the value of the key
      def [](key)
        @custom[key] || @payload[key] || @query[key] || @cookie[key]
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
        parse_string(environment[ENV_KEY_QUERY])
      end

      # extracts the key value pairs from the body
      # @return Hash all key value pairs from the payload
      def extract_payload_params(environment)
        unless matches_payload_types?(environment[ENV_KEY_CONTENT_TYPE])
          return {}
        end
        parse_string(environment[ENV_KEY_PAYLOAD].read)
      end

      # extracts the cookie key value pairs
      # @return Hash all key value pairs from cookies
      def extract_cookie_params(environment)
        return {} unless environment.has_key?(ENV_KEY_COOKIES)
        r = Hash[environment[ENV_KEY_COOKIES].split(REGEX_SPLIT_COOKIES).map do |e|
          e.split(REGEX_SPLIT_COOKIE)
        end]
      end

      # check if the content-type matches one of the payload types
      # @param [String] type - the content type string
      # @return Boolean true if it matches
      def matches_payload_types?(type)
        return false if type.nil?
        PAYLOAD_CONTENT_TYPES.include?(type.split(CONTENT_TYPE_SEPERATOR)[0])
      end

      # parse the query string like input to a hash
      # @param query [String] the query string
      # @return [Hash] the key/valuie pairs
      def parse_string(query)
        result = {}
        URI.decode_www_form(query).each do |p|
          if p.first.match(REGEX_MATCH_LIST)
            result[p.first] ||= []
            result[p.first] << p.last
          else
            result[p.first] = p.last
          end
        end
        result
      end
    end
  end
end
