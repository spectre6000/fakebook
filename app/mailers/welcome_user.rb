class WelcomeUser < ApplicationMailer

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Thank you for signing up for Fakebook!')
  end
end
