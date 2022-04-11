class Public::SearchesController < ApplicationController
  def search
    @model = params[:model]
    @content = params[:content]
    if @model == 'team'
      @records = Team.search_for(@content)
    elsif @model == 'tag'
      @records = Tag.search_teams_for(@content)
    end
  end
end
