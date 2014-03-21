require 'spec_helper'

describe BranchesController do

  let(:tree) {Tree.create(:title => "Many galaxies away...", :content => "Star wars began as a story")}
  let(:child) {tree.child_trees.build(:content => "And it continued as a legend")}

  before :each do
    child.save
  end

  describe 'GET new' do
    it 'renders the page to create a branch' do
      get :new, id: tree.id, branch_id: child.id
      expect(response).to render_template('new')
    end
  end

  describe 'POST' do
    it 'creates a new tree as a child of the parent tree' do
      post :create, {id: tree.id, branch_id: child.id, :tree => {:content => "Example content"}}
      child.reload
      expect(child.child_trees[0].content).to eq("Example content")
    end
  end
end
