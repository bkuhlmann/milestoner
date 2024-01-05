# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "milestoner"
  spec.version = "16.2.1"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://alchemists.io/projects/milestoner"
  spec.summary = "A command line interface for managing Git repository milestones."
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/milestoner/issues",
    "changelog_uri" => "https://alchemists.io/projects/milestoner/versions",
    "documentation_uri" => "https://alchemists.io/projects/milestoner",
    "funding_uri" => "https://github.com/sponsors/bkuhlmann",
    "label" => "Milestoner",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/milestoner"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.3"
  spec.add_dependency "asciidoctor", "~> 2.0"
  spec.add_dependency "cff", "~> 1.1"
  spec.add_dependency "cogger", "~> 0.15"
  spec.add_dependency "dry-container", "~> 0.11"
  spec.add_dependency "dry-monads", "~> 1.6"
  spec.add_dependency "dry-schema", "~> 1.13"
  spec.add_dependency "etcher", "~> 1.0"
  spec.add_dependency "gitt", "~> 3.0"
  spec.add_dependency "hanami-view", "~> 2.1.0.rc2"
  spec.add_dependency "infusible", "~> 3.0"
  spec.add_dependency "lode", "~> 1.0"
  spec.add_dependency "redcarpet", "~> 3.6"
  spec.add_dependency "refinements", "~> 12.0"
  spec.add_dependency "runcom", "~> 11.0"
  spec.add_dependency "sanitize", "~> 6.1"
  spec.add_dependency "sod", "~> 0.4"
  spec.add_dependency "spek", "~> 3.0"
  spec.add_dependency "versionaire", "~> 13.0"
  spec.add_dependency "zeitwerk", "~> 2.6"

  spec.bindir = "exe"
  spec.executables << "milestoner"
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
