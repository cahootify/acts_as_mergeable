module HasMany
  require 'acts_as_mergeable/assoc_reflections'
  extend AssocReflections
  extend self

  attr_reader :instance, :main

  def merge(main, instance)
    @main = main
    @instance = instance

    reflections_for(main, :has_many).each do |assoc|
      update_to_reflect_new_parent(assoc)
    end
  end

  private

  def update_to_reflect_new_parent(assoc)
    related = instance.send(assoc.name)
    foreign_key = assoc.foreign_key
    related.update_all(foreign_key.to_sym => main.id)
  end
end
