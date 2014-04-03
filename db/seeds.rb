# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'benchmark'

user = User.last
tree_one = Tree.new(:content => "Tumblr you probably haven't heard of them Intelligentsia. ", :title => "A visualization")
tree_one.bind_user(user)

# text_old = "Umami retro put a bird on it, twee asymmetrical mustache Schlitz. \n+1 Etsy polaroid Marfa chia kale chips ennui asymmetrical bespoke Austin meh, pickled skateboard. Hoodie leggings organic selvage selfies, distillery hashtag mixtape irony umami you probably haven't heard of them normcore post-ironic. \n+1 dreamcatcher Odd Future leggings pork belly fap, biodiesel DIY distillery Truffaut. Readymade selvage Brooklyn, street art cray polaroid ennui cornhole actually Neutra. \nSynth pickled bitters seitan, umami aesthetic photo booth freegan Schlitz food truck. Tattooed wayfarers scenester, swag you probably haven't heard of them organic Cosby sweater salvia.Helvetica freegan raw denim PBR&B locavore. Chia artisan cray cardigan banjo. \n3 wolf moon brunch cardigan PBR&B Bushwick. Authentic 8-bit sriracha, Neutra distillery butcher squid. Lo-fi sriracha cray authentic, gentrify Bushwick aesthetic kogi chia mlkshk Cosby sweater VHS. Photo booth Williamsburg kale chips YOLO. Viral Cosby sweater retro, cliche letterpress paleo semiotics chambray fap biodiesel Intelligentsia wolf.McSweeney's art party Odd Future banh mi synth, American Apparel tote bag seitan lo-fi bitters fixie Neutra organic. Umami pop-up ethical pork belly pour-over Odd Future. Try-hard flannel twee, church-key seitan pop-up ethnic actually wayfarers biodiesel. Seitan Tonx Portland artisan. Tousled organic scenester pickled sustainable beard. Next level 90's Helvetica, hoodie craft beer artisan jean shorts leggings bitters chambray deep v Vice brunch Truffaut. Cardigan scenester actually ethical food truck, twee master cleanse cliche messenger bag craft beer mumblecore Neutra normcore biodiesel."
text = "Umami retro put a bird on it, twee asymmetrical mustache Schlitz. +1 Etsy polaroid Marfa chia kale chips ennui asymmetrical bespoke Austin meh, pickled skateboard. Hoodie leggings organic selvage selfies, distillery hashtag mixtape irony umami you probably haven't heard of them normcore post-ironic. +1 dreamcatcher Odd Future leggings pork belly fap, biodiesel DIY distillery Truffaut. Readymade selvage Brooklyn, street art cray polaroid ennui cornhole actually Neutra. Synth pickled bitters seitan, umami aesthetic photo booth freegan Schlitz food truck. Tattooed wayfarers scenester, swag you probably haven't heard of them organic Cosby sweater salvia.

Helvetica freegan raw denim PBR&B locavore. Chia artisan cray cardigan banjo. 3 wolf moon brunch cardigan PBR&B Bushwick. Authentic 8-bit sriracha, Neutra distillery butcher squid. Lo-fi sriracha cray authentic, gentrify Bushwick aesthetic kogi chia mlkshk Cosby sweater VHS. Photo booth Williamsburg kale chips YOLO. Viral Cosby sweater retro, cliche letterpress paleo semiotics chambray fap biodiesel Intelligentsia wolf.

McSweeney's art party Odd Future banh mi synth, American Apparel tote bag seitan lo-fi bitters fixie Neutra organic. Umami pop-up ethical pork belly pour-over Odd Future. Try-hard flannel twee, church-key seitan pop-up ethnic actually wayfarers biodiesel. Seitan Tonx Portland artisan. Tousled organic scenester pickled sustainable beard. Next level 90's Helvetica, hoodie craft beer artisan jean shorts leggings bitters chambray deep v Vice brunch Truffaut. Cardigan scenester actually ethical food truck, twee master cleanse cliche messenger bag craft beer mumblecore Neutra normcore biodiesel."
# experiment= "Umami\n. retro\n. put\n. a\n. bird\n. on\n. it"

text = text.gsub(". ", ".. ").split(". ")

def add_children_again(number, tree, sample_text)
  tree_child_one = tree.child_trees.build(:content => " "+sample_text.sample)
  tree_child_two = tree.child_trees.build(:content => " "+sample_text.sample)
  tree_child_three = tree.child_trees.build(:content => " "+sample_text.sample)
  tree.get_root.contributor_count += 3
  tree.get_root.save
  arr = [tree_child_one, tree_child_two, tree_child_three]
  tree_child_one.save
  tree_child_two.save
  tree_child_three.save
  if number != 0
    add_children_again(number-1, arr.sample, sample_text)
    add_children_again(number-1, arr.sample, sample_text)
    add_children_again(number-1, arr.sample, sample_text)
  end  
end

add_children_again(2, tree_one, text)
tree_one.save