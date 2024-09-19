# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Views::ScopeBuilder do
  subject(:builder) { described_class }

  let :view do
    Class.new Hanami::View do
      config.paths = Bundler.root.join "lib/milestoner/templates"
      config.template = "n/a"
    end
  end

  let(:scope_a) { Class.new Hanami::View::Scope }
  let(:scope_b) { Class.new Hanami::View::Scope }

  before do
    stub_const "TestScopeA", scope_a
    stub_const "TestScopeB", scope_b
    Hanami::View.cache.cache.clear
  end

  describe ".call" do
    it "answers nil scope name without name" do
      scope = builder.call locals: {}, rendering: view.new.rendering
      expect(scope._name).to be(nil)
    end

    it "answers scope name with name" do
      scope = builder.call :test, locals: {}, rendering: view.new.rendering
      expect(scope._name).to eq(:test)
    end

    it "answers scope name with class" do
      scope = builder.call TestScopeA, locals: {}, rendering: view.new.rendering
      expect(scope._name).to eq(TestScopeA)
    end

    it "answers empty scope locals when given an empty hash" do
      scope = builder.call locals: {}, rendering: view.new.rendering
      expect(scope._locals).to eq({})
    end

    it "answers scope locals when given locals" do
      scope = builder.call locals: {a: 1}, rendering: view.new.rendering
      expect(scope._locals).to eq(a: 1)
    end

    it "answers default scope instance" do
      scope = builder.call locals: {}, rendering: view.new.rendering
      expect(scope).to be_a(Hanami::View::Scope)
    end

    it "answers specific scope instance" do
      scope = builder.call "TestScopeB", locals: {a: 1}, rendering: view.new.rendering
      expect(scope).to be_a(TestScopeB)
    end

    it "caches scope without duplicates" do
      builder.call TestScopeA, locals: {}, rendering: view.new.rendering
      builder.call TestScopeB, locals: {}, rendering: view.new.rendering
      builder.call "TestScopeA", locals: {}, rendering: view.new.rendering
      builder.call "TestScopeB", locals: {}, rendering: view.new.rendering
      builder.call scope_a, locals: {}, rendering: view.new.rendering
      builder.call scope_b, locals: {}, rendering: view.new.rendering

      expect(Hanami::View.cache.cache.values).to eq([TestScopeA, TestScopeB])
    end
  end
end
