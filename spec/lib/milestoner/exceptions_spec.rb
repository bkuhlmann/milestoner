require "spec_helper"

describe Milestoner::GitError do
  subject { described_class.new }

  describe "#message" do
    it "answers default message" do
      expect(subject.message).to eq("Invalid Git repository.")
    end
  end
end
