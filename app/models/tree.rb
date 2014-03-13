class Tree
  include Mongoid::Document

  field :content, type: String
  field :children, type: Array, default: -> {[]}



end