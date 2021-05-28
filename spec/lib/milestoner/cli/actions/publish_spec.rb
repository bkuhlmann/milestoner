# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Publish do
  subject(:action) { described_class.new publisher: publisher }

  include_context "with application container"

  let(:publisher) { instance_spy Milestoner::Publisher }

  describe "#call" do
    it "call publisher" do
      action.call application_configuration
      expect(publisher).to have_received(:call).with(application_configuration)
    end
  end
end
