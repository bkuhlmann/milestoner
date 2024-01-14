# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::Project::Generator do
  include Dry::Monads[:result]

  using Refinements::Pathname

  subject(:transformer) { described_class.new }

  describe "#call" do
    it "answers generator when key exists" do
      expect(transformer.call({project_generator: "Test 0.0.0"})).to eq(
        Success(project_generator: "Test 0.0.0")
      )
    end

    it "answers default generator key is missing" do
      expect(transformer.call({}).success[:project_generator]).to match(/Milestoner \d+\.\d+\.\d+/)
    end

    it "prints deprectation warning" do
      expectation = proc { transformer.call project_generator: "Test 0.0.0" }

      expect(&expectation).to output(<<~CONTENT).to_stderr
        `Milestoner::Configuration::Transformers::Project::Generator#call` is deprecated, use `Milestoner::Configuration::Transformers::Generator::Label` or `Milestoner::Configuration::Transformers::Generator::URI` instead.
      CONTENT
    end
  end
end
