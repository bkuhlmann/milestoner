# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Push do
  subject(:action) { described_class.new pusher: pusher }

  let(:pusher) { instance_spy Milestoner::Tags::Pusher }
  let(:configuration) { Milestoner::CLI::Configuration::Content.new }

  describe "#call" do
    it "pushes tag" do
      action.call configuration
      expect(pusher).to have_received(:call).with(configuration)
    end

    it "logs successful push" do
      result = proc { action.call configuration }
      expect(&result).to output("Tags pushed to remote repository.\n").to_stdout
    end

    it "fails when unable to push" do
      allow(pusher).to receive(:call).and_raise(Milestoner::Error, "Danger!")
      expectation = proc { action.call configuration }

      expect(&expectation).to raise_error(Milestoner::Error, "Danger!")
    end
  end
end
