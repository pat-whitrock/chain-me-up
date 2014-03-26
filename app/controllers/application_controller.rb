class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def load_root
    @tree = Tree.find(params[:id])
  end

  def verify_can_view
    unless current_user.trees.include?(@tree.id.to_s)
      flash[:error] = "You don't have permission to view this tree"
      redirect_to trees_path
    end  
  end

  def verify_can_create
    unless !current_user
      if current_user.trees.include?(@tree.id.to_s)
        redirect_to trees_path, :notice => "You've already contributed to this tree"
      end  
    end
  end

  def created_by_user?
    !!(@tree.user_id == current_user.id.to_s)
  end
end
