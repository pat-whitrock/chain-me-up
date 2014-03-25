require_relative '../spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe "the create tree page" do

  before :each do 
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
  end    

  it "allows the user to create a tree from scratch" do

    visit '/trees/new'

    fill_in 'Title', :with => "Example Tree title"

    fill_in 'Content', :with => "A long long time ago..."

    click_button 'Create Tree'

    tree = Tree.last

    expect(tree.content).to eq("A long long time ago...")

    expect(current_path).to eq('/')

    expect(page).to have_content('Example Tree title')

end


  describe "the edit tree page" do

  # "User can view all of the past history of a tree"

  # "User can add to a tree"

  # "User cant add to a tree that has been closed or already edited"

  end
end