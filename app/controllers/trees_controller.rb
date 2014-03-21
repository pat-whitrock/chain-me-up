class TreesController < ApplicationController

  def index
    @trees = Tree.all
  end

  def show
    #at this point, we only look through Tree.first
    @tree = Tree.find_by_id(params[:id])
    @history = @tree.construct_history
  end

  def update


  end

end
