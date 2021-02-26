require "test_helper"

class AfksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @afk = afks(:one)
  end

  test "should get index" do
    get afks_url
    assert_response :success
  end

  test "should get new" do
    get new_afk_url
    assert_response :success
  end

  test "should create afk" do
    assert_difference('Afk.count') do
      post afks_url, params: { afk: {  } }
    end

    assert_redirected_to afk_url(Afk.last)
  end

  test "should show afk" do
    get afk_url(@afk)
    assert_response :success
  end

  test "should get edit" do
    get edit_afk_url(@afk)
    assert_response :success
  end

  test "should update afk" do
    patch afk_url(@afk), params: { afk: {  } }
    assert_redirected_to afk_url(@afk)
  end

  test "should destroy afk" do
    assert_difference('Afk.count', -1) do
      delete afk_url(@afk)
    end

    assert_redirected_to afks_url
  end
end
