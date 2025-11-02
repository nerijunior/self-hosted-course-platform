module ApplicationHelper
  def text_field(object_name, method, options = {})
    options[:class] = [ options[:class], "input" ]
    super(object_name, method, options)
  end
end
