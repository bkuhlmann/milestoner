# frozen_string_literal: true

require "lode"

RSpec.shared_context "with application dependencies" do
  using Refinements::Struct

  include_context "with temporary directory"

  let :cache do
    Lode.new temp_dir.join("database.store") do |config|
      config.table = Lode::Tables::Value
      config.register :users, model: Milestoner::Models::User, primary_key: :name
    end
  end

  let(:settings) { Milestoner::Container[:settings] }
  let(:logger) { Cogger.new id: :milestoner, io: StringIO.new, level: :debug }
  let(:io) { StringIO.new }

  before do
    settings.merge! Etcher.call(
      Milestoner::Container[:registry].remove_loader(1)
                                      .add_loader(
                                        :hash,
                                        project_name: "test",
                                        project_version: "1.2.3"
                                      ),
      build_output: temp_dir,
      generator_version: "3.2.1",
      loaded_at: Time.utc(2020, 1, 2, 3, 4, 5),
      project_author: "Tester",
      project_description: "A test.",
      project_label: "Test"
    )

    Milestoner::Container.stub! cache:, logger:, io:
  end

  after { Milestoner::Container.restore }
end
