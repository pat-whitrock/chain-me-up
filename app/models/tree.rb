require 'pry'

class Tree
  include Mongoid::Document
  include Mongoid::Tree

  field :user_id, type: Integer
  field :content, type: String

  def construct_history
    self.ancestors_and_self.collect do |node|
      node.content
    end.join(" ")
  end

  def set_children
    @children = {}
  end

  # def view_children(hash)
  #   self.children.each do |child|
  #     hash[self] << child      
  #     hash = hash[self]
  #     view_children(hash[child])
  #   end
  # end

# { 0 : [Tree1,Tree2,Tree3], 
  
#}

  end

  def has_children?
    !!self.children
  end
  
end