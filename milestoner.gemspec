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
  spec.description = "A command line interface for releasing Git repository milestones."
  spec.license = "MIT"

  if ENV["RUBY_GEM_SECURITY"] == "enabled"
    spec.signing_key = File.expand_path("~/.ssh/gem-private.pem")
    spec.cert_chain = [File.expand_path("~/.ssh/gem-public.pem")]
  end

  spec.add_dependency "thor", "~> 0.19"
  spec.add_dependency "thor_plus", "~> 2.1"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "gemsmith"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-state"
  spec.add_development_dependency "pry-rescue"
  spec.add_development_dependency "pry-stack_explorer"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rb-fsevent" # Guard file events for OSX.
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "terminal-notifier"
  spec.add_development_dependency "terminal-notifier-guard"
  spec.add_development_dependency "climate_control"
  spec.add_development_dependency "greenletters"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "codeclimate-test-reporter"

  spec.files = Dir["lib/**/*"]
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.executables << "milestoner"
  spec.require_paths = ["lib"]
end
