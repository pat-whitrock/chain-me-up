class Prompt
  include Mongoid::Document
  field :content, type: String

  def self.random_sample(n)
    Prompt.all.sample(n)
  end
end
