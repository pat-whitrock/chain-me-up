class BranchesController < ApplicationController
  before_action :load_root 
  before_action :verify_can_create
  
  def new
    if @tree.id.to_s == params[:branch_id]
      @branch = @tree
    else  
      @branch = @tree.find_branch(params[:branch_id])
    end  
    @new_branch = Tree.new
  end

  def create
    @user = assign_user
    if params[:id] == params[:branch_id]
      @branch = @tree
    else  
      @branch = @tree.find_branch(params[:branch_id])
    end 
    @new_branch = @branch.child_trees.build(:content => params[:tree][:content])

    @new_branch.bind_user(@user)
    if @new_branch.save
      redirect_to @new_branch, :notice => "Do you want to create an account to save access to your tree?"
    else
      redirect_to '/'
    end
  end

end 