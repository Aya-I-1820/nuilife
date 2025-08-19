require "test_helper"

class NuisControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get nuis_index_url
    assert_response :success
  end

  test "should get new" do
    get nuis_new_url
    assert_response :success
  end

  test "should get create" do
    get nuis_create_url
    assert_response :success
  end

  test "should get edit" do
    get nuis_edit_url
    assert_response :success
  end

  test "should get update" do
    get nuis_update_url
    assert_response :success
  end

  test "should get show" do
    get nuis_show_url
    assert_response :success
  end
end
