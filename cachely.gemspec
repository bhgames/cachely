# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cachely/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jordan Prince"]
  gem.email         = ["jordanmprince@gmail.com"]
  gem.description   = %q{Transparently cache the results of methods using redis.}
  gem.summary       = %q{Transparently cache the results of methods using redis.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "cachely"
  gem.require_paths = ["lib"]
  gem.version       = Cachely::VERSION
  gem.add_dependency "redis", '~> 3.0.1'
  gem.add_dependency "hiredis", '~> 0.4.5'
  gem.add_dependency "em-synchrony"
  gem.add_dependency "json"
end
