require "spec_helper"

RSpec.describe Milestoner::Errors::Base do
  subject { described_class.new }

  describe "#message" do
    it "answers default message" do
      expect(subject.message).to eq("Invalid Milestoner action.")
    end
  end
end
