# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Milestoner::Builders::Manifest do
  include Dry::Monads[:result]

  using Refinements::Pathname
  using Refinements::Struct

  subject(:builder) { described_class.new git: }

  include_context "with application dependencies"
  include_context "with enriched tag"

  let(:git) { instance_double Gitt::Repository }

  describe "#call" do
    let(:path) { temp_dir.join "manifest.json" }

    context "when enabled" do
      before do
        settings.build_manifest = true
        allow(git).to receive(:tags).and_return(Success([tag, tag.with(version: "0.0.1")]))
      end

      it "builds manifest" do
        builder.call

        expect(JSON(path.read, {symbolize_names: true})).to eq(
          generator: {
            label: "Milestoner",
            version: "3.2.1"
          },
          latest: "0.0.1",
          versions: %w[0.0.0 0.0.1]
        )
      end

      it "warns when path exists" do
        path.deep_touch
        builder.call

        expect(logger.reread).to match(/⚠️.+Path exists: #{path}\. Skipped\./)
      end

      it "answers path" do
        expect(builder.call).to eq(Success(path))
      end

      it "logs info" do
        builder.call
        expect(logger.reread).to match(/🟢.+Created: #{path}\./)
      end
    end

    context "when enabled with failure" do
      before do
        settings.build_manifest = true
        allow(git).to receive(:tags).and_return(Failure("Danger!"))
      end

      it "logs error" do
        builder.call
        expect(logger.reread).to match(/🛑.+Danger!/)
      end

      it "answers message" do
        expect(builder.call).to eq(Failure("Danger!"))
      end
    end

    context "when disabled" do
      before { settings.build_manifest = false }

      it "doesn't create file" do
        builder.call
        expect(path.exist?).to be(false)
      end

      it "answers path" do
        expect(builder.call).to eq(Success(path))
      end

      it "doesn't log info" do
        builder.call
        expect(logger.reread).to eq("")
      end
    end
  end
end
