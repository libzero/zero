module Zero
  class Request
    # This class represents all information about the client of a request.
    class Client
      # the key for the ip of the client
      KEY_REMOTE_ADDR = 'REMOTE_ADDR'
      # the key for the hostname
      KEY_REMOTE_HOST = 'REMOTE_HOST'
      # the key for the user agent
      KEY_USER_AGENT  = 'HTTP_USER_AGENT'

      # creates a new client with the data of the request environment
      # @param environment a hash representation of the request
      def initialize(environment)
        @address    = environment[KEY_REMOTE_ADDR]
        @hostname   = environment[KEY_REMOTE_HOST]
        @user_agent = environment[KEY_USER_AGENT]
      end

      # the ip address of the client
      # @return [String] the address of the client
      attr_reader :address
      # the hostname of the client
      # @return [String] the hostname of the client
      attr_reader :hostname
      # the user agent of the client
      # @return [String] the user agent of the client
      attr_reader :user_agent
    end
  end
end
