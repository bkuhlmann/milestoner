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
      self[:defaults].add_loader(Etcher::Loaders::YAML.new(self[:xdg_config].active))
                     .then { |registry| Etcher.call registry }
    end

    register :defaults, memoize: true do
      Etcher::Registry.new(contract: Configuration::Contract, model: Configuration::Model)
                      .add_loader(Etcher::Loaders::YAML.new(self[:defaults_path]))
                      .add_transformer(Configuration::Transformers::Build::Root)
                      .add_transformer(Configuration::Transformers::Build::TemplatePaths.new)
                      .add_transformer(Configuration::Transformers::Gems::Label.new)
                      .add_transformer(Configuration::Transformers::Gems::Description.new)
                      .add_transformer(Configuration::Transformers::Gems::Name.new)
                      .add_transformer(Configuration::Transformers::Gems::URI.new)
                      .add_transformer(Configuration::Transformers::Citations::Label.new)
                      .add_transformer(Configuration::Transformers::Citations::Description.new)
                      .add_transformer(Configuration::Transformers::Project::Author.new)
                      .add_transformer(Configuration::Transformers::Project::Generator.new)
                      .add_transformer(Configuration::Transformers::Project::Label)
                      .add_transformer(Configuration::Transformers::Project::Name)
                      .add_transformer(Configuration::Transformers::Project::Version.new)
                      .add_transformer(Configuration::Transformers::URI::Avatar)
                      .add_transformer(Configuration::Transformers::URI::Commit)
                      .add_transformer(Configuration::Transformers::URI::Profile)
                      .add_transformer(Configuration::Transformers::URI::Review)
                      .add_transformer(Configuration::Transformers::URI::Tracker)
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
