require File.expand_path('../lib/zero.rb', __FILE__)
require 'json'

class Foo
  def call(env)
    req = Rack::Request.new(env)
    [200, {'Content-Type' => 'text/html'}, ["this works #{req.params.inspect}"]]
  end
end

routes = Zero::Router.new(
  '/foo/:id' => Foo.new,
  '/' => Foo.new
)

run routes
