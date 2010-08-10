module VestalVersions
  # The ActiveRecord model representing versions.
  class Version < ActiveRecord::Base
    include Comparable

    # Associate polymorphically with the parent record.
    belongs_to :versioned, :polymorphic => true

    # A column cannot be named changes for an active record model because it conflcits with
    # ActiveRecord::Base#changes included from ActiveRecord::Dirty
    serialize :vchanges, Hash

    # In conjunction with the included Comparable module, allows comparison of version records
    # based on their corresponding version numbers, creation timestamps and IDs.
    def <=>(other)
      [number, created_at, id].map(&:to_i) <=> [other.number, other.created_at, other.id].map(&:to_i)
    end

    # Returns whether the version has a version number of 1. Useful when deciding whether to ignore
    # the version during reversion, as initial versions have no serialized changes attached. Helps
    # maintain backwards compatibility.
    def initial?
      number == 1
    end
  end
end
