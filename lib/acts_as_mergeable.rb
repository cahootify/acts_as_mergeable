require 'acts_as_mergeable/version'
require 'acts_as_mergeable/associations/has_many'
require 'acts_as_mergeable/associations/has_one'
require 'acts_as_mergeable/associations/has_and_belongs_to_many'
require 'acts_as_mergeable/associations/belongs_to'

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
    MERGEABLE_ASSOCIATIONS = %w(HasMany HasOne BelongsTo HasAndBelongsToMany).freeze

    def merge(instance, options={})
      main = options[:main] || self
      # Hey! merge only objects of same class!
      raise 'YEET!!!' unless instance.instance_of?(main.class)

      ActiveRecord::Base.transaction do
        # merge in associations
        MERGEABLE_ASSOCIATIONS.each { |assoc| Object.const_get(assoc).send(:merge, main, instance) }

        # and merge in attributes
        main.attributes.each do |field, val|
          main.send("#{field}=", instance.send(field)) unless val.present?
        end

        # IMPORTANT! not to forget to persist changes to db
        main.save!

        # delete the instance, if specified
        instance.destroy if options[:destroy] == true
      end
    end

    module_function :merge
    public :merge
  end
end

# creating a method that could be call on any class to provide access to this...
ActiveRecord::Base.class_eval { include ActsAsMergeable::Base }
