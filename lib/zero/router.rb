module Zero
  class Router
    # match for variables in routes
    VARIABLE_MATCH = %r{:(\w+)[^/]?}
    # the replacement string to make it an regex
    VARIABLE_REGEX = '(?<\1>.+?)'

    def initialize(routes)
      @routes = {}
      routes.each do |route, target|
        @routes[
          Regexp.new(
            route.gsub(VARIABLE_MATCH, VARIABLE_REGEX) + '$')] = target
      end
    end

    def call(env)
      request = Rack::Request.new(env)
      @routes.each do |route, target|
        match = route.match(request.path)
        if match
          match.names.each_index do |i|
            request.update_param(match.names[i], match.captures[i])
          end
          return target.call(request.env)
        end
      end
      [404, {'Content-Type' => 'text/html'}, ['Not found!']]
    end
  end
end
