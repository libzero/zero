module Zero
  # encapsulate the rack environment
  class Request
    attr_reader :env

    # create a new 
    def initialize(env)
      @env = env
    end
  end
end
