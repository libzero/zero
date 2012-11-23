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
    # Also converts every input directly to an integer
    #
    # @param [Integer] status
    #
    def status=(status)
      @status = status.to_i
    end

    # Returns the data of the response as an array:
    # [status, header, body]
    # to be usable by any webserver
    #
    # @return [Array]
    #
    def to_a
      # TODO Remove content length and body, on certain status codes
      if status == 204
        header.delete('Content-Length')
        header.delete('Content-Type')
        body = []
      else
        # Set content length, if not already set
        content_length unless header.has_key? 'Content-Length'
        # Set content type, if not already set
        content_type 'text/html' unless header.has_key? 'Content-Type'
      end

      [status, header, body]
    end

    # Sets the content length header to the current length of the body
    # Also creates one, if it does not exists
    #
    def content_length
      header['Content-Length'] = body.join.bytesize
    end

    # Sets the content type to the given value
    # Also creates it, if it does not exists
    #
    def content_type(value)
      header['Content-Type'] = value
    end

  end
end
