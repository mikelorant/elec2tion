# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elec2tion/version'

Gem::Specification.new do |spec|
  spec.name          = "elec2tion"
  spec.version       = Elec2tion::VERSION
  spec.authors       = ["Michael Lorant"]
  spec.email         = ["michael.lorant@fairfaxmedia.com.au"]

  spec.summary       = %q{Determines if aw AWS EC2 instance is elected.}
  spec.description   = %q{Determines if an AWS EC2 instance is elected based on it being the first entry in the security group.}
  spec.homepage      = "http://mikelorant.github.io/elec2tion"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "thor"
  spec.add_runtime_dependency "aws-sdk"
  spec.add_runtime_dependency "httparty"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "gemfury"
  spec.add_development_dependency "rubocop"
end
