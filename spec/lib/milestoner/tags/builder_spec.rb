# frozen_string_literal: true

require "spec_helper"
require "versionaire"

RSpec.describe Milestoner::Tags::Builder do
  subject(:builder) { described_class.new enricher: }

  include_context "with application dependencies"
  include_context "with enriched tag"

  let(:enricher) { instance_double Milestoner::Tags::Enricher, call: Success([tag]) }

  describe "#call" do
    let(:version) { "1.2.3" }

    let :proof do
      <<~CONTENT
        Generated by Milestoner 3.2.1.

        Commits: 1
        Deletions: 10
        Duration: 18305
        Files: 2
        Insertions: 5
        URI: https://undefined.io/projects/test/versions/1.2.3

      CONTENT
    end

    it "renders content" do
      expect(builder.call(version)).to be_success(proof)
    end

    context "without commits" do
      let(:tag) { Milestoner::Models::Tag[commits: [], committed_at: Time.local(2024, 7, 1)] }

      it "renders no commits with zero stats" do
        expect(builder.call(version)).to eq(
          Success(<<~CONTENT)
            Generated by Milestoner 3.2.1.

            Commits: 0
            Deletions: 0
            Duration: 0
            Files: 0
            Insertions: 0
            URI: https://undefined.io/projects/test/versions/1.2.3

          CONTENT
        )
      end
    end

    context "with failure" do
      before { allow(enricher).to receive(:call).and_return(Failure("Danger!")) }

      it "logs error" do
        builder.call version
        expect(logger.reread).to match(/🛑.+Danger!/)
      end

      it "answers message" do
        expect(builder.call(version)).to be_failure("Danger!")
      end
    end
  end
end
