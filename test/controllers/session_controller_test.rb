require 'test_helper'

class SessionControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should login" do
    alexandra = users(:one)
    post :create, name: alexandra.name, password: 'secret'
    assert_redirected_to admin_url
    assert_equal alexandra.id, session[:user_id]
  end

  test "should fail login" do
    alexandra = users(:one)
    post :create, name: alexandra.name, password: 'blah'
    assert_redirected_to login_url
  end
  
  test "should get destroy" do
    delete :destroy
    assert_redirected_to store_url
  end

end
