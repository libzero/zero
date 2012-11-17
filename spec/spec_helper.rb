require 'rack'
require 'zero/all'

class SpecController < Zero::Controller
  def process; end
  def render; @response = [200, {'Content-Type' => 'text/html'}, ['foo']]; end
end

class SpecApp
  attr_reader :env

  def self.call(env)
    @env = env
    return [200, {'Content-Type' => 'text/html'}, ['success']]
  end
end

class EnvGenerator
  KEY_REQUEST_METHOD = 'REQUEST_METHOD'
  KEY_REQUEST_GET    = 'GET'
  KEY_REQUEST_HEAD   = 'HEAD'
  KEY_REQUEST_POST   = 'POST'
  KEY_REQUEST_PUT    = 'PUT'
  KEY_REQUEST_DELETE = 'DELETE'

  def self.generate_env(uri, options)
    Rack::MockRequest.env_for(uri, options)
  end

  def self.get(uri, options = {})
    generate_env(uri, options.merge(KEY_REQUEST_METHOD => KEY_REQUEST_GET))
  end

  def self.head(uri, options = {})
    generate_env(uri, options.merge(KEY_REQUEST_METHOD => KEY_REQUEST_HEAD))
  end

  def self.post(uri, options = {})
    generate_env(uri, options.merge(KEY_REQUEST_METHOD => KEY_REQUEST_POST))
  end

  def self.put(uri, options = {})
    generate_env(uri, options.merge(KEY_REQUEST_METHOD => KEY_REQUEST_PUT))
  end

  def self.delete(uri, options = {})
    generate_env(uri, options.merge(KEY_REQUEST_METHOD => KEY_REQUEST_DELETE))
  end
end
