require "test_helper"

class UnitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @unit = units(:one)
    @course = @unit.course
    @user = users(:one)
    sign_in_as(@user)
  end

  test "should get index" do
    get course_units_url(@course)
    assert_response :success
  end

  test "should get new" do
    get new_course_unit_url(@course)
    assert_response :success
  end

  test "should create unit" do
    assert_difference("Unit.count") do
      post course_units_url(@course), params: { unit: { course_id: @unit.course_id, name: @unit.name, path: @unit.path } }
    end

    assert_redirected_to course_unit_url(@course, Unit.last)
  end

  test "should show unit by redirecting to first lesson" do
    # The fixture unit has a lesson, so it should redirect
    get course_unit_url(@course, @unit)
    assert_response :redirect
    assert_redirected_to course_unit_lesson_url(@course, @unit, @unit.lessons.first)
  end

  test "should return not found for unit without lessons" do
    # Create a unit without lessons to test the 404 behavior
    unit_without_lessons = Unit.create!(course: @course, name: "Test Unit", path: "/test/path")
    get course_unit_url(@course, unit_without_lessons)
    assert_response :not_found
  end

  test "should get edit" do
    get edit_course_unit_url(@course, @unit)
    assert_response :success
  end

  test "should update unit" do
    patch course_unit_url(@course, @unit), params: { unit: { course_id: @unit.course_id, name: @unit.name, path: @unit.path } }
    assert_redirected_to course_unit_url(@course, @unit)
  end

  test "should destroy unit" do
    assert_difference("Unit.count", -1) do
      delete course_unit_url(@course, @unit)
    end

    assert_redirected_to course_units_url(@course)
  end
end
