class BranchesController < ApplicationController

  def new
    @tree = Tree.find(params[:id])
    @branch = @tree.find_branch(params[:branch_id])
    @new_branch = Tree.new
  end

  def create
    @tree = Tree.find(params[:id])
    @branch = @tree.find_branch(params[:branch_id])
    @new_branch = @branch.child_trees.build(:content => params[:tree][:content])
    binding.pry
    if @new_branch.save
      redirect_to '/'
    else
      redirect_to '/'
    end
  end

end