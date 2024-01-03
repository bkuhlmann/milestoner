# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Milestoner::Builders::Web do
  include Dry::Monads[:result]

  using Refinements::Pathname

  subject(:builder) { described_class.new enricher: }

  include_context "with application dependencies"
  include_context "with enriched commit"

  let(:enricher) { instance_double Milestoner::Commits::Enricher, call: Success([commit]) }

  describe "#call" do
    it "builds HTML and CSS" do
      builder.call

      expect(temp_dir.files).to contain_exactly(
        temp_dir.join("index.html"),
        temp_dir.join("page.css")
      )
    end

    it "answers build path" do
      expect(builder.call).to eq(temp_dir)
    end
  end
end
