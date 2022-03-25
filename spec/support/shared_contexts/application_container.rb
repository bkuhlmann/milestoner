# frozen_string_literal: true

require "dry/container/stub"
require "auto_injector/stub"

RSpec.shared_context "with application container" do
  using AutoInjector::Stub

  let(:configuration) { Milestoner::Configuration::Loader.with_defaults.call }
  let(:kernel) { class_spy Kernel }
  let(:logger) { Logger.new io, formatter: ->(_severity, _name, _at, message) { "#{message}\n" } }
  let(:io) { StringIO.new }

  before { Milestoner::Import.stub configuration:, kernel:, logger: }

  after { Milestoner::Import.unstub :configuration, :kernel, :logger }
end
