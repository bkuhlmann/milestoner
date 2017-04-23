# frozen_string_literal: true

module Milestoner
  # Handles the tagging and pushing of a milestone to a remote repository.
  class Publisher
    def initialize tagger: Tagger.new, pusher: Pusher.new
      @tagger = tagger
      @pusher = pusher
    end

    # :reek:BooleanParameter
    def publish version, sign: false
      tagger.create version, sign: sign
      pusher.push
    end

    private

    attr_reader :tagger, :pusher
  end
end
