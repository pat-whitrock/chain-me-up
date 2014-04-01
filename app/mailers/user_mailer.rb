class UserMailer < ActionMailer::Base
  default from: 'from@chainmeup.com'

  def invite_friends(link, to, from)
    @link = link
    @to = to
    @from = from
    # binding.pry
    mail(from: from.email, to: to, subject: 'Welcome to My Awesome Site').deliver
  end

end