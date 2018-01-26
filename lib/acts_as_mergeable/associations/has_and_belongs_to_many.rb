module HasAndBelongsToMany
  require 'acts_as_mergeable/assoc_reflections'

  extend AssocReflections
  extend self

  attr_reader :instance, :main

  def merge(main, instance)
    @main = main
    @instance = instance

    reflections_for(main, :has_and_belongs_to_many).each do |assoc|
      update_to_reflect_new_parent(assoc)
    end
  end

  private

  def update_to_reflect_new_parent(assoc)
    join_table = assoc.join_table
    foreign_key = assoc.foreign_key
    update_query = <<~UPDATE_QUERY
      UPDATE #{join_table}
      SET #{foreign_key} = #{main.id}
      WHERE #{foreign_key} = #{instance.id}
    UPDATE_QUERY
    ActiveRecord::Base.connection.execute(update_query)

    # remember to delete duplicates
    # though this could be inclided in the where statement above, either ways, we'll still need to delete the duplicates
    prunning_query = <<~PRUNNING_QUERY
      DELETE
      FROM #{join_table}
      WHERE ID NOT IN
      (
        SELECT MAX(ID)
        FROM #{join_table}
        GROUP BY #{foreign_key}, #{assoc.association_foreign_key}
      )
    PRUNNING_QUERY
    ActiveRecord::Base.connection.execute(prunning_query)
  end
end
