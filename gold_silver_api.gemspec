# require File.expand_path('../lib/gold_silver_api/version', __FILE__)
$:.push File.expand_path("../lib", __FILE__)
require "gold_silver_api/version"


Gem::Specification.new do |s|
  s.authors                = ["Andrei Merlescu"]
  s.email                  = ["andrei+github@merlescu.net"]
  s.description            = s.summary = "Simple interface to access GoldApi.io"
  s.homepage               = "https://github.com/amerlescucodez/goldsilver-api"
  s.license                = "MIT"
  s.files                  = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.name                   = "gold_silver_api"
  s.require_paths          = ["lib"]
  s.version                = GoldSilver::VERSION
  s.add_runtime_dependency 'logging', '~> 2.2', '>= 2.2.2'
end