# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Publish do
  using Refinements::Struct
  using Versionaire::Cast

  subject(:action) { described_class.new publisher: }

  include_context "with application dependencies"

  let(:publisher) { instance_spy Milestoner::Tags::Publisher }

  describe "#call" do
    it "call publisher with default version" do
      default = Milestoner::Commits::Versioner.new.call
      action.call

      expect(publisher).to have_received(:call).with(default)
    end

    it "call publisher with custom version" do
      action.call "1.2.3"
      expect(publisher).to have_received(:call).with(Version("1.2.3"))
    end
  end
end
