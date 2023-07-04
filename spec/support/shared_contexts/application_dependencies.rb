# frozen_string_literal: true

require "dry/container/stub"
require "infusible/stub"

RSpec.shared_context "with application dependencies" do
  using Infusible::Stub

  include_context "with temporary directory"

  let(:configuration) { Etcher.new(Milestoner::Container[:defaults]).call.bind(&:dup) }
  let(:input) { configuration.dup }
  let(:xdg_config) { Runcom::Config.new Milestoner::Container[:defaults_path] }
  let(:kernel) { class_spy Kernel }
  let(:logger) { Cogger.new id: :milestoner, io: StringIO.new, level: :debug }

  before { Milestoner::Import.stub configuration:, input:, xdg_config:, kernel:, logger: }

  after { Milestoner::Import.unstub :configuration, :input, :xdg_config, :kernel, :logger }
end
