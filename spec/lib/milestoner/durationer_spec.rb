# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Durationer do
  subject(:duration) { described_class }

  describe "call" do
    it "answers seconds" do
      expect(duration.call(2)).to eq("2 seconds")
    end

    it "answers minutes" do
      expect(duration.call(120)).to eq("2 minutes")
    end

    it "answers hours" do
      expect(duration.call(7_200)).to eq("2 hours")
    end

    it "answers days" do
      expect(duration.call(172_800)).to eq("2 days")
    end

    it "answers years" do
      expect(duration.call(63_072_000)).to eq("2 years")
    end

    it "answers years, days, hours, minutes, and seconds" do
      expect(duration.call(31626301)).to eq("1 year, 1 day, 1 hour, 5 minutes, and 1 second")
    end

    it "answers empty string with zero seconds" do
      expect(duration.call(0)).to eq("0 seconds")
    end

    it "answers empty string with negative seconds" do
      expect(duration.call(-1)).to eq("0 seconds")
    end
  end
end
