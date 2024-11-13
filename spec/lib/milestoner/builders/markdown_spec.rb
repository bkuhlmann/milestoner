# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Milestoner::Builders::Markdown do
  include Dry::Monads[:result]

  using Refinements::Pathname

  subject(:builder) { described_class.new tagger: }

  include_context "with application dependencies"
  include_context "with enriched tag"

  describe "#call" do
    context "with single tag" do
      let(:tagger) { instance_double Milestoner::Commits::Tagger, call: Success([tag]) }

      it "builds index and single version" do
        builder.call

        expect(temp_dir.files("**/*")).to contain_exactly(
          temp_dir.join("index.md"),
          temp_dir.join("0.0.0/index.md")
        )
      end

      it "answers path when success" do
        expect(builder.call).to eq(Success(temp_dir))
      end
    end

    context "with multiple tags" do
      let(:tagger) { instance_double Milestoner::Commits::Tagger, call: Success(tags) }

      it "builds index and multiple versions" do
        builder.call

        expect(temp_dir.files("**/*")).to contain_exactly(
          temp_dir.join("index.md"),
          temp_dir.join("0.0.0/index.md"),
          temp_dir.join("0.1.0/index.md")
        )
      end

      it "answers path when success" do
        expect(builder.call).to eq(Success(temp_dir))
      end
    end

    context "with failure" do
      let(:tagger) { instance_double Milestoner::Commits::Tagger }

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
