# frozen_string_literal: true

RSpec.shared_context "with user" do
  let(:user) { Milestoner::Models::User[external_id: 1, handle: "test", name: "Test"] }
end
