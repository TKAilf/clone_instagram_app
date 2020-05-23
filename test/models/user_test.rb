require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end
  
  test "valid sample_user?" do
    assert @user.valid?
  end
  
  test "valid sample_user when name isn't presence?" do
    @user.name = ""
    assert_not @user.valid?
  end
  
  test "valid sample_user when email isn't presence?" do
    @user.email = " "
    assert_not @user.valid?
  end
  
  test "valid sample_user when too long name" do
    @user.name = "a"*51
    assert_not @user.valid?
  end
  
  test "valid sample_user when too long email" do
    @user.email = "a"*244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "email is downcase when email saved" do
    complex_case_email = "Foo@ExAMPle.CoM"
    @user.email = complex_case_email
    @user.save
    assert_equal complex_case_email.downcase, @user.reload.email
  end
  
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "authenticated? method return false when remember_digest nil" do
    assert_not @user.authenticated?(:remember, "")
  end
  
end
