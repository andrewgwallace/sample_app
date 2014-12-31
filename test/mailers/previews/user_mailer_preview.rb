# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
  	user = User.first  # Listing 10.14
  	user.activation_token = User.new_token
  	UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset # Listing 10.44 - Prior code commented out.
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
    # UserMailer.password_reset
  end

end
