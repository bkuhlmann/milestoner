# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::Build::Root do
  include Dry::Monads[:result]

  subject(:transformer) { described_class }

  describe "#call" do
    it "answers expanded build root path" do
      expect(transformer.call({build_root: "a/test"})).to eq(
        Success(build_root: Pathname.pwd.join("a/test"))
      )
    end

    it "answers empty hash when key is missing" do
      expect(transformer.call({})).to eq(Success({}))
    end
  end
end
