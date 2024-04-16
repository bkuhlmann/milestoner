# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Milestoner::Builders::ASCIIDoc do
  include Dry::Monads[:result]

  using Refinements::Pathname

  subject(:builder) { described_class.new enricher: }

  include_context "with application dependencies"
  include_context "with enriched commit"

  let(:enricher) { instance_double Milestoner::Commits::Enricher, call: Success([commit]) }

  describe "#call" do
    let(:content) { temp_dir.join("index.adoc").read }

    it "creates root path when missing" do
      temp_dir.delete
      expect(builder.call.exist?).to be(true)
    end

    it "includes label" do
      builder.call

      expect(content).to match(/= Test Label 1.2.3 \(\d{4}-\d{2}-\d{2}\)/)
                     .or include("= Milestoner")
    end

    it "builds ASCII Doc" do
      builder.call

      expect(content).to include(<<~BODY)
        * 🟢 Added documentation - _Zoe Washburne_

        *1 commit. 2 files. 10 deletions. 5 insertions.*
      BODY
    end

    it "includes generator" do
      builder.call

      expect(content).to include("_Generated by link:https://test.com[Test Generator 3.2.1]._")
                     .or include("_Generated by link:https://alchemists.io/projects/milestoner")
    end

    it "answers build path" do
      expect(builder.call).to eq(temp_dir.join("index.adoc"))
    end
  end
end
