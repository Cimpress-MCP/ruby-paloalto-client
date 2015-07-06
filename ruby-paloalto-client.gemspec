# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'palo_alto/client/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby-paloalto-client"
  spec.version       = PaloAlto::Client::VERSION
  spec.authors       = ["Justin Karimi"]
  spec.email         = ["jekhokie@gmail.com"]
  spec.summary       = %q{Ruby PaloAlto Client (API V6.X)}
  spec.description   = %q{A Ruby-based client library to interact with the PaloAlto APIs.}
  spec.homepage      = ""
  spec.license       = "Apache 2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "crack"
  spec.add_runtime_dependency "nokogiri"
  spec.add_runtime_dependency "rest-client"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "fakeweb"
end
