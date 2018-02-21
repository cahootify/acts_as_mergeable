module HasOne
  require 'acts_as_mergeable'
  require 'acts_as_mergeable/assoc_reflections'

  extend AssocReflections
  extend self

  def merge(main, instance)
    reflections_for(main, :has_one).each do |assoc|
      effect_relationships_for_(main, instance, assoc)
    end
  end

  private

  def effect_relationships_for_(main, instance, assoc)
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
      ActsAsMergeable::InstanceMethods.merge(related, { main: main_assoc, destroy: true })
    end
  end
end
