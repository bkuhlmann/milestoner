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
      action.call
      expect(publisher).to have_received(:call).with(Version("1.2.3"))
    end

    it "call publisher with custom version" do
      action.call "1.1.1"
      expect(publisher).to have_received(:call).with(Version("1.1.1"))
    end
  end
end
