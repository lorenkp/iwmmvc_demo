require 'active_support/inflector'

class AssocOptions
  attr_accessor :foreign_key, :class_name, :primary_key

  def model_class
    @class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] || (name.to_s + '_id').to_sym
    @primary_key = :id
    @class_name = options[:class_name] || name.to_s.camelcase
  end
end

class HasManyOptions < AssocOptions
end

module Associatable
  def belongs_to(assoc_name, options = {})
    @options = BelongsToOptions.new(assoc_name, options)
    define_method(name) do

    end
  end
end
