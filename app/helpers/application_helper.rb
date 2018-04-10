module ApplicationHelper
  def navbar_item(name, path, options = {})
    options = options.merge(
      class: "#{options[:class]} nav-link".strip,
      wrap_tag: "li",
      wrap_class: "nav-item",
    )
    active_link_to(name, path, options)
  end
end
