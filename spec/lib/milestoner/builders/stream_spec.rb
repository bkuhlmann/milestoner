# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Milestoner::Builders::Stream do
  include Dry::Monads[:result]

  using Refinements::Pathname
  using Refinements::StringIO

  subject(:builder) { described_class.new enricher: }

  include_context "with application dependencies"
  include_context "with enriched commit"

  let(:enricher) { instance_double Milestoner::Commits::Enricher, call: Success([commit]) }

  describe "#call" do
    let :pattern do
      /
        Test\s\d+\.\d+\.\d+\s\(\d{4}-\d{2}-\d{2}\)\n
        \n
        🟢\sAdded\sdocumentation\s-\sZoe\sWashburne\n
        \n
        \d+\scommit\.\s\d+\sfiles\.\s\d+\sdeletions\.\s\d+\sinsertions\.\n
        \n
        Generated\sby\sMilestoner\s3\.2\.1\.
      /mx
    end

    it "renders project label, version, date, commits, stats, and generator information" do
      builder.call
      expect(io.reread).to match(pattern)
    end

    context "without commits" do
      let :pattern do
        /
          Test\s\(\d{4}-\d{2}-\d{2}\)\n
          \n
          \d+\scommits\.\s\d+\sfiles\.\s\d+\sdeletions\.\s\d+\sinsertions\.\n
          \n
          Generated\sby\sMilestoner\s3\.2\.1\.
        /mx
      end

      let(:enricher) { instance_double Milestoner::Commits::Enricher, call: Success([]) }

      it "renders no commits and zero stats" do
        builder.call
        expect(io.reread).to match(pattern)
      end
    end

    it "answers kernel" do
      expect(builder.call).to be_a(Kernel)
    end
  end
end
