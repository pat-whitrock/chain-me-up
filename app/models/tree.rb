require 'pry'

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
    history_array = get_history.reverse
    story = ""
    history_array.each do |history|
      story << history.content
    end
    story
  end

  def self.find_by_id(tree_id)
    id = BSON::ObjectId.from_string(tree_id)
    tree = Tree.first
    goal = nil
    queue = [] 
    Tree.first.child_trees.each { |child| queue << child }

    while queue.size > 0
      queue.each do |child|
        if child._id == id 
          goal = child
        elsif child.has_children?
          child.child_trees.each { |child| queue << child }
        end
        queue.shift 
      end
    end
    goal 
  end

  def has_children?
    !!self.child_trees
  end
  


end