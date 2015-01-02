require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_many :user_friendships
  should have_many :friends


  test "a user should enter a first name" do
    user = User.new
    assert !user.save
    assert !user.errors[:first_name].empty?
  end
  
  test "a user should enter a last name" do
    user = User.new
    assert !user.save
    assert !user.errors[:last_name].empty?
  end
  
  test "a user should enter a profile name" do
    user = User.new
    assert !user.save
    assert !user.errors[:profile_name].empty?
  end
  
  test "a user should have a unique profile name" do
    user = User.new
    users(:chris)
    
    assert !user.save
    assert !user.errors[:profile_name].empty?
  end
  
  test "a user should have a profile name without spaces" do
    user = User.new(first_name: 'Chris', last_name: 'Lovell', email: 'chrisl1991@hotmail.co.uk')
    user.password = user.password_confirmation ="password"
    
    user.profile_name = "my profile name with spaces"
    
    assert !user.save
    assert !user.errors[:profile_name].empty?
    assert !user.errors[:profile_name].include?("must  be formatted correctly")
  end
  
  test "a user should have a correctly formatted profile name" do
    user = User.new(first_name: 'Chris', last_name: 'Lovell', email: 'chrisl1991@hotmail.co.uk2')
    user.password = user.password_confirmation ="password"
    
    user.profile_name = "pro-file_1"
    
    assert user.valid?
  end
  
  test "that no error is raised when trying to get to a users friends" do
    assert_nothing_raised do
      users(:chris).friends
    end
  end
  
  test "that creating friendships on a user works" do
    users(:chris).friends << users(:mike)
    users(:chris).friends.reload
    assert users(:chris).friends.include?(users(:mike))
  end
  
  test "that calling to_param on a user returns the profile_name" do
    assert_equal "poly", users(:chris).to_param
  end
  
end
