# frozen_string_literal: true

require_relative "lib/milestoner/identity"

Gem::Specification.new do |spec|
  spec.name = Milestoner::Identity::NAME
  spec.version = Milestoner::Identity::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://www.alchemists.io/projects/milestoner"
  spec.summary = "A command line interface for crafting Git repository milestones."
  spec.license = "Apache-2.0"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/milestoner/issues",
    "changelog_uri" => "https://www.alchemists.io/projects/milestoner/changes.html",
    "documentation_uri" => "https://www.alchemists.io/projects/milestoner",
    "source_code_uri" => "https://github.com/bkuhlmann/milestoner"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 2.7"
  spec.add_dependency "git_plus", "~> 0.1"
  spec.add_dependency "refinements", "~> 7.18"
  spec.add_dependency "runcom", "~> 6.4"
  spec.add_dependency "thor", "~> 0.20"
  spec.add_dependency "versionaire", "~> 8.4"
  spec.add_development_dependency "bundler-audit", "~> 0.7"
  spec.add_development_dependency "bundler-leak", "~> 0.2"
  spec.add_development_dependency "climate_control", "~> 0.1"
  spec.add_development_dependency "gemsmith", "~> 14.8"
  spec.add_development_dependency "git-lint", "~> 1.3"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "pry", "~> 0.13"
  spec.add_development_dependency "pry-byebug", "~> 3.9"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "reek", "~> 6.0"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "rubocop", "~> 1.3"
  spec.add_development_dependency "rubocop-performance", "~> 1.8"
  spec.add_development_dependency "rubocop-rake", "~> 0.5"
  spec.add_development_dependency "rubocop-rspec", "~> 2.0"
  spec.add_development_dependency "simplecov", "~> 0.19"

  spec.files = Dir["lib/**/*"]
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.executables << "milestoner"
  spec.require_paths = ["lib"]
end
