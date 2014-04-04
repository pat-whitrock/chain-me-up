class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name, :last_name, :username, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:first_name, :last_name, :username, :email, :password, :password_confirmation)
    end
  end

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
    if current_user
      if current_user.trees.include?(@tree.id.to_s)
        redirect_to trees_path, :notice => "You've already contributed to this tree"
      end  
    end
  end

  def created_by_user?
    !!(@tree.user_id == current_user.id.to_s)
  end

  def logged_in?
    redirect_to trees_path if current_user 
  end

  def assign_user
    if current_user
      current_user
    else 
      begin
        user = User.find_by(:email => @invitation.email)
      rescue
        user = nil
      end
      if user
        sign_in(user)
      else 
        user = User.create(:email => @invitation.email)  
        user.guest = true 
        user.save!(:validate => false)
        sign_in(user)
      end
      user
    end
  end
end
