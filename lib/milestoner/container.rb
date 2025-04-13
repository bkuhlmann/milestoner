# frozen_string_literal: true

require "cogger"
require "containable"
require "etcher"
require "gitt"
require "lode"
require "runcom"
require "spek"
require "tone"

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
        config.mode = :thread
        config.table = Lode::Tables::Value
        config.register :users, model: Models::User, primary_key: :name
      end
    end

    register :registry, as: :fresh do
      Etcher::Registry.new(contract: Configuration::Contract, model: Configuration::Model)
                      .add_loader(:yaml, self[:defaults_path])
                      .add_loader(:yaml, self["xdg.config"].active)
                      .add_transformer(:root, :build_output)
                      .add_transformer(Configuration::Transformers::Build::TemplatePaths.new)
                      .add_transformer(Configuration::Transformers::Gems::Label.new)
                      .add_transformer(Configuration::Transformers::Gems::Description.new)
                      .add_transformer(Configuration::Transformers::Gems::Name.new)
                      .add_transformer(Configuration::Transformers::Gems::URI.new)
                      .add_transformer(Configuration::Transformers::Citations::Label.new)
                      .add_transformer(Configuration::Transformers::Citations::Description.new)
                      .add_transformer(Configuration::Transformers::Citations::URI.new)
                      .add_transformer(Configuration::Transformers::Project::Author.new)
                      .add_transformer(Configuration::Transformers::Project::Label)
                      .add_transformer(:basename, :project_name)
                      .add_transformer(Configuration::Transformers::Project::Version.new)
                      .add_transformer(:format, :project_uri_home)
                      .add_transformer(:format, :project_uri_icon)
                      .add_transformer(:format, :project_uri_logo)
                      .add_transformer(:format, :project_uri_version, id: "%<id>s")
                      .add_transformer(Configuration::Transformers::Generator::Label.new)
                      .add_transformer(Configuration::Transformers::Generator::URI.new)
                      .add_transformer(Configuration::Transformers::Generator::Version.new)
                      .add_transformer(:format, :syndication_entry_label, id: "%<id>s")
                      .add_transformer(:format, :syndication_entry_uri, id: "%<id>s")
                      .add_transformer(:format, :syndication_id, id: "%<id>s")
                      .add_transformer(:format, :syndication_label)
                      .add_transformer(Configuration::Transformers::Syndication::Link)
                      .add_transformer(:format, :commit_uri, id: "%<id>s")
                      .add_transformer(:format, :review_uri, id: "%<id>s")
                      .add_transformer(:format, :tracker_uri, id: "%<id>s")
                      .add_transformer(:time, :loaded_at)
    end

    register(:settings) { Etcher.call(self[:registry]).dup }
    register(:specification) { self[:spec_loader].call "#{__dir__}/../../milestoner.gemspec" }
    register(:sanitizer) { Sanitizer.new }
    register(:spec_loader) { Spek::Loader.new }
    register(:git) { Gitt::Repository.new }
    register(:defaults_path) { Pathname(__dir__).join("configuration/defaults.yml") }
    register(:color) { Tone.new }
    register :durationer, Durationer
    register(:logger) { Cogger.new id: :milestoner }
    register :io, STDOUT
  end
end
