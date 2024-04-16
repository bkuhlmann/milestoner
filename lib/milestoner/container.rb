# frozen_string_literal: true

require "cogger"
require "containable"
require "etcher"
require "gitt"
require "lode"
require "runcom"
require "sanitize"
require "spek"

module Milestoner
  # Provides a global gem container for injection into other objects.
  module Container
    extend Containable

    namespace :xdg do
      register(:cache) { Runcom::Cache.new "milestoner/database.store" }
      register(:config) { Runcom::Config.new "milestoner/configuration.yml" }
    end

    register :cache do
      # :nocov:
      Lode.new self["xdg.cache"].passive do |config|
        config.mode = :max
        config.table = Lode::Tables::Value
        config.register :users, model: Models::User, primary_key: :name
      end
    end

    register :configuration do
      self[:defaults].add_loader(Etcher::Loaders::YAML.new(self["xdg.config"].active))
                     .then { |registry| Etcher.call registry }
    end

    register :defaults do
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
                      .add_transformer(Configuration::Transformers::Project::Label)
                      .add_transformer(Configuration::Transformers::Project::Name)
                      .add_transformer(Configuration::Transformers::Project::Version.new)
                      .add_transformer(Configuration::Transformers::Generator::Label.new)
                      .add_transformer(Configuration::Transformers::Generator::URI.new)
                      .add_transformer(Configuration::Transformers::Generator::Version.new)
                      .add_transformer(Configuration::Transformers::URI::Avatar)
                      .add_transformer(Configuration::Transformers::URI::Commit)
                      .add_transformer(Configuration::Transformers::URI::Profile)
                      .add_transformer(Configuration::Transformers::URI::Review)
                      .add_transformer(Configuration::Transformers::URI::Tracker)
    end

    register(:specification) { self[:spec_loader].call "#{__dir__}/../../milestoner.gemspec" }
    register(:sanitizer) { -> content { Sanitize.fragment content, Sanitize::Config::BASIC } }
    register(:spec_loader) { Spek::Loader.new }
    register(:git) { Gitt::Repository.new }
    register(:input) { self[:configuration].dup }
    register(:defaults_path) { Pathname(__dir__).join("configuration/defaults.yml") }
    register(:logger) { Cogger.new id: :milestoner }
    register :kernel, Kernel
  end
end
