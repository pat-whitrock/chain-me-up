require_relative '../spec_helper'

describe Tree do

  let(:tree) {Tree.create(:title => "Test", :content => "Test content")}

  describe "#find_branch" do 

    it "finds a branch by id" do
      child = tree.child_trees.build(:content => "And it continued as a legend")
      child.save
      branch = tree.find_branch(child.id)
      expect(branch).to be_a(Tree)
      expect(branch).to eq(child)
    end
  end

  describe "#history" do
    it "returns the history of a branch" do
      child = tree.child_trees.build(:content => "And it continued as a legend")
      child.save
      expect(child.history[:title]).to eq("Test")
      expect(child.history[:content]).to eq("Test content And it continued as a legend")
    end
  end

end