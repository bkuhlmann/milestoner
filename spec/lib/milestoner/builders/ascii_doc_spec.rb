# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Builders::ASCIIDoc do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:builder) { described_class.new tagger: }

  include_context "with application dependencies"
  include_context "with enriched tag"

  describe "#call" do
    context "with single tag" do
      let(:tagger) { instance_double Milestoner::Tags::Enricher, call: Success([tag]) }

      it "builds index and single version" do
        builder.call

        expect(temp_dir.files("**/*")).to contain_exactly(
          temp_dir.join("index.adoc"),
          temp_dir.join("0.0.0/index.adoc")
        )
      end

      it "answers path when success" do
        expect(builder.call).to be_success(temp_dir)
      end
    end

    context "with multiple tags" do
      let(:tagger) { instance_double Milestoner::Tags::Enricher, call: Success(tags) }

      it "builds index and multiple versions" do
        builder.call

        expect(temp_dir.files("**/*")).to contain_exactly(
          temp_dir.join("index.adoc"),
          temp_dir.join("0.0.0/index.adoc"),
          temp_dir.join("0.1.0/index.adoc")
        )
      end

      it "answers path when success" do
        expect(builder.call).to be_success(temp_dir)
      end
    end

    context "with failure" do
      let(:tagger) { instance_double Milestoner::Tags::Enricher }

      before { allow(tagger).to receive(:call).and_return(Failure("Danger!")) }

      it "logs error" do
        builder.call
        expect(logger.reread).to match(/🛑.+Danger!/)
      end

      it "answers message" do
        expect(builder.call).to be_failure("Danger!")
      end
    end
  end
end
