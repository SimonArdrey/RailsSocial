module ApplicationHelper
  def active_class(link_path)
    current_page?(link_path) ? "is-active" : ""
  end

  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end
end
