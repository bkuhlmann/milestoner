# frozen_string_literal: true

RSpec.shared_examples_for "a parser" do
  describe ".call" do
    it "answers configuration" do
      expect(described_class.call).to be_a(Milestoner::Configuration::Content)
    end
  end
end
