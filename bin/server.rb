#! /usr/bin/env ruby

require 'webrick'
require_relative '../lib/router'
require_relative '../app/controllers/posts_controller'

router = Router.new
router.draw do
  # Routes are drawn here. For example, to get the index of users:
  get Regexp.new('^/$'), PostsController, :index
  get Regexp.new("^/post/new$"), PostsController, :new
  post Regexp.new("^/post$"), PostsController, :create
end

PORT = ARGV[0] || 3000
server = WEBrick::HTTPServer.new(Port: PORT)
server.mount_proc('/') do |req, res|
  router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
