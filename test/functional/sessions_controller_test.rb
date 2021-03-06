require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  setup do
    @user = User.create(
      provider: 'provider',
      uid: 'uid',
      name: 'name',
      email: 'email@example.com'
    )
  end

  teardown do
    @user.destroy
  end

  test 'should get new' do
    get :new, params: { provider: 'github' }
    assert_redirected_to '/auth/github'
  end

  test 'should get create' do
    User.expects(:find_by_omniauth).returns(@user)
    @user.expects(:update_omniauth_attributes!)

    get :create, params: { provider: 'github' }
    assert_equal @user.id, session[:user_id]
    assert_redirected_to root_url
    assert_equal 'Signed in.', flash[:notice]
  end

  test 'should get destroy' do
    get :destroy
    assert_nil session[:user_id]
    assert_redirected_to root_url
    assert_equal 'Signed out.', flash[:notice]
  end

  test 'should get failure' do
    get :failure, params: { message: 'failure message' }
    assert_nil session[:user_id]
    assert_redirected_to root_url
    assert_equal 'Authentication error. Failure message.', flash[:alert]
  end

  test 'should handle failure when no message passed' do
    get :failure
    assert_nil session[:user_id]
    assert_redirected_to root_url
    assert_equal 'Authentication error. Unexpected error.', flash[:alert]
  end
end
