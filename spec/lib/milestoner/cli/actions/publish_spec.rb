# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Publish do
  using Refinements::Struct

  subject(:action) { described_class.new publisher: }

  include_context "with application dependencies"

  let(:publisher) { instance_spy Milestoner::Tags::Publisher }

  describe "#call" do
    it "call publisher" do
      action.call "0.0.0"
      expect(publisher).to have_received(:call).with(configuration.merge(version: "0.0.0"))
    end
  end
end
