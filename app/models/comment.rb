require_relative '../../lib/model_base'

class Comment < ModelBase
  belongs_to :post
end