# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Views::Scopes::Contributors do
  subject(:scope) { described_class.new locals:, rendering: view.new.rendering }

  include_context "with user"

  let(:locals) { {all:} }

  let :view do
    Class.new Hanami::View do
      config.paths = [Bundler.root.join("lib/milestoner/templates")]
      config.template = "n/a"
    end
  end

  describe "#sentence" do
    let(:all) { [part, part, part] }
    let(:part) { Milestoner::Views::Parts::User.new value: user }

    it "answers contributors as a sentence of names" do
      expect(scope.sentence).to eq("Test, Test, and Test")
    end
  end

  describe "#call" do
    context "with contributors" do
      let(:all) { [Milestoner::Views::Parts::User.new(value: user)] }

      it "renders user list" do
        expect(scope.call).to include("https://avatars.githubusercontent.com/u/1")
      end
    end

    context "without contributors" do
      let(:all) { [] }

      it "renders none paragraph" do
        expect(scope.call).to be(nil)
      end
    end
  end
end
