# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::CLI::Actions::Next do
  using Refinements::StringIO

  subject(:action) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers next version" do
      action.call
      expect(io.reread).to eq("1.2.3\n")
    end
  end
end
