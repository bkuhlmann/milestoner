# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Tags::Manifest do
  include Dry::Monads[:result]

  using Refinements::Pathname
  using Refinements::Struct

  subject(:manifest) { described_class.new git: }

  include_context "with application dependencies"
  include_context "with enriched tag"

  let(:path) { temp_dir.join "manifest.json" }
  let(:git) { instance_double Gitt::Repository }

  let :content do
    {
      generator: {
        label: settings.generator_label,
        version: settings.generator_version.to_s
      },
      latest: "0.0.1",
      versions: %w[0.0.0 0.0.1]
    }
  end

  describe "#build_path" do
    it "answers path" do
      expect(manifest.build_path).to eq(path)
    end
  end

  describe "#diff" do
    it "answers empty hash when equal" do
      settings.build_manifest = true
      allow(git).to receive(:tags).and_return(Success([tag, tag.with(version: "0.0.1")]))
      manifest.write(**content)

      expect(manifest.diff).to eq({})
    end

    it "answers empty hash with no tags" do
      settings.build_manifest = true
      allow(git).to receive(:tags).and_return(Failure("Danger!"))
      manifest.write(**content)

      expect(manifest.diff).to eq({})
    end

    it "answers diff when not equal" do
      settings.build_manifest = true

      allow(git).to receive(:tags).and_return(
        Success([tag, tag.with(version: "0.0.1"), tag.with(version: "0.0.2")])
      )

      manifest.write(**content)

      expect(manifest.diff).to eq(
        latest: %w[0.0.2 0.0.1],
        versions: [%w[0.0.0 0.0.1 0.0.2], %w[0.0.0 0.0.1]]
      )
    end
  end

  describe "#read" do
    it "reads content" do
      path.make_ancestors.write content.to_json

      expect(manifest.read).to eq(
        generator: {
          label: "Milestoner",
          version: "3.2.1"
        },
        latest: "0.0.1",
        versions: %w[0.0.0 0.0.1]
      )
    end

    it "fails when file doesn't exist" do
      expectation = proc { manifest.read }
      expect(&expectation).to raise_error(Errno::ENOENT, /no such file/i)
    end
  end

  describe "#write" do
    it "writes content to file" do
      manifest.write(**content)
      expect(manifest.read).to eq(content)
    end

    it "writes to file with custom generator" do
      content = {
        generator: {label: "Test", version: "0.0.0"},
        latest: "0.0.0",
        versions: %w[0.0.0]
      }

      manifest.write(**content)
      expect(manifest.read).to eq(content)
    end

    it "answers path" do
      expect(manifest.write(**content)).to eq(path)
    end

    it "uses pretty format" do
      manifest.write(**content)

      expect(path.read).to eq(<<~CONTENT.strip)
        {
          "generator": {
            "label": "Milestoner",
            "version": "3.2.1"
          },
          "latest": "0.0.1",
          "versions": [
            "0.0.0",
            "0.0.1"
          ]
        }
      CONTENT
    end
  end
end
