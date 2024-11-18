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

    it "answers years in days" do
      expect(duration.call(63072000)).to eq("730 days")
    end

    it "answers days, hours, minutes, and seconds" do
      expect(duration.call(90_325)).to eq("1 day, 1 hour, 5 minutes, and 25 seconds")
    end

    it "answers empty string with zero seconds" do
      expect(duration.call(0)).to eq("")
    end

    it "answers empty string with negative seconds" do
      expect(duration.call(-1)).to eq("")
    end
  end
end
