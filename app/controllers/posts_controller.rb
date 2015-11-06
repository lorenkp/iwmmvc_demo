require_relative '../../lib/controller_base'
require_relative '../models/post'

class PostsController < ControllerBase
  def create
    return edit if params['post']['edit']
    @post = Post.new(post_params)
    @post.save
    redirect_to('/')
  end

  def index
    @posts = Post.all
  end

  def new
  end

  def post_id
    req.path.scan(/\d+/)[0]
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
    @post = Post.new(post_params.merge(:id => params['post']['edit']))
    @post.save
    redirect_to('/')
  end

  private

  def post_params
    {
      :title => params['post']['title'],
      :body => params['post']['body']
    }
  end
end
