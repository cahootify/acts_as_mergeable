module BelongsTo
  require 'acts_as_mergeable/assoc_reflections'
  extend AssocReflections
  extend self

  attr_reader :instance, :main

  def merge(main, instance)
    @main = main
    @instance = instance

    reflections_for(main, :belongs_to).each do |assoc|
      effect_relationships_for_(assoc)
    end
  end

  private

  def effect_relationships_for_(assoc)
    if main.send(assoc.name).nil?
      related = instance.send(assoc.name)
      foreign_key = assoc.foreign_key
      main.update(foreign_key.to_sym => related.id) unless related.nil?
    end
  end
end
