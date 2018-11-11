# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Errors::Git do
  subject(:error) { described_class.new }

  it_behaves_like "a base error" do
    let(:error) { described_class.new }
  end

  describe "#message" do
    it "answers default message" do
      expect(error.message).to eq("Invalid Git repository.")
    end
  end
end
