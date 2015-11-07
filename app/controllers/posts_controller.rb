require_relative '../../lib/controller_base'
require_relative '../models/post'

class PostsController < ControllerBase
  def create
    return patch if params['post']['edit']
    @post = Post.new(post_params)
    @post.save
    redirect_to('/')
  end

  def index
    @posts = Post.all
  end

  def new
  end

  def show
    return destroy if params['post'] && params['post']['delete']
    @post = Post.find(post_id)
  end

  def destroy
    @post = Post.find(post_id)
    @post.destroy
    redirect_to('/')
  end

  def edit
    @post = Post.find(post_id)
  end

  private

  def post_id
    req.path.scan(/\d+/)[0]
  end

  def patch
    @post = Post.new(post_params)
    id = params['post']['edit']
    @post.id = id
    @post.created_at = Post.find(id).created_at
    @post.save
    redirect_to('/')
  end

  def post_params
    {
      :title => params['post']['title'],
      :body => params['post']['body']
    }
  end
end
