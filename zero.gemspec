# -*- encoding: utf-8 -*-
require File.expand_path('../lib/zero/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'zero'
  s.version = Zero::VERSION.dup

  s.authors  = ['Gibheer']
  s.email    = 'gibheer@gmail.com'
  s.summary  = 'Event distribution and aggregation framework'
  s.homepage = 'http://github.com/gibheer/zero'

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths    = %w(lib)
  s.extra_rdoc_files = %w(README.md)

  s.rubygems_version = '1.8.24'

  s.add_dependency('tilt')

  s.add_development_dependency('thor')
  s.add_development_dependency('rack')
  s.add_development_dependency('rspec')
end
