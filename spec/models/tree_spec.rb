require_relative '../spec_helper'

describe Tree do

  let(:tree) {Tree.create(:title => "Test", :content => "Test content")}

  let(:user) {create(:user)}

  describe "#find_branch" do 
    it "finds a branch by id" do
      child = tree.child_trees.build(:content => "And it continued as a legend")
      child.save
      branch = tree.find_branch_by({:id => child.id})
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

  describe ".get_trees_by_user" do
    it "gets all trees created by a user" do
      tree.bind_user(user)
      expect(Tree.get_trees_by_user(user).first).to eq(tree)
    end
  end

  describe "#find_branch_by_user" do
    it "returns the branch of a tree by user_id" do
      child = tree.child_trees.build(:content => "And it continued as a legend")
      child.bind_user(user)
      expect(tree.find_branch_by({:user_id => user.id.to_s})).to eq(child)
    end
  end

end