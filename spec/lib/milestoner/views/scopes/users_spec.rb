# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Views::Scopes::Users do
  subject(:scope) { described_class.new locals:, rendering: view.new.rendering }

  include_context "with user"

  let(:locals) { {users:} }

  let :view do
    Class.new Hanami::View do
      config.paths = [Bundler.root.join("lib/milestoner/templates")]
      config.template = "n/a"
    end
  end

  describe "#call" do
    context "with users" do
      let(:users) { [Milestoner::Views::Parts::User.new(value: user)] }

      it "renders user list" do
        expect(scope.call).to eq(<<~CONTENT)
          <ul class="list">
              <li class="item">
                <img src="https://avatars.githubusercontent.com/u/1"
               alt="Test"
               class="avatar"
               width="24"
               height="24"
               loading="lazy">
           <a href="https://github.com/test">Test</a>


              </li>
          </ul>
        CONTENT
      end
    end

    context "without users" do
      let(:users) { [] }

      it "renders none paragraph" do
        expect(scope.call).to eq(%(<p class="line">None.</p>\n))
      end
    end
  end
end
