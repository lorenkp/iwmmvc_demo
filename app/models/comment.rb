require_relative '../../lib/model_base'

class Comment < ModelBase
  belongs_to :post
  make_column_attr_accessors!
end
