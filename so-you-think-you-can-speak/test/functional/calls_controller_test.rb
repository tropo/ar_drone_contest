require 'test_helper'

class CallsControllerTest < ActionController::TestCase
  setup do
    @call = calls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:calls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create call" do
    assert_difference('Call.count') do
      post :create, :call => @call.attributes
    end

    assert_redirected_to call_path(assigns(:call))
  end

  test "should show call" do
    get :show, :id => @call.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @call.to_param
    assert_response :success
  end

  test "should update call" do
    put :update, :id => @call.to_param, :call => @call.attributes
    assert_redirected_to call_path(assigns(:call))
  end

  test "should destroy call" do
    assert_difference('Call.count', -1) do
      delete :destroy, :id => @call.to_param
    end

    assert_redirected_to calls_path
  end
end
