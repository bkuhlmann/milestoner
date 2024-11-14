# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Milestoner::Builders::Feed do
  include Dry::Monads[:result]

  using Refinements::Pathname

  subject(:builder) { described_class.new tagger: }

  include_context "with application dependencies"
  include_context "with enriched tag"

  describe "#call" do
    let(:tagger) { instance_double Milestoner::Commits::Tagger, call: Success([tag]) }
    let(:path) { temp_dir.join "index.xml" }

    it "builds index and single version" do
      builder.call
      expect(temp_dir.files("**/*")).to contain_exactly(path)
    end

    it "answers path when success" do
      expect(builder.call).to eq(Success(path))
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
