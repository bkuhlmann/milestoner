# frozen_string_literal: true

require "dry/container/stub"
require "infusible/stub"

RSpec.shared_context "with application dependencies" do
  using Infusible::Stub

  let(:configuration) { Milestoner::Configuration::Loader.with_defaults.call }
  let(:kernel) { class_spy Kernel }

  let :logger do
    Cogger::Client.new Logger.new(StringIO.new),
                       formatter: -> _severity, _name, _at, message { "#{message}\n" }
  end

  before { Milestoner::Import.stub configuration:, kernel:, logger: }

  after { Milestoner::Import.unstub :configuration, :kernel, :logger }
end
