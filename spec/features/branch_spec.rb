require_relative '../spec_helper'

describe "the create branch page" do

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
end