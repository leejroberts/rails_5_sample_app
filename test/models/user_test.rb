require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: 'Example User', email: 'user@example.com', 
    password: "foobar", password_confirmation: "foobar")
  end
  
  test 'should be valid' do
    assert @user.valid?
  end
  
  test 'should not be valid without password' do
    @user.password = ''
    @user.password_confirmation = ''
    assert_not @user.valid?
  end
  
  test 'name should be present' do
    @user.name = ""
    assert_not @user.valid?
  end
  
  test 'name should not be too long' do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = ''
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email should accept valid addresses" do
    valid_addresses = %w[user@stuff.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid."
    end
  end
  
  test "email should not accept invalid addresses" do
    invalid_addresses =%w[user@example,com user_at_foo.org user.name@example]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "password should not be blank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  #saves user to db; makes micropost; destroys the user; checks that micropost is destroyed with user
  test 'associated microposts should be destroyed' do
    @user.save #saves the user from the setup (pulled user from fixtures)
    @user.microposts.create!(content: 'lorem ipsum') #makes a micropost
    assert_difference 'Micropost.count', -1 do #quotes are neccesary on Micropost.count. i checked
      @user.destroy
    end
  end
end
