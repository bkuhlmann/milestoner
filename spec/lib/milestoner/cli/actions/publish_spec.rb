# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Publish do
  subject(:action) { described_class.new publisher: publisher }

  include_context "with default configuration"

  let(:publisher) { instance_spy Milestoner::Publisher }

  describe "#call" do
    it "call publisher" do
      action.call default_configuration
      expect(publisher).to have_received(:call).with(default_configuration)
    end
  end
end
