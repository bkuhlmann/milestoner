# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Builders::PathResolver do
  using Refinements::Pathname

  subject(:resolver) { described_class }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test.txt" }

    it "logs warning when file exists" do
      path.touch
      resolver.call(path, logger:)

      expect(logger.reread).to match(/⚠️.+Path exists: #{path}\. Skipped\./)
    end

    context "when file doesn't exist" do
      it "ensures path ancestors are created" do
        path = temp_dir.join "one/two/three.txt"
        resolver.call(path, logger:)

        expect(path.parent.exist?).to be(true)
      end

      it "yields path to block" do
        test = nil
        resolver.call(path, logger:) { |value| test = value }

        expect(test).to eq(path)
      end

      it "logs info" do
        resolver.call(path, logger:)
        expect(logger.reread).to match(/🟢.+Created: #{path}\./)
      end

      it "answers path" do
        expect(resolver.call(path, logger:)).to be_success(path)
      end
    end
  end
end
