require "spec_helper"

describe Milestoner::Errors::Git do
  subject { described_class.new }

  it_behaves_like "a base error"

  describe "#message" do
    it "answers default message" do
      expect(subject.message).to eq("Invalid Git repository.")
    end
  end
end
