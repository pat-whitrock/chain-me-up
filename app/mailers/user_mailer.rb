class UserMailer < ActionMailer::Base
  default from: 'from@chainmeup.com'

  def invite_friends
    mail(from: 'from@chainmeup.com', to: 'mayergeorgep@gmail.com', subject: 'Welcome to My Awesome Site')
  end

end