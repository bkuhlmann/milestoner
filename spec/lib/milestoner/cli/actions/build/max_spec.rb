# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Build::Max do
  subject(:action) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers default maximum" do
      action.call
      expect(settings.build_max).to eq(1)
    end

    it "answers custom maximum" do
      action.call 15
      expect(settings.build_max).to eq(15)
    end
  end
end
