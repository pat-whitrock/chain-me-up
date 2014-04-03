class InvitationsController < ApplicationController
  before_action :load_root, :only => [:create]

  def create
    if params[:id] == params[:branch_id]
      @branch = @tree
    else  
      @branch = @tree.find_branch(params[:branch_id])
    end 
    
    params[:invitations][0].split(",").each do |to|
      @invitation = Invitation.create(:email => to, :tree => @tree.id.to_s, :branch => @branch.id.to_s)
      UserMailer.invite_friends(@invitation, to, current_user)
    end  
    
     respond_to do |format|
        format.js 
        format.html { redirect_to '/' } 
    end

  end

  def show 
    @invitation = Invitation.find_by_token(params[:token])
    if @invitation
      @tree = Tree.find(@invitation.tree)
      if @tree.id.to_s == @invitation.tree
        @branch = @tree
      else  
        @branch = @tree.find_branch(params[:branch_id])
      end
      assign_user  
      session[:token] = @invitation.token
      if current_user.trees.include?(@tree.id.to_s)
        redirect_to trees_path, :notice => "You've already contributed to this tree"
      else 
        @new_branch = Tree.new
        render :"branches/new" 
      end  
    else 
      redirect_to root_path, :notice => "This doesn't look like a valid token"
    end 
  end

end