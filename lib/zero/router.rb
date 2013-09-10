module Zero
  # makes it possible to route urls to rack applications
  #
  # This class can be used to build a small rack application which routes
  # requests to the given application.
  # In the URLs it is also possible to use placeholders which then get assigned
  # as variables to the parameters.
  #
  # @example of a simple router
  #   router = Zero::Router.new(
  #     '/' => WelcomeController,
  #     '/posts' => PostController
  #   )
  #
  # @example of a router with variables
  #   router = Zero::Router.new(
  #     '/foo/:id' => FooController
  #   )
  class Router
    # match for variables in routes
    VARIABLE_MATCH = %r{:(\w+)[^/]?}
    # the replacement string to make it an regex
    VARIABLE_REGEX = '(?<\1>[\w-]+?)'
    # regex part of the beginning of the line
    REGEX_BEGINNING = '\A'
    # regex part of the end of the line
    REGEX_END       = '\Z'
    # environment key to store custom parameters
    ENV_KEY_CUSTOM = 'zero.params.custom'
    # environment key to the path info
    ENV_KEY_PATH_INFO = 'PATH_INFO'

    # create a new router instance
    #
    # @example of a simple router
    #   router = Zero::Router.new(
    #     '/' => WelcomeController,
    #     '/posts' => PostController
    #   )
    # 
    # @param routes [Hash] a map of URLs to rack compatible applications
    def initialize(routes)
      @routes = {}
      routes.to_a.sort_by(&:first).reverse.each do |route, target|
        @routes[
          Regexp.new(REGEX_BEGINNING +
                     route.gsub(VARIABLE_MATCH, VARIABLE_REGEX) +
                     REGEX_END)] = target
      end
    end

    # call the router and call the matching application
    #
    # This method has to be called with a rack compatible environment, then the
    # method will find a matching route and call the application.
    # @param env [Hash] a rack environment
    # @return [Array] a rack compatible response
    def call(env)
      env[ENV_KEY_CUSTOM] ||= {}
      @routes.each do |route, target|
        match = route.match(env[ENV_KEY_PATH_INFO])
        if match
          match.names.each_index do |i|
            env[ENV_KEY_CUSTOM][match.names[i]] = match.captures[i]
          end
          return target.call(env)
        end
      end
      [404, {'Content-Type' => 'text/html'}, ['Not found!']]
    end
  end
end
