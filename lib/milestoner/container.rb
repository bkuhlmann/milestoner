# frozen_string_literal: true

require "cogger"
require "dry/container"
require "git_plus"
require "spek"

module Milestoner
  # Provides a global gem container for injection into other objects.
  module Container
    extend Dry::Container::Mixin

    register(:configuration) { Configuration::Loader.call }
    register(:specification) { Spek::Loader.call "#{__dir__}/../../milestoner.gemspec" }
    register(:repository) { GitPlus::Repository.new }
    register(:kernel) { Kernel }
    register(:logger) { Cogger::Client.new }
  end
end
