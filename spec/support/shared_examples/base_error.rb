# frozen_string_literal: true

RSpec.shared_examples_for "a base error" do
  it "behaves like a base error" do
    expect(subject).to be_a(Milestoner::Errors::Base)
  end
end
