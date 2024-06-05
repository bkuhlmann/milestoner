# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Build::Basename do
  subject(:action) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers default path" do
      action.call
      expect(settings.build_basename).to eq("index")
    end

    it "answers custom path" do
      action.call "alternative"
      expect(settings.build_basename).to eq("alternative")
    end
  end
end
