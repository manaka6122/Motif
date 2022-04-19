class Public::SearchesController < ApplicationController
  def search
    @model = params[:model]
    @content = params[:content]
    if @model == "team"
      @records = Team.search_for(@content).page(params[:page]).per(10)
    elsif @model == "tag"
      @records = Team.search_from_tags(@content).page(params[:page]).per(10)
    end
  end
end
