# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-weheartit/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-weheartit"
  spec.version       = Omniauth::WeHeartIt::VERSION
  spec.authors       = ["Nicolás Hock Isaza"]
  spec.email         = ["nicolas@weheartit.com"]
  spec.description   = %q{OmniAuth strategy for We Heart It's API}
  spec.summary       = %q{OmniAuth strategy for We Heart It's API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14.1"
  spec.add_development_dependency 'rack-test', '~> 0.6.2'
  spec.add_development_dependency 'webmock', '~> 1.13.0'

  spec.add_dependency "omniauth", "~> 1.2.1"
  spec.add_dependency "omniauth-oauth2", "~> 1.1.2"
end
