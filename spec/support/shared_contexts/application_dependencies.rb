# frozen_string_literal: true

require "lode"
require "versionaire"

# rubocop:todo RSpec/MultipleMemoizedHelpers
RSpec.shared_context "with application dependencies" do
  using Versionaire::Cast

  include_context "with temporary directory"

  let :cache do
    Lode.new temp_dir.join("database.store") do |config|
      config.table = Lode::Tables::Value
      config.register :users, model: Milestoner::Models::User, primary_key: :name
    end
  end

  let :configuration do
    Etcher.new(Milestoner::Container[:defaults])
          .call(
            build_root: temp_dir,
            generator_label: "Test Generator",
            generator_uri: "https://test.com",
            generator_version: "3.2.1",
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

  before do
    Milestoner::Container.stub! configuration:,
                                input:,
                                "xdg.config" => xdg_config,
                                cache:,
                                kernel:,
                                logger:
  end

  after { Milestoner::Container.restore }
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
