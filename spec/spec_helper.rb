require 'bundler/setup'
require 'rspec/its'

if ENV['SIMPLECOV']
  require 'simplecov'
  SimpleCov.start do
    add_filter '_spec.rb'
    add_filter 'spec_helper.rb'
  end
end

require 'rack'
require 'erb'
require 'tilt'
require 'zero'

class SpecTemplateContext
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

def create_controller
  Class.new(Zero::Controller) do
    def process
      @response.body = 'correct'
    end
  end
end

class SpecApp
  attr_reader :env

  def self.call(env)
    @env = env
    return [200, {'Content-Type' => 'text/html'}, ['success']]
  end
end

def environment(uri = '/foo', options = {})
  http_options = options
  if options.has_key?(:method)
    http_options['REQUEST_METHOD'] = options[:method].to_s.capitalize
  end
  if options.has_key?(:payload)
    http_options[:input] = options[:payload].
      map {|key, value| "#{key}=#{value}"}.
      join('&')
    http_options['CONTENT_TYPE'] = 'multipart/form-data'
    http_options['REQUEST_METHOD'] = 'POST' unless http_options['REQUEST_METHOD']
  end
  http_options['zero.params.custom'] = options[:custom] if options.has_key?(:custom)
  http_options.inspect

  Rack::MockRequest.env_for(uri, http_options)
end

class EnvGenerator
  KEY_REQUEST_METHOD = 'REQUEST_METHOD'
  KEY_REQUEST_GET    = 'GET'
  KEY_REQUEST_HEAD   = 'HEAD'
  KEY_REQUEST_POST   = 'POST'
  KEY_REQUEST_PUT    = 'PUT'
  KEY_REQUEST_DELETE = 'DELETE'
  KEY_REQUEST_PATCH  = 'PATCH'

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

  def self.patch(uri, options = {})
    generate_env(uri, options.merge(KEY_REQUEST_METHOD => KEY_REQUEST_PATCH))
  end
end
