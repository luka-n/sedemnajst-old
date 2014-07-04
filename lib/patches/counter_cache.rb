# https://github.com/rails/rails/issues/13666
class ActiveRecord::Associations::HasManyAssociation
  private

  def has_cached_counter?(reflection = reflection())
    return false if !options[:counter_cache]
    owner.attribute_present?(cached_counter_attribute_name(reflection))
  end
end
