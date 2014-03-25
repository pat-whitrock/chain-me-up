class TreesController < ApplicationController

  def new
    @tree = Tree.new
  end

  def create
    @tree = Tree.new(get_tree_params)
    @tree.bind_user(current_user)    
    if @tree.save
      redirect_to '/', notice: "Your tree has been saved!"
    else
      render :new
    end
  end

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

  private
  def get_tree_params
    params.require(:tree).permit(:title,:content)
  end
end
