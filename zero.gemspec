# -*- encoding: utf-8 -*-
require File.expand_path('../lib/zero/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'zero'
  s.version = Zero::VERSION.dup

  s.authors  = ['Gibheer', 'Stormwind']
  s.email    = 'gibheer@gmail.com'
  s.license  = '3-clause BSD'
  s.summary  = 'a toolkit for building web services'
  s.description = 'The focus of this project is to provide small helpers for building web services without the need of learning a complete new web stack from the bottom to the top.'
  s.homepage = 'http://github.com/libzero/zero'

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths    = %w(lib)
  s.extra_rdoc_files = %w(README.md)

  s.rubygems_version = '1.8.24'

  s.add_dependency('tilt')
  s.add_dependency('zero-fix18') if RUBY_VERSION <= '1.9' 
end
