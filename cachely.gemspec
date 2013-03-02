# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cachely/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jordan Prince"]
  gem.email         = ["jordanmprince@gmail.com"]
  gem.description   = %q{Coming soon.}
  gem.summary       = %q{Use em-redis to transparently cache results from your class methods. Eventmachine compatible out of the box!}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "cachely"
  gem.require_paths = ["lib"]
  gem.version       = Cachely::VERSION
  gem.add_dependency "em-hiredis"
end
