class AgNotification < ActionMailer::Base
  default from: "from@example.com"

  def registration_confirmation(email)
    mail(:to=>email,:subject=>"AG Registered")
  end
end
