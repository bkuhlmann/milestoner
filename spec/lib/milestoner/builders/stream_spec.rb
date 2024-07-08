# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Milestoner::Builders::Stream do
  include Dry::Monads[:result]

  using Refinements::Pathname
  using Refinements::StringIO

  subject(:builder) { described_class.new tagger: }

  include_context "with application dependencies"
  include_context "with enriched tag"

  let(:tagger) { instance_double Milestoner::Commits::Tagger, call: Success(tags) }

  describe "#call" do
    let :tagged_pattern do
      /
        \n
        Test\s\d+\.\d+\.\d+\s\(\d{4}-\d{2}-\d{2}\)\n
        \n
        Malcolm\sReynolds\s\|\s🔒\sTag\s\(valid\)\n
        \n
        🟢\sAdded\sdocumentation\s-\sZoe\sWashburne\n
        \n
        \d+\scommit\.\s\d+\sfiles\.\s\d+\sdeletions\.\s\d+\sinsertions\.\n
        \n\n
        Generated\sby\sMilestoner\s3\.2\.1\.\n
      /mx
    end

    let(:multi_tagged_pattern) { /#{tagged_pattern}\n/ }

    context "with single tag" do
      before { tags.pop }

      it "renders content" do
        builder.call
        expect(io.reread).to match(tagged_pattern)
      end

      it "answers content when success" do
        expect(builder.call).to match(Success(tagged_pattern))
      end
    end

    context "with multiple tag" do
      it "renders content" do
        builder.call
        expect(io.reread).to match(multi_tagged_pattern)
      end

      it "answers content when success" do
        expect(builder.call).to match(Success(multi_tagged_pattern))
      end
    end

    context "without commits" do
      let(:tags) { [Milestoner::Models::Tag[commits: [], version: "0.0.0"]] }

      let :pattern do
        /
          Test\s\(\d{4}-\d{2}-\d{2}\)\n
          \n
          \d+\scommits\.\s\d+\sfiles\.\s\d+\sdeletions\.\s\d+\sinsertions\.\n
          \n\n
          Generated\sby\sMilestoner\s3\.2\.1\.
        /mx
      end

      it "renders no commits with zero stats" do
        builder.call
        expect(io.reread).to match(pattern)
      end
    end

    context "with failure" do
      before { allow(tagger).to receive(:call).and_return(Failure("Danger!")) }

      it "logs error" do
        builder.call
        expect(logger.reread).to match(/🛑.+Danger!/)
      end

      it "answers message" do
        expect(builder.call).to eq(Failure("Danger!"))
      end
    end
  end
end
