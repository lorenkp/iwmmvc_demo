require_relative '../../lib/model_base'

class Post < ModelBase
  has_many :comments
  make_column_attr_accessors!
end