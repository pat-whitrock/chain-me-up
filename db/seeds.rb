# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



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



# tree_two = tree_one.child_trees.build(:content => "in a galexy far far away")
# tree_three = tree_one.child_trees.build(:content => "in a deep, dark forest")

# tree_one.save



# tree_four = tree_two.child_trees.build(:content => "the sith lords were taking over")
# tree_five = tree_two.child_trees.build(:content => "Luke slayed a wombat")

# tree_four.save
# tree_five.save



# tree_six = tree_four.child_trees.build(:content => "But the jedi has one last stand")
# tree_seven = tree_six.child_trees.build(:content => "We'll see what happens...")

# tree_six.save
# tree_seven.save



