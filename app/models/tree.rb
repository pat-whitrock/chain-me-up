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

  def final_history
    construct_history << self
  end

  def construct_history
    # self.history << self
    if !self.parent_tree.nil?
      [ self.parent_tree.construct_history ]
    end
    self.history
  end

  def construct_history(id)
    if self.parent_tree.nil?
      parent_id = self.parent_tree.id
      self.history << 
      construct_history(parent_id)
    end


    #construct_history(tree.id)

end


=begin
 
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