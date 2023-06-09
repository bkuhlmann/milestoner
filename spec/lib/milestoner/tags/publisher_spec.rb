# frozen_string_literal: true

require "spec_helper"
require "versionaire"

RSpec.describe Milestoner::Tags::Publisher do
  using Versionaire::Cast

  subject(:publisher) { described_class.new creator:, pusher: }

  include_context "with application dependencies"

  let(:creator) { instance_spy Milestoner::Tags::Creator }
  let(:pusher) { instance_spy Milestoner::Tags::Pusher }
  let(:configuration) { Milestoner::Configuration::Model[version: Version("0.0.0")] }

  describe "#call" do
    it "creates tag" do
      publisher.call configuration
      expect(creator).to have_received(:call).with(configuration)
    end

    it "pushes tags" do
      publisher.call configuration
      expect(pusher).to have_received(:call).with(configuration)
    end

    it "logs successful publish" do
      publisher.call configuration
      expect(logger.reread).to match(/🟢.+Published: 0.0.0!/)
    end

    it "answers true with successful publish" do
      expect(publisher.call(configuration)).to be(true)
    end
  end
end
