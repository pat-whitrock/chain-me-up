class Tree
  include Mongoid::Document

  recursively_embeds_many
  after_initialize :initialize_history

  field :user_id, type: Integer
  field :content, type: String

  attr_accessor :history


  def initialize_history
    @history = []
  end

  def find_node_by_id

  end


  def get_history
    history = []
    self.traverse_parents do |node|
      history << node
    end
    history 
  end

  def traverse_parents(&block)
    yield self
    if !self.parent_tree.nil?
      self.parent_tree.traverse_parents(&block)
    end  
  end

  def construct_history
    history_array = get_history
    story = ""
    history_array.each do |history|
      story << history.content
    end
    story
  end
  


end


=begin

def get_history
history = []
self.construct_history do |node|
  history << node
end
history 
end

construct_history(&block)
  if !self.parent.nil?
    yield self.parent.construct_history(&block)
  else 
    yield self
  end  
end

 
 fields: id (int), content (string), user_id (int), children (array)
 
 each tree should have a children array of trees

  # get content => 
 #get_history => Helper for get_content, climbs up through a parents, stitch together content

 returns 

 history = {
  part 1 => {
    :content => ""
    :id => 23
  }
  part 2 => {
    :content => ""
    :id => 23
  } 
  part 3 => {
    :content => ""
    :id => 23
  }     

  history.inject do |child, hash|
   child.content 
  end


 }


=end 