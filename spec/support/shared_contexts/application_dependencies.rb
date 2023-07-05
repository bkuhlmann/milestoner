# frozen_string_literal: true

require "dry/container/stub"
require "infusible/stub"
require "versionaire"

RSpec.shared_context "with application dependencies" do
  using Infusible::Stub
  using Versionaire::Cast

  include_context "with temporary directory"

  let :configuration do
    Etcher.new(Milestoner::Container[:defaults])
          .call(
            build_root: temp_dir,
            project_author: "Test Author",
            project_description: "Test description.",
            project_generator: "Test Generator",
            project_label: "Test Label",
            project_name: "test",
            project_owner: "acme",
            project_version: Version("1.2.3")
          ).bind(&:dup)
  end

  let(:input) { configuration.dup }
  let(:xdg_config) { Runcom::Config.new Milestoner::Container[:defaults_path] }
  let(:kernel) { class_spy Kernel }
  let(:logger) { Cogger.new id: :milestoner, io: StringIO.new, level: :debug }

  before { Milestoner::Import.stub configuration:, input:, xdg_config:, kernel:, logger: }

  after { Milestoner::Import.unstub :configuration, :input, :xdg_config, :kernel, :logger }
end
