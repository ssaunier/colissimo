# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'colissimo/version'

Gem::Specification.new do |spec|
  spec.name          = "colissimo"
  spec.version       = Colissimo::VERSION
  spec.authors       = ["Sebastien Saunier"]
  spec.email         = ["seb@saunier.me"]
  spec.summary       = %q{Retrieve tracking information from french Colissimo parcel delivery}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/ssaunier/colissimo"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "httpclient", "~> 2.2"
  spec.add_dependency "nokogiri", "~> 1.5"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 10.1"
  spec.add_development_dependency "minitest", "~> 5.2"
  spec.add_development_dependency "sinatra", "~> 1.4"
end
