# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "demo"
  spec.version = "0.0.0"
  spec.authors = ["Test Author"]
  spec.email = ["demo@test.com"]
  spec.homepage = "https://test.com/projects/demo"
  spec.summary = "A demo specification."
  spec.license = "Hippocratic-2.1"

  spec.metadata = {"label" => "Demo", "rubygems_mfa_required" => "true"}

  spec.required_ruby_version = "~> 3.3"

  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
