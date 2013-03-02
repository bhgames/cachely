# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cachely/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jordan Prince"]
  gem.email         = ["jordanmprince@gmail.com"]
  gem.description   = %q{Add the line cachely :method_name to the top of your class, and the results of the method are transparently cached in a redis key-value store, with optional expiry dates. 
                        This cache is referred to when the method is called with same args every time, instead of the method itself, and only if the key has expired will the method be called again.
                         Designed for methods that block but return the same product every time if the arguments are the same. Time dependendent/random number dependent methods need not apply.}
  gem.summary       = %q{Transparently cache the result of any method, with a signature determined by passed in arguments, any time, anywhere, using a redis store.}
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
