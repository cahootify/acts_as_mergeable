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

    related = filter_based_on_scoped_uniquenesss(related, main, assoc)

    # checking for any max length validation on main
    # we don't want to go over defined threasholds
    max_length = max_length_allowed_for_(main, assoc.name)
    if max_length
      remaining_allowed_numbers = max_length - main.send(assoc.name).size
      related = related.limit(remaining_allowed_numbers)
    end

    related.update_all(foreign_key.to_sym => main.id)
  end

  def max_length_allowed_for_(main, assoc_name)
    length_validators = main.class.validators.select do |v|
      v.instance_of?(ActiveRecord::Validations::LengthValidator) && v.attributes.include?(assoc_name.to_sym)
    end
    max_lengths = length_validators.map { |v| v.options[:maximum] }
    max_lengths.min
  end

  def filter_based_on_scoped_uniquenesss(related, main, assoc)
    scoped_uniq_validators = assoc.klass.validators.select do |v|
      v.instance_of?(ActiveRecord::Validations::UniquenessValidator) && in_attr_or_scope(v, assoc.inverse_of&.name, assoc.foreign_key.to_sym)
    end

    scoped_uniq_validators.each do |suv|
      uniq_key = [suv.attributes, suv.options[:scope]].flatten.find{|a| a != assoc.foreign_key.to_sym}

      existing_values = main.send(assoc.name).map{|m| m.send(uniq_key)}

      related = related.where.not(uniq_key => existing_values)
    end

    return related
  end

  def in_attr_or_scope(validator, rel, attr)
    [rel, attr].any? { |v|  validator.attributes.include?(v) || validator.options[:scope] == v }
  end
end
