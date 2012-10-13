require 'zero/all'

class SpecApp
  attr_reader :env

  def call(env)
    @env = env
    return [200, {'Content-Type' => 'text/html'}, ['success']]
  end
end

def generate_env(path, options = {})
  Rack::MockRequest.env_for(path, options = {})
end
