# frozen_string_literal: true

require "dry/monads"
require "spec_helper"
require "tone/rspec/matchers/have_color"
require "versionaire"

RSpec.describe Milestoner::Builders::Stream do
  include Dry::Monads[:result]

  using Refinements::StringIO
  using Refinements::Struct
  using Versionaire::Cast

  subject(:builder) { described_class.new tagger: }

  include_context "with application dependencies"
  include_context "with enriched tag"

  let(:color) { Tone.new }
  let(:tagger) { instance_double Milestoner::Tags::Enricher, call: Success(tags) }

  describe "#call" do
    context "with single tag" do
      let :proof do
        [
          ["Test 0.1.0 (2024-07-05)\n\nMalcolm Reynolds | 🔒 Tag (secure)\n\n"],
          ["180dec7d8ae8", :yellow],
          [" 🔒 🟢 🟢 Added documentation "],
          ["Zoe Washburne", :bold, :blue],
          [" "],
          ["5 hours ago", :bright_purple],
          [" "],
          ["5 minutes ago", :cyan],
          ["\n\n1 commit. 2 files. "],
          ["10 deletions", :green],
          [". "],
          ["5 insertions", :red],
          [".\n5 hours, 5 minutes, and 5 seconds.\n\nGenerated by Milestoner 3.2.1.\n"]
        ]
      end

      before { tags.pop }

      it "renders content" do
        builder.call
        expect(io.reread).to have_color(color, *proof)
      end

      it "answers content when success" do
        builder.call
        expect(builder.call).to match(Success(String))
      end
    end

    context "with multiple tag" do
      let :proof do
        [
          ["Test 0.1.0 (2024-07-05)\n\nMalcolm Reynolds | 🔒 Tag (secure)\n\n"],
          ["180dec7d8ae8", :yellow],
          [" 🔒 🟢 🟢 Added documentation "],
          ["Zoe Washburne", :bold, :blue],
          [" "],
          ["5 hours ago", :bright_purple],
          [" "],
          ["5 minutes ago", :cyan],
          ["\n\n1 commit. 2 files. "],
          ["10 deletions", :green],
          [". "],
          ["5 insertions", :red],
          [
            ".\n5 hours, 5 minutes, and 5 seconds.\n\n" \
            "Generated by Milestoner 3.2.1.\n\n" \
            "--------------------------------------------------------------------------------\n\n" \
            "Test 0.0.0 (2024-07-04)\n\nMalcolm Reynolds | 🔒 Tag (secure)\n\n"
          ],
          ["180dec7d8ae8", :yellow],
          [" 🔒 🟢 🟢 Added documentation "],
          ["Zoe Washburne", :bold, :blue],
          [" "],
          ["5 hours ago", :bright_purple],
          [" "],
          ["5 minutes ago", :cyan],
          ["\n\n1 commit. 2 files. "],
          ["10 deletions", :green],
          [". "],
          ["5 insertions", :red],
          [".\n5 hours, 5 minutes, and 5 seconds.\n\nGenerated by Milestoner 3.2.1.\n"]
        ]
      end

      it "renders content" do
        builder.call
        expect(io.reread).to have_color(color, *proof)
      end

      it "answers content when success" do
        expect(builder.call).to match(Success(String))
      end
    end

    context "with identical tag" do
      let :proof do
        [
          ["Test 1.2.3 (2024-07-05)\n\n"],
          ["180dec7d8ae8", :yellow],
          [" 🔒 🟢 🟢 Added documentation "],
          ["Zoe Washburne", :bold, :blue],
          [" "],
          ["5 hours ago", :bright_purple],
          [" "],
          ["5 minutes ago", :cyan],
          ["\n\n1 commit. 2 files. "],
          ["10 deletions", :green],
          [". "],
          ["5 insertions", :red],
          [".\n5 hours, 5 minutes, and 5 seconds.\n\nGenerated by Milestoner 3.2.1.\n"]
        ]
      end

      before do
        tags.pop
        tags.first.merge! version: Version("1.2.3")
      end

      it "renders content" do
        builder.call
        expect(io.reread).to have_color(color, *proof)
      end
    end

    context "without commits" do
      let :tags do
        [
          Milestoner::Models::Tag[
            commits: [],
            version: "0.0.0",
            committed_at: Time.local(2024, 7, 1)
          ]
        ]
      end

      it "renders zero totals with no commits" do
        builder.call

        expect(io.reread).to have_color(
          color,
          ["Test (2024-07-01)\n\n0 commits. 0 files. "],
          ["0 deletions", :green],
          [". "],
          ["0 insertions", :red],
          [".\n0 seconds.\n\nGenerated by Milestoner 3.2.1.\n"]
        )
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
