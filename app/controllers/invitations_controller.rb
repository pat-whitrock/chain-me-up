class InvitationsController < ApplicationController
  before_action :load_root, :only => [:create]

  def create
    if params[:id] == params[:branch_id]
      @branch = @tree
    else  
      @branch = @tree.find_branch(params[:branch_id])
    end 
    
    params[:invitations][0].split(",").each do |to|
        invitation = Invitation.create(:email => to, :tree => @tree.id.to_s, :branch => @branch.id.to_s)
        url = "http://localhost:3000/submit?token=#{invitation.token}"
        UserMailer.invite_friends(url, to, current_user)
      end  
      redirect_to '/'
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
      session[:token_id] = @invitation.token
      @new_branch = Tree.new
      render :"branches/new"
    else 
      redirect_to root_path, :notice => "This doesn't look like a valid token"
    end 
  end

end