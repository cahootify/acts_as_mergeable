require 'acts_as_mergeable/version'

 # PLAN:
 # - have each association as a module with logic for each in their separate module
 # - require all here
 # - base logic here, making calls to each module as needed
 # - each module tested separately in their respective spec files

 # Note:
 # - an account should not be merged until some random code has been confirmed by the main owner... or it's done by an admin

module ActsAsMergeable
  module Base
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_mergeable
        include ActsAsMergeable::InstanceMethods
      end
    end
  end

  module InstanceMethods
    def merge(instance)
      # Hey! merge only objects of same class!
      raise 'YEET!!!' unless instance.instance_of?(self.class)

      transaction do
        mergeable_associations.each { |assoc| Object.const_get(assoc).send(:merge, self, instance) }
      end
    end

    private

    def mergeable_associations
      %w(HasMany HasOne BelongsTo HasAndBelongsToMany).freeze
    end
  end
end

# creating a method that could be call on any class to provide access to this...
ActiveRecord::Base.class_eval { include ActsAsMergeable::Base }
