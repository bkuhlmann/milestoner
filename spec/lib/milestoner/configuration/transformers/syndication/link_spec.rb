# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Configuration::Transformers::Syndication::Link do
  include Dry::Monads[:result]

  using Refinements::Hash

  subject(:transformer) { described_class }

  describe "#call" do
    let :attributes do
      {
        project_label: "Test",
        project_uri: "https://acme.io/test",
        syndication_links: [
          {label: "%<project_label>s Versions (web)", uri: "%<project_uri>s/versions"},
          {label: "%<project_label>s Versions (feed)", uri: "%<project_uri>s/versions.xml"}
        ]
      }
    end

    it "answers formatted labels and URIs when all keys exist" do
      expect(transformer.call(attributes)).to eq(
        Success(
          project_label: "Test",
          project_uri: "https://acme.io/test",
          syndication_links: [
            {label: "Test Versions (web)", uri: "https://acme.io/test/versions"},
            {label: "Test Versions (feed)", uri: "https://acme.io/test/versions.xml"}
          ]
        )
      )
    end

    it "answers failure when project label doesn't exist" do
      attributes.delete :project_label

      expect(transformer.call(attributes)).to eq(
        Failure(
          step: :transform,
          payload: %(Unable to transform :syndication_links, missing specifier: "<project_label>".)
        )
      )
    end

    it "answers failure when project URI doesn't exist" do
      attributes.delete :project_uri

      expect(transformer.call(attributes)).to eq(
        Failure(
          step: :transform,
          payload: %(Unable to transform :syndication_links, missing specifier: "<project_uri>".)
        )
      )
    end

    it "ensures string keys are transformed as symbols" do
      attributes[:syndication_links].each(&:stringify_keys!)

      expect(transformer.call(attributes)).to eq(
        Success(
          project_label: "Test",
          project_uri: "https://acme.io/test",
          syndication_links: [
            {label: "Test Versions (web)", uri: "https://acme.io/test/versions"},
            {label: "Test Versions (feed)", uri: "https://acme.io/test/versions.xml"}
          ]
        )
      )
    end

    it "answers empty links when project keys don't exist" do
      expect(transformer.call({})).to eq(Success({syndication_links: []}))
    end
  end
end
