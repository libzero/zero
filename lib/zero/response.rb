require_relative 'response/cookie'

module Zero
  # This is the representation of a response
  class Response
    # the status code of the response
    attr_reader :status
    # the body of the response
    attr_reader :body
    # set or get current headers
    attr_accessor :header

    # Constructor
    # Sets default status code to 200.
    def initialize
      @status = 200
      @header = {}
      @body   = []
      @cookies = {}
    end

    # Sets the status.
    # Also converts every input directly to an integer.
    #
    # @param [Integer] status The status code
    def status=(status)
      @status = status.to_i
    end

    # set the body to a new value
    #
    # Use this function to set the body to a new value. It can either be an
    # Object responding to `#each` per rack convention or a kind of string.
    #
    # @param content [#each, String] the content of the body
    def body=(content)
      content = [content] if content.kind_of?(String)

      unless content.respond_to?(:each) then
        raise ArgumentError.new(
          "invalid body! Should be kind of String or respond to #each!")
      end

      @body = content
    end

    # Returns the data of the response as an array:
    # [status, header, body]
    # to be usable by any webserver.
    #
    # Sets the Content-Type to 'text/html', if it's not already set.
    # Sets the Content-Length, if it's not already set. (Won't fix wrong
    # lengths!)
    # Removes Content-Type, Content-Length and body on status code 204 and 304.
    #
    # @return [Array] Usable by webservers
    def to_a
      add_cookie_headers
      # Remove content length and body, on status 204 and 304
      if status == 204 or status == 304
        header.delete('Content-Length')
        header.delete('Content-Type')
        self.body = []
      else
        # Set content length, if not already set
        content_length unless header.has_key? 'Content-Length'
        # Set content type, if not already set
        self.content_type = 'text/html' unless header.has_key? 'Content-Type'
      end

      [status, header, body]
    end

    # Sets the content length header to the current length of the body
    # Also creates one, if it does not exists
    def content_length
      self.header['Content-Length'] = body.join.bytesize.to_s
    end

    # Sets the content type header to the given value
    # Also creates it, if it does not exists
    #
    # @param [String] value Content-Type tp set
    def content_type=(value)
      self.header['Content-Type'] = value
    end

    # Sets the Location header to the given URL and the status code to
    # 303 - See Other.
    # 
    # @param [String] location Redirect URL
    def redirect(location, status = 303)
      self.status = status
      self.header['Location'] = location
    end

    # get the cookie for the response
    #
    # This returns the cookie holding all crumbs for the response.
    # @response [Cookie] the cookie with crumbs holding the information
    def cookie
      @cookie ||= Cookie.new
    end

    private

    # merge the cookie header into the other headers
    def add_cookie_headers
      return unless @cookie
      header.merge!(cookie.to_header)
    end
  end
end
