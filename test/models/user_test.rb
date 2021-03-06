require 'test_helper'
# presence, length, format and uniqueness

  class UserTest < ActiveSupport::TestCase
    # Tests here apply to the user.rb file under app/models
    def setup
      @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
    end

    # VALIDATION OF USER
    test "should be valid" do
      assert @user.valid?
    end

    # PRESENCE VALIDATION
    test "name should be present" do
      @user.name = "    "
      assert_not @user.valid?
    end

    test "email should be present" do
      @user.email = "    "
      assert_not @user.valid?
    end

    # LENGTH VALIDATION
    test "name should not be too long" do
      @user.name = "a" * 51     # string multiplication
      assert_not @user.valid?
    end

    test "email should not be too long" do
      @user.email = "a" * 256
      assert_not @user.valid?
    end

    # FORMAT VALIDATION
    test "email validation should accept valid addresses" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alce+bob@baz.cn]
      valid_addresses.each do |valid_address|
        @user.email = valid_address
        assert @user.valid?, "#{valid_address.inspect} should be valid"
      end
    end

    test "email validation should reject invalid addresses" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.xom]
      invalid_addresses.each do |invalid_address|
        @user.email = invalid_address
        assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
      end
    end

    # UNIQUENESS VALIDATION
    test "email addresses should be unique" do
      duplicate_user = @user.dup                  # duplicates the user
      duplicate_user.email = @user.email.upcase   # Tests case-insensitive email uniqueness by upcasing duplicate email address.
      @user.save                                  # saves the duplicate user to the database
      assert_not duplicate_user.valid?
    end

    # MINIMUM PASSWORD LENGTH
    test "password should have a minimum length" do
      # compact multiple assignment -- This arranges to assign a particular value to the password and its confirmation at the same time.
      @user.password = @user.password_confirmation = "a" * 5
      assert_not @user.valid?
    end

    test "authenticated? should return false for a user with nil digest" do
      assert_not @user.authenticated?(:remember, '')
    end

    test "associated microposts should be destroyed" do 
      @user.save
      @user.microposts.create!(content: "Lorem ipsum")
      assert_difference 'Micropost.count', -1 do 
        @user.destroy
      end
    end

    # Listing 8.43  See Listing 10.25 above for new test method.
    # test "authenticated? should return false for a user with nil digest" do
    #   assert_not @user.authenticated?('')
    # end

    # BEGIN - Listing 12.9
    test "should follow and unfollow a user" do
      michael  = users(:michael)
      archer   = users(:archer)
      assert_not michael.following?(archer)
      michael.follow(archer)
      assert michael.following?(archer)
      assert archer.followers.include?(michael)
      michael.unfollow(archer)
      assert_not michael.following?(archer)
    end
    # END - Listing 12.9

    # Listing 12.41 - A test for the status feed.
    test "feed should have the right posts" do
      michael = users(:michael)
      archer  = users(:archer)
      lana    = users(:lana)
      #Posts from followed user
      lana.microposts.each do |post_following|
        assert michael.feed.include?(post_following)
      end
      # Posts from self
      michael.microposts.each do |post_self|
        assert michael.feed.include?(post_self)
      end
      # Posts from unfollowed user
      archer.microposts.each do |post_unfollowed|
        assert_not michael.feed.include?(post_unfollowed)
      end
    end
  end
