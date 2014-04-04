class TreesController < ApplicationController
  before_action :load_root, :only => [:show]
  before_action :authenticate_user!
  before_action :verify_can_view, :only => [:show]

  def new
    @tree = Tree.new
    @prompt = Prompt.random_sample(5).collect do |prompt|
      prompt.content
    end
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
    @trees = Tree.get_trees_by_user(current_user)
  end

  def show
    if created_by_user?
      @history = @tree.history
      @branch = @tree
    elsif params[:branch_id]
      @branch = @tree.find_branch_by(:id => params[:branch_id])
    else 
      @branch = @tree.find_branch_by(:user_id => current_user.id.to_s)
      @history = @branch.history
    end  

    respond_to do |format|
      format.html
      format.json { render json: @branch.get_all_children }
    end
  end

  private

  def get_tree_params
    params.require(:tree).permit(:title,:content)
  end

end