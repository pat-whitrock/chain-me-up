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
end

describe "the display tree page" do

  before :each do 
    @t = Tree.create(:title => "the first tree ever", :content => "has content")
    @b = @t.child_trees.build(:content => "super awesome branch")
    @b2 = @t.child_trees.build(:content => "content I shouldn't see!")
    @b.save
    @b2.save
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
  end    

  it "displays a tree only from your level down" do
    visit "/trees/#{@t.id}/branch/#{@t.id}/new"
    expect(page).to have_content('has content')

    page.should_not have_content("super awesome branch")
    page.should_not have_content("content I shouldn't see!")

  end
end