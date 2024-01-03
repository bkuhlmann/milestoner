# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Milestoner::Builders::Stream do
  include Dry::Monads[:result]

  using Refinements::Pathname

  subject(:builder) { described_class.new enricher: }

  include_context "with application dependencies"
  include_context "with enriched commit"

  let(:enricher) { instance_double Milestoner::Commits::Enricher, call: Success([commit]) }

  describe "#call" do
    let :pattern do
      /
        \d+\.\d+\.\d+\s\(\d{4}-\d{2}-\d{2}\)\n
        \n
        🟢\sAdded\sdocumentation\s-\sZoe\sWashburne\n
        \n
        \d+\scommit\.\s\d+\sfiles\.\s\d+\sdeletions\.\s\d+\sinsertions\.
      /mx
    end

    it "writes to standard output" do
      builder.call
      expect(kernel).to have_received(:puts).with(pattern)
    end

    it "answers kernel" do
      expect(builder.call).to be_a(Kernel)
    end
  end
end
