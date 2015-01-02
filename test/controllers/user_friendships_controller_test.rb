require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase

  context "#new" do
    context "when not logged in" do
      should "redirect to log in page" do
        get :new
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

  
    context "when logged in" do
      setup do
        sign_in users(:chris)  
      end
      
      should "get new and return success" do
        get :new
        assert_response :success
      end
      
      should "set a flash error if the friend_id params is missing" do
        get :new, {}
        assert_equal "Friend required", flash[:error]
      end
      
      should "display friend's name" do
        get :new, friend_id: users(:abi)
        assert_match /#{users(:abi).full_name}/, response.body
      end
      
      should "assign a new user friendship" do
         get :new, friend_id: users(:abi)
         assert assigns(:user_friendship)
      end
      
      should "assign a new user friendship to the correct friend" do
         get :new, friend_id: users(:abi)
         assert_equal users(:abi), assigns(:user_friendship).friend
      end
      
      should "assign a new user friendship to the currently logged in user" do
         get :new, friend_id: users(:abi)
         assert_equal users(:chris), assigns(:user_friendship).user
      end
      
      should "returns 404 status if no friend is found" do
         get :new, friend_id: 'invalid'
         assert_response :not_found
      end
      
      should "ask if you really want to friend the user" do
        get :new, friend_id: users(:abi)
        assert_match /Do you really want to friend #{users(:abi).full_name}?/, response.body
      end
      
    end
  end

  context "#create" do
    context "when not logged in" do
      should "redirect to log in page" do
        get :new
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

  
    context "when logged in" do
      
      setup do
        sign_in users(:chris)
      end
      
      context "with no friend id" do
        setup do
          post :create
        end
        
        should "set the flash error message" do
          assert !flash[:error].empty?
        end
        
        should "redirect to root_path" do
          assert_redirected_to root_path
        end
        
      end
      
      context "with a friend id" do
        setup do
          post :create, user_friendship: { friend_id: users(:abi) }
        end
        
        should "assign a friend object" do
          assert assigns(:friend)
          assert_equal users(:abi), assigns(:friend)
        end
        
        should "assign a user_)friendship object" do
          assert assigns(:user_friendship)
          assert_equal users(:abi), assigns(:user_friendship).friend
          assert_equal users(:chris), assigns(:user_friendship).user
        end
        
        should "create a friendship" do
          assert users(:chris).friends.include?users(:abi)
        end
        
        should "redirect to profile page of friend" do
          assert_response :redirect
          assert_redirected_to profile_path(users(:abi))
        end
        
        should "set the flash success message" do
          assert flash[:success]
          assert_equal "You are now friends with #{users(:abi).full_name}", flash[:success]
        end
      end
    end
  end
end
