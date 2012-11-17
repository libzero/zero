module Zero

  # This is the representation of a response
  #
  class Response
    attr_reader :status
    attr_accessor :header, :body

    # Construtor
    # Sets default status code to 200.
    #
    def initialize
      @status = 200
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
    # @return Array
    #
    def to_a()
      [@status, @header, @body]
    end

  end
end
