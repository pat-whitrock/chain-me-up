# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'benchmark'

tree_one = Tree.new(:content => "A long long time ago")

def add_children(number, tree)
  tree_child_one = tree.child_trees.build(:content => "branch #{number}")
  tree_child_two = tree.child_trees.build(:content => "branch #{number}")
  tree_child_one.save
  tree_child_two.save
  if number != 0
    add_children(number-1, tree_child_one)
    add_children(number-1, tree_child_two)
  end  
end

add_children(8, tree_one)

