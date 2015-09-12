module Milestoner
  module Aids
    # Augments an object with Git support.
    module Git
      def git_supported?
        File.exist? File.join(Dir.pwd, ".git")
      end
    end
  end
end
