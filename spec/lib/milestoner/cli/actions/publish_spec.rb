# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Publish do
  using Refinements::Struct
  using Versionaire::Cast

  subject(:action) { described_class.new publisher: }

  include_context "with application dependencies"

  let(:publisher) { instance_spy Milestoner::Tags::Publisher, call: Success(version) }
  let(:version) { Version "1.2.3" }

  describe "#call" do
    it "enforces a build maximum of one" do
      settings.build_max = 5
      action.call version

      expect(settings.build_max).to eq(1)
    end

    it "calls publisher with default version" do
      action.call version
      expect(publisher).to have_received(:call).with(version)
    end

    it "answers version when success" do
      expect(action.call(version)).to eq(version)
    end

    it "logs error when failure" do
      allow(publisher).to receive(:call).with(version).and_return(Failure("Danger!"))
      action.call version

      expect(logger.reread).to match(/🛑.+Danger!/)
    end

    it "answers message when error" do
      allow(publisher).to receive(:call).with(version).and_return(Failure("Danger!"))
      expect(action.call(version)).to eq("Danger!")
    end

    it "logs error with invalid version" do
      action.call "bogus"
      expect(logger.reread).to match(/🛑.+Invalid version/)
    end

    it "logs error when unable to publish" do
      allow(publisher).to receive(:call).with(version).and_return("Danger!")
      action.call version

      expect(logger.reread).to match(/🛑.+Publish failed/)
    end

    it "answers message when unable to publish" do
      allow(publisher).to receive(:call).with(version).and_return("Danger!")
      expect(action.call(version)).to match(/\APublish failed/)
    end
  end
end
