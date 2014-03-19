require 'pry'

class Tree
  include Mongoid::Document
  include Mongoid::Tree

  field :user_id, type: Integer
  field :content, type: String


  def construct_history
  end

  def has_children?
    !!self.children
  end
  
end