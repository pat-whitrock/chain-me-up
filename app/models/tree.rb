require 'benchmark'

class Tree
  include Mongoid::Document

  recursively_embeds_many 

  # embeds_many :branches, :class_name => "Tree", :cyclic => true
  # embedded_in :root, :class_name => "Tree", :cyclic => true
  
  field :title, type: String
  field :content, type: String
  field :user_id, type: String

  def traverse_parents(&block)
    yield self
    if !self.parent_tree.nil?
      self.parent_tree.traverse_parents(&block)
    end  
  end

  def self.get_trees_by_user(user) 
    where(:id.in => user.trees)
  end

  def history 
    @history ||= construct_history 
  end

  def get_history
    history = []
    self.traverse_parents do |node|
      history << node
    end
    history
  end

  def get_root
    current_node = self
    if !self.parent_tree.nil? 
      while !current_node.parent_tree.nil?
        current_node = current_node.parent_tree
      end
    end  
    current_node
  end

  def construct_history
    history_array = get_history.reverse
    story = ""
    title = nil
    history_array.each_with_index do |branch, index|
      story << branch.content + " "
      if index == 0
        title = branch.title
      end
    end
    {:title => title, :content => story.strip}
  end

  def find_branch(branch_id)
    id = BSON::ObjectId.from_string(branch_id)
    goal = nil
    queue = [] 
    child_trees.each { |child| queue << child }
    while queue.size > 0
      tree = queue.shift
      if tree._id == id 
        goal = tree
        break
      elsif tree.has_children?
        tree.child_trees.each { |child| queue << child }
      end
    end
    goal 
  end

  def find_branch_by_user(user_id)
    goal = nil
    queue = [] 
    child_trees.each { |child| queue << child }
    while queue.size > 0
      tree = queue.shift
      if tree.user_id == user_id 
        goal = tree
        break
      elsif tree.has_children?
        tree.child_trees.each { |child| queue << child }
      end
    end
    goal 
  end

  def bind_user(user)
    self.user_id = user.id.to_s
    user.trees << self.get_root.id.to_s 
    user.save  
  end

  def get_all_children
    Hash(self.attributes)
  end

  def has_children?
    !!self.child_trees
  end
  
end