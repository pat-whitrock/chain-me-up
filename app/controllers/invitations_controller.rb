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
    
    params[:invitations][0].split(",").each do |to|
        to = to.strip
        UserMailer.invite_friends(@link, to, current_user)
      end  
      redirect_to '/'
    end

end