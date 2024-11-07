# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Views::Scopes::Logo do
  subject(:scope) { described_class.new locals: {}, rendering: view.new.rendering(context:) }

  include_context "with application dependencies"

  let :view do
    Class.new Hanami::View do
      config.paths = [Bundler.root.join("lib/milestoner/templates")]
      config.template = "n/a"
    end
  end

  let(:context) {  Milestoner::Views::Context.new settings: }

  describe "#call" do
    it "renders logo when URI is present" do
      settings.project_uri_logo = "https://test.io/logo.png"

      expect(scope.call).to eq(
        %(<img src="https://test.io/logo.png" alt="Logo" width="100" height="100">\n)
      )
    end

    it "renders empty string when URI is nil" do
      settings.project_uri_logo = nil
      expect(scope.call).to eq("")
    end
  end
end
