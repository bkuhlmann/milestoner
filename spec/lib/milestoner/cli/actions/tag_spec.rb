# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Tag do
  subject(:action) { described_class.new tagger: tagger }

  include_context "with default configuration"

  let(:tagger) { instance_spy Milestoner::Tagger }

  describe "#call" do
    it "calls tagger" do
      action.call default_configuration
      expect(tagger).to have_received(:call).with(default_configuration)
    end
  end
end
