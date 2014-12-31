class UserMailer < ActionMailer::Base
  default from: "noreply@example.com"

  def account_activation(user) # Listing 10.9
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def password_reset(user)  #Listing 10.41 -- (user) was not previously included. Prior lines commented out.
  	@user = user
  	mail to: user.email, subject: "Password reset"
    # @greeting = "Hi"
	# mail to: "to@example.org"
  end
end
