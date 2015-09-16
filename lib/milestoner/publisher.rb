module Milestoner
  # Handles the tagging and pushing of a milestone to a remote repository.
  class Publisher
    def initialize tagger, pusher
      @tagger = tagger
      @pusher = pusher
    end

    def publish version, sign: false
      tagger.create version, sign: sign
      pusher.push
    ensure
      tagger.destroy
    end

    private

    attr_reader :tagger, :pusher
  end
end
