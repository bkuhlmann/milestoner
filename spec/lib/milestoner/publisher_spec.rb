# frozen_string_literal: true

require "spec_helper"
require "versionaire"

RSpec.describe Milestoner::Publisher do
  using Versionaire::Cast

  subject(:publisher) { described_class.new tagger: tagger, pusher: pusher }

  include_context "with default configuration"

  let(:tagger) { instance_spy Milestoner::Tagger }
  let(:pusher) { instance_spy Milestoner::Pusher }
  let(:configuration) { Milestoner::CLI::Configuration::Content[git_tag_version: Version("0.0.0")] }

  describe "#call" do
    it "creates tag" do
      publisher.call configuration
      expect(tagger).to have_received(:call).with(configuration)
    end

    it "pushes tags" do
      publisher.call configuration
      expect(pusher).to have_received(:call).with(configuration)
    end

    it "logs successful publish" do
      result = proc { publisher.call configuration }
      expect(&result).to output("Published: 0.0.0!\n").to_stdout
    end

    it "answers true with successful publish" do
      expect(publisher.call(configuration)).to eq(true)
    end
  end
end
