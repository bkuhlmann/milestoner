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
    context "with web format (default)" do
      before { command.call }

      it "logs start of build" do
        expect(logger.reread).to match(/🟢.+Building milestone.../)
      end

      it "builds web files" do
        expect(web).to have_received(:call)
      end

      it "logs end of build" do
        expect(logger.reread).to match(/🟢.+Milestone built: #{temp_dir}/)
      end
    end

    context "with stream format" do
      before do
        input.build_format = "stream"
        command.call
      end

      it "logs start of build" do
        expect(logger.reread).to match(/🟢.+Building milestone.../)
      end

      it "builds stream" do
        expect(stream).to have_received(:call)
      end
    end

    it "logs error with invalid format" do
      input.build_format = "bogus"
      command.call

      expect(logger.reread).to match(/🛑.+Invalid\sbuild\sformat:\sbogus\./)
    end
  end
end
