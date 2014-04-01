class Invitation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :token
  field :tree
  field :branch
  field :email

  before_save :create_token

  private

  def create_token
    self.token = Digest::MD5.hexdigest("#{tree}#{branch}#{email}")
  end

  def self.find_by_token(token)
    where(:token => token)
  end

end