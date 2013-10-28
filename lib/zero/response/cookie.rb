module Zero
  class Response
    class Cookie
      # initialize an empty cookie
      def initialize
        @crumbs = {}
      end

      # add a new crumb
      #
      # This adds a new crumb to the cookie specified through the key.
      # @param key [String] the identifier for the crumb
      # @param value [String] the value for the crumb
      # @param options [Hash] hash with further options for the crumb
      # @option options [Time]   :expire the time when the crumb should expire
      # @option options [String] :domain the domain the crumb should be sent to
      # @option options [String] :path   path when the crumb should be sent
      # @option options [Array]  :flags set flags for :secure or :http_only
      def add_crumb(key, value, options = {:flags => []})
        @crumbs[key] = Crumb.new(key, value, options)
      end

      # get the crumb for the key
      #
      # This method returns the crumb for the specified key. The crumb holds all
      # information, like the expire time and domain and so on.
      # @param key [String] the key to return
      # @returns [Cookie::Crumb] a cookie crumb or nil when the key
      #                             does not exist
      def get_crumb(key)
        @crumbs[key]
      end

      # merge all crumbs to one header line
      #
      # This merges all crumbs together to a header line, where each cookie is
      # separated by the `Set-Cookie` header.
      # @returns [Hash] a key value pair to merge with the headers
      def to_header
        {'Set-Cookie' => @crumbs.map{|key, crumb| crumb}.join("\nSet-Cookie: ")}
      end
      
      private

      class Crumb
        attr_reader :key, :secure, :http_only
        attr_accessor :domain, :path, :expire, :value

        def initialize(key, value, options = {})
          options[:flags] ||= []
          @key       = key
          @value     = value
          @domain    = options[:domain]
          @expire    = options[:expire]
          @path      = options[:path]
          @secure    = options[:flags].include?(:secure)
          @http_only = options[:flags].include?(:http_only)
        end

        # set the `http_only` flag
        #
        # This method sets the flag to only allow modifications from the
        # server and makes the browser not allow modifications through
        # javascript.
        def deny_client_side_modification!
          @http_only = true
        end

        # remove the `http_only` flag
        #
        # This removes the `http_only` flag to allow modifications of the
        # crumb through javascript.
        def allow_client_side_modification!
          @http_only = false
        end

        # set the `secure` flag
        #
        # This sets the `secure` flag on the crumb which tells the browser to
        # only send it through secure channels, like https.
        # Keep in mind, that this does not encrypt the content of the Crumb!
        def secure!
          @secure = true
        end

        # unset the `secure` flag
        #
        # This unsets the `secure` flag which tells the browser, that it can
        # send the crumb over unsecure channel too, like plain http.
        def unsecure!
          @secure = false
        end

        def to_s
          "#{@key}=#{@value}" +
            (@expire ? "; Expires=#{@expire.rfc2822}" : '') +
            (@path   ? "; Path=#{@path}" : '') +
            (@domain ? "; Domain=#{domain}" : '') +
            (@http_only ? '; HttpOnly' : '') +
            (@secure    ? '; Secure' : '')
        end
      end
    end
  end
end
