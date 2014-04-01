class InvitationsController < ApplicationController
  before_action :load_root

  def create
    if params[:id] == params[:branch_id]
      @branch = @tree
    else  
      @branch = @tree.find_branch(params[:branch_id])
    end 
    @link = url_for(controller: 'branches',
        action: 'new',
        id: @tree.id,
        branch_id: @branch.id,
        only_path: false);
    
    params[:invitations].split(",").each do |to|
      to = to.strip
      UserMailer.invite_friends(@link, to, current_user).deliver
    end  
    redirect_to '/'
  end

  def show 
    @invitation = Invitations.find_by_token(params[:token])
    unless @invitation.empty?
      @tree = @invitation.tree
      @branch = @invitation.branch
      session[:token_id] = @invitation.id
      render :"branches/new"
    else 
      redirect_to root_path, :notice => "This doesn't look like a valid token"
    end 
  end

end