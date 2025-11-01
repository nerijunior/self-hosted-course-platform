require "test_helper"

class LessosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lesso = lessos(:one)
  end

  test "should get index" do
    get lessos_url
    assert_response :success
  end

  test "should get new" do
    get new_lesso_url
    assert_response :success
  end

  test "should create lesso" do
    assert_difference("Lesso.count") do
      post lessos_url, params: { lesso: { course_id: @lesso.course_id, filename: @lesso.filename, name: @lesso.name, unit_id: @lesso.unit_id } }
    end

    assert_redirected_to lesso_url(Lesso.last)
  end

  test "should show lesso" do
    get lesso_url(@lesso)
    assert_response :success
  end

  test "should get edit" do
    get edit_lesso_url(@lesso)
    assert_response :success
  end

  test "should update lesso" do
    patch lesso_url(@lesso), params: { lesso: { course_id: @lesso.course_id, filename: @lesso.filename, name: @lesso.name, unit_id: @lesso.unit_id } }
    assert_redirected_to lesso_url(@lesso)
  end

  test "should destroy lesso" do
    assert_difference("Lesso.count", -1) do
      delete lesso_url(@lesso)
    end

    assert_redirected_to lessos_url
  end
end
