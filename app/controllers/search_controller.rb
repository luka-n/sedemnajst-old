class SearchController < ApplicationController
  respond_to :html, :xml, :json

  def index
    @q = params[:q]
    @posts = Post.
      search(@q, star: true, order: "remote_created_at DESC").
      page(params[:page] || 1).per(40)
    @posts.context[:panes] << ThinkingSphinx::Panes::ExcerptsPane
    @title = @q
    respond_with @posts
  end
end
