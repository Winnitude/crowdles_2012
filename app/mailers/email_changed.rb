class EmailChanged < ActionMailer::Base
  default from: "from@example.com"

  def to_older_email(user)
    @user = user
    mail(:to => @user.email, :subject => "Winnitude Email Changed")
  end

  def to_new_email(user)
    @user= user
    mail(:to => @user.email, :subject => "Winnitude Email Changed")
  end

end
