module Zero
  # an easier interface for the response
  #
  # The response for rack has to be an array of three elements. This class makes
  # it easier to fill all the needed data.
  class Response
    attr_reader :code, :header, :body

    # init a new response
    def initialize
      @code   = 404
      @header = {}
      @body   = nil
    end

    # builds the response for rack and checks for protocol errors
    # @return Array the rack response
    def response

    end
  end
end
