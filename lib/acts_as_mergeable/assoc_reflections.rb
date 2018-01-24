module AssocReflections
  extend self # Turn instance methods into class methods

  def reflections_for(main, rel)
    main.class
      .reflect_on_all_associations
      .select { |r| r.macro == rel && r.options[:through].nil? }
  end
end
