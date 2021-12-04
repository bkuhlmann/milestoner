# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Publish do
  subject(:action) { described_class.new publisher: }

  include_context "with application container"

  let(:publisher) { instance_spy Milestoner::Tags::Publisher }

  describe "#call" do
    it "call publisher" do
      action.call configuration
      expect(publisher).to have_received(:call).with(configuration)
    end
  end
end
