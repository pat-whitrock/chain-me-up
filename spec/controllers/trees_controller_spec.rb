require 'spec_helper'

describe TreesController do

  describe 'GET new' do
    it 'renders the page to create a tree' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'POST' do
    it 'creates a new tree' do
      post :create, {:tree => {:title => "An example title", :content => "Example content"}}
      expect(Tree.last.title).to eq("An example title")
      expect(Tree.last.content).to eq("Example content")     
    end
  end
end
