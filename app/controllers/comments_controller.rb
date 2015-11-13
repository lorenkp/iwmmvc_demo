require_relative '../../lib/controller_base'
require_relative '../models/comment'
require_relative '../models/post'

class CommentsController < ControllerBase
  def index
    @comments = Post.find(post_id).comments
    @post = Post.find(post_id)
  end

  def new
    @post = Post.find(post_id)
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.save
    redirect_to("/posts/#{comment_params[:post_id]}")
  end

  private

  def post_id
    req.path.scan(/\d+/)[0]
  end

  def comment_params
    {
      :body => params['comment']['body'],
      :post_id => params['comment']['post_id']
    }
  end
end
