# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'benchmark'

user = User.last
tree_one = Tree.new(:content => "heyeyey", :title => "A visualization")
tree_one.bind_user(user)

# def add_children(number, tree)
#   tree_child_one = tree.child_trees.build(:content => "branch #{number}")
#   tree_child_two = tree.child_trees.build(:content => "branch #{number}")
#   tree_child_one.save
#   tree_child_two.save
#   if number != 0
#     add_children(number-1, tree_child_one)
#     add_children(number-1, tree_child_two)
#   end  
# end

def add_children_again(number, tree)
  tree_child_one = tree.child_trees.build(:content => "branch #{number}")
  tree_child_two = tree.child_trees.build(:content => "branch #{number}")
  tree_child_three = tree.child_trees.build(:content => "branch #{number}")
  # binding.pry
  tree.get_root.contributor_count += 3
  tree.get_root.save
  # binding.pry
  arr = [tree_child_one, tree_child_two, tree_child_three]
  tree_child_one.save
  tree_child_two.save
  tree_child_three.save
  if number != 0
    add_children_again(number-1, arr.sample)
    add_children_again(number-1, arr.sample)
    add_children_again(number-1, arr.sample)
  end  
end

 add_children_again(3, tree_one)
 tree_one.save