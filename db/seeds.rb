# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

tree_one = Tree.new(:content => "A long long time ago")

tree_two = Tree.new(:content => "in a galexy far far away")
tree_three = Tree.new(:content => "in a deep, dark forest")

tree_one.children << tree_two
tree_one.children << tree_three

# tree_one.children << tree_two
# tree_one.children << tree_three

# tree_one.save

tree_four = Tree.new(:content => "the sith lords were taking over")
tree_five = Tree.new(:content => "Luke slayed a wombat")

tree_two.children << tree_four
tree_two.children << tree_five


tree_six = Tree.new(:content => "But the jedi has one last stand")
tree_seven = Tree.new(:content => "We'll see what happens...")

tree_four.children << tree_six
tree_four.children << tree_seven


tree_one.save
tree_two.save
tree_three.save
tree_four.save
tree_five.save
tree_six.save
tree_seven.save

# tree_three.children << tree_six
# tree_three.children << tree_seven