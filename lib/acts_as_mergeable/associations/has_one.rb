module HasOne
  require 'acts_as_mergeable/assoc_reflections'
  require 'acts_as_mergeable/associations/has_many'
  require 'acts_as_mergeable/associations/belongs_to'
  require 'acts_as_mergeable/associations/has_and_belongs_to_many'

  extend AssocReflections
  extend self

  attr_reader :instance, :main

  def merge(main, instance)
    @main = main
    @instance = instance

    reflections_for(main, :has_one).each do |assoc|
      effect_relationships_for_(assoc)
    end
  end

  private

  def effect_relationships_for_(assoc)
    main_assoc = main.send(assoc.name)
    related = instance.send(assoc.name)

    # no need to go on if instance has no associated relationship here either
    return unless related

    if main_assoc.nil?
      foreign_key = assoc.foreign_key
      related.update(foreign_key.to_sym => main.id)

    elsif main_assoc && (main_assoc != related)
      # in the case main object already belongs to one other instance(which is not same as that of merging instance)
      # we should ensure to do a clone deep into the associations of the instances our other guy belonges to.
      # TODO: this should be same as calling main_assoc.merge(related)
      HasOne.merge(main_assoc, related)
      HasMany.merge(main_assoc, related)
      HasAndBelongsToMany.merge(main_assoc, related)
      BelongsTo.merge(main_assoc, related)
    end
  end
end
