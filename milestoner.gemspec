# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "milestoner/identity"

Gem::Specification.new do |spec|
  spec.name = Milestoner::Identity.name
  spec.version = Milestoner::Identity.version
  spec.platform = Gem::Platform::RUBY
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://github.com/bkuhlmann/milestoner"
  spec.summary = "A command line interface for releasing Git repository milestones."
  spec.license = "MIT"

  if File.exist?(Gem.default_key_path) && File.exist?(Gem.default_cert_path)
    spec.signing_key = Gem.default_key_path
    spec.cert_chain = [Gem.default_cert_path]
  end

  spec.required_ruby_version = "~> 2.4"
  spec.add_dependency "thor", "~> 0.19"
  spec.add_dependency "thor_plus", "~> 5.1"
  spec.add_dependency "runcom", "~> 1.1"
  spec.add_dependency "versionaire", "~> 3.1"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "gemsmith", "~> 10.0"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "pry-byebug", "~> 3.4"
  spec.add_development_dependency "pry-state", "~> 0.1"
  spec.add_development_dependency "bond", "~> 0.5"
  spec.add_development_dependency "wirb", "~> 2.0"
  spec.add_development_dependency "hirb", "~> 0.7"
  spec.add_development_dependency "awesome_print", "~> 1.7"
  spec.add_development_dependency "rspec", "~> 3.6"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "climate_control", "~> 0.1"
  spec.add_development_dependency "git-cop", "~> 1.0"
  spec.add_development_dependency "reek", "~> 4.7"
  spec.add_development_dependency "rubocop", "~> 0.49"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 1.0"

  spec.files = Dir["lib/**/*"]
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.executables << "milestoner"
  spec.require_paths = ["lib"]
end
