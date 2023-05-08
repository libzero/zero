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

      # create a new accept object
      def initialize(environment)
        @types = AcceptType.new(environment[KEY_HTTP_ACCEPT])
        @language = AcceptType.new(environment[KEY_HTTP_ACCEPT_LANGUAGE])
        @encoding = AcceptType.new(environment[KEY_HTTP_ACCEPT_ENCODING])
      end

      attr_reader :types
      attr_reader :language
      attr_reader :encoding
    end
  end
end
