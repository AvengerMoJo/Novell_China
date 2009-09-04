require 'test_helper'

class SitsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:sits)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_sit
    assert_difference('Sit.count') do
      post :create, :sit => { }
    end

    assert_redirected_to sit_path(assigns(:sit))
  end

  def test_should_show_sit
    get :show, :id => sits(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => sits(:one).id
    assert_response :success
  end

  def test_should_update_sit
    put :update, :id => sits(:one).id, :sit => { }
    assert_redirected_to sit_path(assigns(:sit))
  end

  def test_should_destroy_sit
    assert_difference('Sit.count', -1) do
      delete :destroy, :id => sits(:one).id
    end

    assert_redirected_to sits_path
  end
end
