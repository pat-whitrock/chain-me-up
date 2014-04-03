class UserMailer < ActionMailer::Base
  default from: 'from@chainmeup.com'

  def invite_friends(invitation, to, from, history)
    @invitation = invitation
    @to = to
    @from = from
    @history = history
    # binding.pry
    mail(from: from.email, to: to, subject: "You've been invited to contribute to a story").deliver
  end

end