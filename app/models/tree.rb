require 'benchmark'

class Tree
  include Mongoid::Document

  recursively_embeds_many

  field :user_id, type: Integer
  field :content, type: String
  field :title, type: String

  def traverse_parents(&block)
    yield self
    if !self.parent_tree.nil?
      self.parent_tree.traverse_parents(&block)
    end  
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

  def get_all_children
    Hash(self.attributes)
  end

  def has_children?
    !!self.children
  end
  
end