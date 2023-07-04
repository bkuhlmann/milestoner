# frozen_string_literal: true

require "cogger"
require "dry-container"
require "etcher"
require "gitt"
require "runcom"
require "spek"

module Milestoner
  # Provides a global gem container for injection into other objects.
  module Container
    extend Dry::Container::Mixin

    register :configuration, memoize: true do
      self[:defaults].add_loader Etcher::Loaders::YAML.new(self[:xdg_config].active)
    end

    register :defaults, memoize: true do
      Etcher::Registry.new(contract: Configuration::Contract, model: Configuration::Model)
                      .add_loader(Etcher::Loaders::YAML.new(self[:defaults_path]))
    end

    register :specification, memoize: true do
      self[:spec_loader].call "#{__dir__}/../../milestoner.gemspec"
    end

    register(:spec_loader, memoize: true) { Spek::Loader.new }
    register(:git, memoize: true) { Gitt::Repository.new }
    register(:xdg_config, memoize: true) { Runcom::Config.new "milestoner/configuration.yml" }
    register(:input, memoize: true) { self[:configuration].dup }
    register(:defaults_path, memoize: true) { Pathname(__dir__).join("configuration/defaults.yml") }
    register(:logger, memoize: true) { Cogger.new id: :milestoner }
    register :kernel, Kernel
  end
end
