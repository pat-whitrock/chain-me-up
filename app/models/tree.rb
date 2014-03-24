require 'benchmark'

class Tree
  include Mongoid::Document

  embeds_many :branches, :class_name => "Tree", :cyclic => true
  embedded_in :root, :class_name => "Tree", :cyclic => true
  
  belongs_to :creator, :class_name => "User", :inverse_of => :roots
  belongs_to :contributor, :class_name => "User", :inverse_of => :branches

  field :title, type: String
  field :content, type: String

  def traverse_parents(&block)
    yield self
    if !self.root.nil?
      self.root.traverse_parents(&block)
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
    branches.each { |child| queue << child }
    while queue.size > 0
      tree = queue.shift
      if tree._id == id 
        goal = tree
        break
      elsif tree.has_children?
        tree.branches.each { |child| queue << child }
      end
    end
    goal 
  end

  def get_all_children
    Hash(self.attributes)
  end

  def has_children?
    !!self.branches
  end
  
end