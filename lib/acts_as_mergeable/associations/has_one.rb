module HasOne
  require 'acts_as_mergeable/assoc_reflections'
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
    if main.send(assoc.name).nil?
      related = instance.send(assoc.name)
      # no need to go on if instance has no associated relationship here either
      return unless related

      foreign_key = assoc.foreign_key
      related.update(foreign_key.to_sym => main.id)
    end
  end
end
