require_relative '../spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe "the create branch page" do

  before :each do 
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
  end    

  let(:tree) {Tree.create(:title => "Many galaxies away...", :content => "Star wars began as a story")}

  # before :each do
  #   child = tree.child_trees.build(:content => "And it continued as a legend")
  #   child.save
  #   visit "/trees/#{tree.id}/branch/#{child.id}/new"
  # end

  it "displays to the user the tree's history" do
    child = tree.child_trees.build(:content => "And it continued as a legend")
    child.save
    visit "/trees/#{tree.id}/branch/#{child.id}/new"

    expect(page).to have_content("Many galaxies away...")
    expect(page).to have_content("Star wars began as a story And it continued as a legend")

  end

  it "allows the user to create a branch on a tree" do
    child = tree.child_trees.build(:content => "And it continued as a legend")
    child.save
    visit "/trees/#{tree.id}/branch/#{child.id}/new"

    fill_in 'Content', :with => "Or so somebody told me about star wars"

    click_button 'Create Branch'
    
    child.reload
    expect(child.child_trees.first.content).to eq("Or so somebody told me about star wars")
  end

  it 'prohibits the user from creating a branch on a tree they created' do
    visit '/trees/new'
    fill_in 'Title', :with => "Example Tree title"
    fill_in 'Content', :with => "A long long time ago..."
    click_button 'Create Tree'
    tree = Tree.last

    visit "/trees/#{tree.id}/branch/#{tree.id}/new"
    expect(page).to have_content("You've already contributed to this tree")
  end

  it 'provides the user with a link to share with others' do
    visit '/trees/new'
    fill_in 'Title', :with => "Example Tree title"
    fill_in 'Content', :with => "A long long time ago..."
    click_button 'Create Tree'
    tree = Tree.last

    visit "/trees/#{tree.id}"
    expect(page).to have_content("Share this link for contributors")

  end

  it 'prohibits the user from contributing twice to the same tree' do
    @t = Tree.create(:title => "the first tree ever", :content => "has content")
    @b = @t.child_trees.build(:content => "super awesome branch")
    @b2 = @t.child_trees.build(:content => "content I shouldn't see!")
    @b.save
    @b2.save

    visit "/trees/#{@t.id}/branch/#{@b.id}/new"
    fill_in 'Content', :with => "testing..."
    click_button 'Create Branch'

    visit "/trees/#{@t.id}/branch/#{@b2.id}/new"
    expect(page).to have_content("You've already contributed to this tree")
  end

end