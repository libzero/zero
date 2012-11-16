require_relative 'accept_type'

module Zero
  class Request
    # encapsulates the accept header to easier work with
    # this is partly copied from sinatra
    class Accept
      MEDIA_TYPE_SEPERATOR  = ','
      MEDIA_PARAM_SEPERATOR = ';'
      MEDIA_QUALITY_REGEX   = /q=[01]\./

      KEY_HTTP_ACCEPT = 'HTTP_ACCEPT'
      KEY_HTTP_ACCEPT_LANGUAGE = 'HTTP_ACCEPT_LANGUAGE'
      KEY_HTTP_ACCEPT_ENCODING = 'HTTP_ACCEPT_ENCODING'

      def self.map=(map)
        @@map = map
      end

      def self.map
        @@map ||= {}
      end

      # create a new accept object
      def initialize(environment)
        @accept_types = AcceptType.new(environment[KEY_HTTP_ACCEPT])
        @accept_language = AcceptType.new(environment[KEY_HTTP_ACCEPT_LANGUAGE])
        @accept_encoding = AcceptType.new(environment[KEY_HTTP_ACCEPT_ENCODING])
      end

      attr_reader :accept_types
      attr_reader :accept_language
      attr_reader :accept_encoding
    end
  end
end
