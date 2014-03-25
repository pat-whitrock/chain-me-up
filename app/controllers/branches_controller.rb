class BranchesController < ApplicationController

  def new
    @tree = Tree.find(params[:id])
    if params[:id] == params[:branch_id]
      @branch = @tree
    else  
      @branch = @tree.find_branch(params[:branch_id])
    end  
    @new_branch = Tree.new
  end

  def create
    @tree = Tree.find(params[:id])
    if params[:id] == params[:branch_id]
      @branch = @tree
    else  
      @branch = @tree.find_branch(params[:branch_id])
    end 
    @new_branch = @branch.child_trees.build(:content => params[:tree][:content])

    @new_branch.bind_user(current_user)
    if @new_branch.save
      redirect_to '/'
    else
      redirect_to '/'
    end
  end

end