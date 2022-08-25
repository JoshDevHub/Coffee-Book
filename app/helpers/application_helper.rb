module ApplicationHelper
  NAV_LINK_STYLES = "hover:bg-slate-700 py-4 px-2 md:rounded-md flex gap-2 \
                     md:px-6 w-full pl-8 md:pl-2".freeze

  def nav_link_to(path:, icon:, text:)
    link_to path, class: NAV_LINK_STYLES do
      inline_svg_tag(icon, class: "w-6 h-6 inline-block") +
        content_tag(:p, text, class: "md:hidden xl:block")
    end
  end

  def flash_class(level)
    {
      "success" => "bg-green-600",
      "error" => "bg-red-700",
      "alert" => "bg-orange-700",
      "notice" => "bg-green-600"
    }[level]
  end
end
