module Zero
  class Request
    # This class represents all information about the client of a request.
    class Client
      # the key for the ip of the client
      KEY_REMOTE_ADDR = 'REMOTE_ADDR'
      # in proxy setups, this is the real address of the client
      KEY_FORWARDED_FOR = 'HTTP_X_FORWARDED_FOR'
      # the key for the hostname
      KEY_REMOTE_HOST = 'REMOTE_HOST'
      # the key for the user agent
      KEY_USER_AGENT  = 'HTTP_USER_AGENT'

      # creates a new client with the data of the request environment
      # @param environment a hash representation of the request
      def initialize(environment)
        # extract the two possible ips
        @forwarded_for  = environment[KEY_FORWARDED_FOR]
        @remote_address = environment[KEY_REMOTE_ADDR]
        @address    = forwarded_for || remote_address
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

      # get the forwarded address, set in proxy setups
      # @return [String] the address set in KEY_FORWARDED_FOR header
      attr_reader :forwarded_for

      # get the remote address given by KEY_REMOTE_ADDR
      # @return [String] the remote address defined in KEY_REMOTE_ADDR header
      attr_reader :remote_address
    end
  end
end
