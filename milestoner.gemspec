# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "milestoner"
  spec.version = "14.0.2"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://www.alchemists.io/projects/milestoner"
  spec.summary = "A command line interface for crafting Git semantically versioned repository tags."
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/milestoner/issues",
    "changelog_uri" => "https://www.alchemists.io/projects/milestoner/versions",
    "documentation_uri" => "https://www.alchemists.io/projects/milestoner",
    "funding_uri" => "https://github.com/sponsors/bkuhlmann",
    "label" => "Milestoner",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/milestoner"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.1"
  spec.add_dependency "auto_injector", "~> 0.5"
  spec.add_dependency "cogger", "~> 0.0"
  spec.add_dependency "dry-container", "~> 0.9"
  spec.add_dependency "git_plus", "~> 1.3"
  spec.add_dependency "refinements", "~> 9.4"
  spec.add_dependency "runcom", "~> 8.4"
  spec.add_dependency "spek", "~> 0.3"
  spec.add_dependency "versionaire", "~> 10.3"
  spec.add_dependency "zeitwerk", "~> 2.5"

  spec.bindir = "exe"
  spec.executables << "milestoner"
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
