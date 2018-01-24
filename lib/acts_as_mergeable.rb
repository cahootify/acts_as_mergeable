require 'acts_as_mergeable/version'

 # PLAN:
 # - have each association as a module with logic for each in their separate module
 # - require all here
 # - base logic here, making calls to each module as needed
 # - each module tested separately in their respective spec files
 # - start from the simplest: has_many.

 # Note:
 # - an account should not be merged until some random code has been confirmed by the main owner... or it's done by an admin

module ActsAsMergeable
  def merge(instance)
    # Hey! merge only objects of same class!
    raise 'STUPID ERROR!!!' unless self.class == instance.class

    transaction do
      mergeable_associations.each { |assoc| Object.const_get(assoc).send(:merge, self, instance) }
    end
  end

  private

  def mergeable_associations
    %w(HasMany HasOne BelongsTo HasAndBelongsTomany).freeze
  end
end
