module Zero

  # This is the representation of a response
  #
  class Response
    attr_reader :status
    attr_accessor :header, :body

    # Constructor
    # Sets default status code to 200.
    #
    def initialize
      @status = 200
      @header = {}
      @body   = []
    end

    # Sets the status.
    # Also converts every input directly to an integer.
    #
    # @param [Integer] status The status code
    #
    def status=(status)
      @status = status.to_i
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
    #
    def to_a
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
    #
    def content_length
      self.header['Content-Length'] = body.join.bytesize.to_s
    end

    # Sets the content type header to the given value
    # Also creates it, if it does not exists
    #
    # @param [String] value Content-Type tp set
    #
    def content_type=(value)
      self.header['Content-Type'] = value
    end

    # Sets the Location header to the given URL and the status code to 302.
    # 
    # @param [String] location Redirect URL
    #
    def redirect(location)
      self.status = 302
      self.header['Location'] = location
    end

  end
end
