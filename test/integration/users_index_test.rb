# Listing 9.44

require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    # @user = users(:michael)  Removed as pagination test integrated with admin test.
    @admin        = users(:michael) # Listing 9.57
    @non_admin    = users(:archer) # Listing 9.57
  end

  # test "index including pagination" do
  #   log_in_as(@user)
  #   get users_path
  #   assert_select 'div.pagination'
  #   User.paginate(page: 1).each do |user|
  #     assert_select 'a', user.name
  #   end
  # end

  # Listing 9.57
  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a', user.name
    end
    assert_select 'a', text: 'delete'
    user = first_page_of_users.first
    assert_difference 'User.count', -1 do
      delete user_path(user)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
