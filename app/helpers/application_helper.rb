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

  def markdown(text)
    options = {
      filter_html: true,
      hard_wrap: true,
      link_attributes: { rel: 'nofollow', target: "_blank" },
      autolink: true,
      space_after_headers: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true,
      tables: true,
      underline: true,
      highlight: true,
      no_intra_emphasis: true,
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end

  def prettify_hashtags(text)
    text.gsub(/(\B#\w\w+)/, '<span class="tag">\1</span>').html_safe;
  end
end
