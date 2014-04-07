require_relative '../spec_helper'

describe Invitation do

	let(:tree) {Tree.create(:title => "Test", :content => "Test content")}

  let(:invitation) {Invitation.create(:email => "testing@test.com", :tree => :tree)}

  let(:user) {create(:user)}

  describe "#create_token" do 
    it "creates a token for the invitation" do
      
    end
  end

end