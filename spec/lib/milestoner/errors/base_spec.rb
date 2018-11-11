# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Errors::Base do
  subject(:error) { described_class.new }

  describe "#message" do
    it "answers default message" do
      expect(error.message).to eq("Invalid Milestoner action.")
    end
  end
end
