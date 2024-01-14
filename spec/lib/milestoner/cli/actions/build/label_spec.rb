# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Build::Label do
  subject(:action) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers default label" do
      action.call
      expect(input.project_label).to match(/Test Label|Milestoner/)
    end

    it "answers custom label" do
      action.call "test"
      expect(input.project_label).to eq("test")
    end
  end
end
