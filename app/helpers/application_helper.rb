module ApplicationHelper
  NAV_LINK_STYLES = "hover:bg-slate-700 py-4 px-2 md:rounded-md flex gap-2 \
                     md:px-6 w-full pl-8 md:pl-2".freeze
  ICON_STYLES =     "w-6 h-6 inline-block".freeze

  def nav_link_to(path:, icon:, text:)
    link_to path, class: NAV_LINK_STYLES do
      inline_svg_tag(icon, ICON_STYLES) +
        content_tag(:p, text, class: "md:hidden xl:block")
    end
  end
end
