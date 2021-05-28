# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Tag do
  subject(:action) { described_class.new tagger: tagger }

  include_context "with application container"

  let(:tagger) { instance_spy Milestoner::Tagger }

  describe "#call" do
    it "calls tagger" do
      action.call application_configuration
      expect(tagger).to have_received(:call).with(application_configuration)
    end
  end
end
