class WelcomeController < ApplicationController
  before_action :logged_in?

  def index
    @tree = Tree.order(contributor_count: :desc).limit(1)[0]
    @branch = @tree
    @history = @branch.history if @branch

    respond_to do |format|
      format.html { render :layout => "welcome" }
      format.json {
       render json: @branch.get_all_children }
    end
  end

  def home
    @tree = Tree.order(contributor_count: :desc).limit(1)[0]
    @branch = @tree
    @history = @branch.history

    respond_to do |format|
      format.json {
       render json: @branch.get_all_children }
    end    
  end
end
