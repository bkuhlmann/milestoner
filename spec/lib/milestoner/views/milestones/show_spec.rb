# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Views::Milestones::Show do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:view) { described_class.new }

  include_context "with application dependencies"
  include_context "with enriched tag"

  describe "#call" do
    it "includes label" do
      expect(view.call(tag:).to_s).to include("Test")
    end

    it "includes version" do
      expect(view.call(tag:).to_s).to match(/\d+\.\d+\.\d+/)
    end

    it "includes URI" do
      expect(view.call(tag:).to_s).to include("/projects/milestoner")
    end

    it "includes commit" do
      expect(view.call(tag:).to_s).to include("Added documentation")
    end
  end
end
