class Tree
  include Mongoid::Document

  field :first_name, type: String
  field :last_name, type: String
  field :children, type: Array

  def initialize 
    @children = []
  end


end