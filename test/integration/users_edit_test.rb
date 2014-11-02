# Listing 9.6

require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user) # Listing 9.14
    get edit_user_path(@user)
    patch user_path(@user), user: { name:  '',
                                    email: 'foo@invalid',
                                    password:              'foo',
                                    password_confirmation: 'bar' }
    assert_template 'users/edit'
  end

  # Listing 9.8 - See accompanying code in controllers/users_controller.rb
  # test "successful edit" do
  #   log_in_as(@user) # Listing 9.14
  #   get edit_user_path(@user)
  #   name = "Foo Bar"
  #   email = "foo@bar.com"
  #   patch user_path(@user), user: { name: name, email: email, password: "", password_confirmation: "" }
  #   assert_not flash.empty?
  #   assert_redirected_to @user
  #   @user.reload
  #   assert_equal @user.name, name
  #   assert_equal @user.email, email
  # end

  # Listing 9.26
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: { name: name, email: email, password: "", password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end
end
