require_relative '../../lib/controller_base'
require_relative '../models/post'
require 'byebug'

class PostsController < ControllerBase
  def create
    @post = Post.new(post_params)
    @post.save
    redirect_to('/')
  end

  def index
    @posts = Post.all
  end

  def new
  end

  private

  def post_params
    {
      :title => params['post']['title'],
      :body => params['post']['body']
    }
  end
end
