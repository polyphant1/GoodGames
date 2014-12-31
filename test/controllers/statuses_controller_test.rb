require 'test_helper'

class StatusesControllerTest < ActionController::TestCase
  include Devise::TestHelpers 
  
  setup do
    @status = statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:statuses)
  end

  test "should get redirected when not logged in" do
    get :new
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end
  
  test "should render new page when logged in" do
    sign_in users(:chris)
    get :new
    assert_response :success
  end
  
  test "should be logged in to post a status" do
    post :create, status: {context: "Hello" }
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should create status when logged in" do
    sign_in users(:chris)
    
    assert_difference('Status.count') do
      post :create, status: { context: @status.context, name: @status.id }
    end

    assert_redirected_to status_path(assigns(:status))
  end

  test "should show status" do
    get :show, id: @status
    assert_response :success
  end

  test "should be logged in to edit" do
    get :edit, id: @status
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit" do
    sign_in users(:chris)
    get :edit, id: @status
    assert_response :success
  end
  
  test "should be logged in to update" do
    patch :update, id: @status, status: { context: @status.context}
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should update status" do
    sign_in users(:chris)
    patch :update, id: @status, status: { context: @status.context}
    assert_redirected_to status_path(assigns(:status))
  end

  test "should destroy status" do
    assert_difference('Status.count', -1) do
      delete :destroy, id: @status
    end

    assert_redirected_to statuses_path
  end
end
