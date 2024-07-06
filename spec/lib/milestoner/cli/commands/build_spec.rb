# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Milestoner::CLI::Commands::Build do
  include Dry::Monads[:result]

  using Refinements::Pathname

  subject(:command) { described_class.new stream:, web: }

  include_context "with application dependencies"

  let(:stream) { instance_spy Milestoner::Builders::Stream }
  let(:web) { instance_spy Milestoner::Builders::Web, call: temp_dir }

  describe "#call" do
    context "with ASCII Doc format" do
      before do
        settings.build_format = "ascii_doc"
        command.call
      end

      it "logs start of build" do
        expect(logger.reread).to match(/🟢.+Building Test \(ascii_doc\)\.\.\./)
      end

      it "builds ASCII Doc file" do
        expect(temp_dir.join("index.adoc").exist?).to be(true)
      end
    end

    context "with feed format" do
      include_context "with Git repository"

      before do
        settings.build_format = "feed"

        cache.write :users do |table|
          table.create Milestoner::Models::User[external_id: 1, handle: "test", name: "Test User"]
        end

        git_repo_dir.change_dir do
          `git tag 0.0.0`
          `touch a.txt && git add --all && git commit --message "Added A"`

          command.call
        end
      end

      it "logs start of build" do
        expect(logger.reread).to match(/🟢.+Building Test \(feed\)\.\.\./)
      end

      it "builds XML file" do
        expect(temp_dir.join("index.xml").exist?).to be(true)
      end
    end

    context "with Markdown format" do
      before do
        settings.build_format = "markdown"
        command.call
      end

      it "logs start of build" do
        expect(logger.reread).to match(/🟢.+Building Test \(markdown\)\.\.\./)
      end

      it "builds Markdown file" do
        expect(temp_dir.join("index.md").exist?).to be(true)
      end
    end

    context "with stream format (default)" do
      before do
        settings.build_format = "stream"
        command.call
      end

      it "logs start of build" do
        expect(logger.reread).to match(/🟢.+Building Test \(stream\)\.\.\./)
      end

      it "builds stream" do
        expect(stream).to have_received(:call)
      end
    end

    context "with web format" do
      before do
        settings.build_format = "web"
        command.call
      end

      it "logs start of build" do
        expect(logger.reread).to match(/🟢.+Building Test \(web\)\.\.\./)
      end

      it "builds web files" do
        expect(web).to have_received(:call)
      end
    end

    it "aborts with invalid format" do
      logger = instance_spy Cogger::Hub
      settings.build_format = "bogus"
      described_class.new(stream:, logger:).call

      expect(logger).to have_received(:abort).with("Invalid build format: bogus.")
    end
  end
end
