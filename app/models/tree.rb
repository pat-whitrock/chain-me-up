require 'pry'

class Tree
  include Mongoid::Document
  include Mongoid::Tree

  field :user_id, type: Integer
  field :content, type: String


  def construct_history
    history_array = ancestors_and_self
    story = ""
    history_array.each do |history|
      story << history.content + " "
    end
    story
  end



end