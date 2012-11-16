module Zero

  # This is the representation of a response
  #
  class Response
    attr_accessor :status, :header, :body

    # Returns the data of the response as an array:
    # [status, header, body]
    # to be usable by any webserver
    #
    # @return Array
    #
    def to_a()
      [@status, @header, @body]
    end

  end
end
