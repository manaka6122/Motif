class Public::SearchesController < ApplicationController
  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    @model = 'tag'
    @records = Tag.search_teams_for(@content, @method)
  end
end
