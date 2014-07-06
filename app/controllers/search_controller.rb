class SearchController < ApplicationController
  include SortableSearchResults
  respond_to :html, :xml, :json

  def index
    @q = params[:q]
    @posts = Post.
      search(@q,
             star: true,
             order: map_sort_key(params[:sort], :remote_created_at_desc)).
      page(params[:page] || 1).per(40)
    @title = @q
    respond_with @posts
  end
end
