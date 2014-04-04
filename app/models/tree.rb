require 'benchmark'

class Tree
  include Mongoid::Document
  include Mongoid::Timestamps
  before_save :wrap_content

  recursively_embeds_many 
  
  field :title, type: String
  field :content, type: String
  field :user_id, type: String
  field :contributor_count, type: Integer, default: 0
  field :prompt

  def history 
    @history ||= construct_history 
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
    self.get_root.contributor_count += 1
    self.get_root.save
    user.save  
  end

  def get_all_children
    self.attributes
  end

  def has_children?
    !!self.child_trees
  end


  def self.get_trees_by_user(user) 
    where(:id.in => user.trees)
  end

  private

  def construct_history
    history_array = get_parents.reverse
    story = ""
    title = nil
    history_array.each_with_index do |branch, index|
      story << branch.content + " "
      if index == 0
        title = branch.title
      end
    end
    story = prompt + story if prompt
    {:title => title, :content => story.strip}
  end

  def get_parents
    history = []
    traverse_parents do |node|
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

  def wrap_content
    self.content = self.content.gsub("\n", "<br/>")
  end
  
end