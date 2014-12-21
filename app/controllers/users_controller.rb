class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy] # Listings 9.12 | 9.32 | 9.53
  before_action :correct_user,   only: [:edit, :update] # Listing 9.22
  before_action :admin_user,     only: :destroy
  # Listing 9.33
  def index
    # @users = User.all
    @users = User.paginate(page: params[:page]) # Listing 9.42
  end
  # -----------------


  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      #  UserMailer.account_activation(@user).deliver_now # Listing 10.19.            REMOVED in Listing 10.32
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url

      # The following has been replaced with the UserMailer action above for account activation (Listing 10.19).
      # log_in @user # Section 8.2.5 / Listing 8.22 
      # flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  # Listing 9.5
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

    # Listing 9.53
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Listing 9.12
    # Before filters

    #Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location # Listing 9.28 -- See sessions_helper.rb for definition
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Listing 9.22
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      # redirect_to(root_url) unless @user == current_user # Old way.
      redirect_to(root_url) unless current_user?(@user) # New way -- Lising 9.25
    end

    # Listing 9.54
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
