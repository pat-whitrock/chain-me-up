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
    # @trees = Tree.all
    @trees = Tree.get_trees_by_user(current_user)
  end

  def show
    #at this point, we only look through Tree.first
    @tree = Tree.find(params[:id])
    @branch = @tree.find_branch_by_user(current_user.id.to_s)
    @history = @branch.construct_history
  end

  def update
  end

  private
  def get_tree_params
    params.require(:tree).permit(:title,:content)
  end
end
