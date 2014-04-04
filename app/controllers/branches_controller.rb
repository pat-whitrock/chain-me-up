class BranchesController < ApplicationController
  before_action :load_root 
  before_action :verify_can_create
  
  def new
    if @tree.id.to_s == params[:branch_id]
      @branch = @tree
    else  
      @branch = @tree.find_branch_by(:id => params[:branch_id])
    end  
    @new_branch = Tree.new
  end

  def create
    if params[:id] == params[:branch_id]
      @branch = @tree
    else  
      @branch = @tree.find_branch_by(:id => params[:branch_id])
    end 
    @new_branch = @branch.child_trees.build(:content => params[:tree][:content])

    @new_branch.bind_user(current_user)
    if @new_branch.save
      invite = Invitation.find_by(:token => session[:token])
      invite.destroy
      redirect_to @tree, :notice => "Do you want to create an account to save access to your tree?"
    else
      redirect_to '/'
    end
  end

end 