require 'zero/all'

class SpecApp
  attr_reader :env

  def call(env)
    @env = env
    return [200, {'Content-Type' => 'text/html'}, ['success']]
  end
end

class EnvGenerator
  KEY_REQUEST_METHOD = 'REQUEST_METHOD'
  KEY_REQUEST_GET    = 'GET'
  KEY_REQUEST_POST   = 'POST'

  def self.generate_env(uri, options)
    Rack::MockRequest.env_for(uri, options)
  end

  def self.get(uri, options = {})
    generate_env(uri, options.merge(KEY_REQUEST_METHOD => KEY_REQUEST_GET))
  end

  def self.post(uri, options = {})
    generate_env(uri, options.merge(KEY_REQUEST_METHOD => KEY_REQUEST_POST))
  end
end
