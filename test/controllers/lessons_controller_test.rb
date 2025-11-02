require "test_helper"

class LessonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lesson = lessons(:one)
    @unit = @lesson.unit
    @course = @unit.course
    @user = users(:one)
    sign_in_as(@user)
  end

  test "should get index" do
    get course_unit_lessons_url(@course, @unit)
    assert_response :success
  end

  test "should get new" do
    get new_course_unit_lesson_url(@course, @unit)
    assert_response :success
  end

  test "should create lesson" do
    assert_difference("Lesson.count") do
      post course_unit_lessons_url(@course, @unit), params: { lesson: { unit_id: @lesson.unit_id, filename: @lesson.filename, name: @lesson.name } }
    end

    assert_redirected_to course_unit_lesson_url(@course, @unit, Lesson.last)
  end

  test "should show lesson" do
    get course_unit_lesson_url(@course, @unit, @lesson)
    assert_response :success
  end

  test "should get edit" do
    get edit_course_unit_lesson_url(@course, @unit, @lesson)
    assert_response :success
  end

  test "should update lesson" do
    patch course_unit_lesson_url(@course, @unit, @lesson), params: { lesson: { unit_id: @lesson.unit_id, filename: @lesson.filename, name: @lesson.name } }
    assert_redirected_to course_unit_lesson_url(@course, @unit, @lesson)
  end

  test "should destroy lesson" do
    assert_difference("Lesson.count", -1) do
      delete course_unit_lesson_url(@course, @unit, @lesson)
    end

    assert_redirected_to course_unit_lessons_url(@course, @unit)
  end
end
