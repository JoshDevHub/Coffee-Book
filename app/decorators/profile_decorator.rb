module ViewHelpers
  def helpers
    ActionController::Base.helpers
  end

  def routes
    Rails.application.routes.url_helpers
  end
end

class ProfileDecorator < SimpleDelegator
  include ViewHelpers

  def display_gender
    return "" unless gender

    list_item_for(label: "Gender", content: gender.capitalize)
  end

  def display_age
    return "" unless birthday

    list_item_for(label: "Age", content: age_at(Time.now.utc.to_date))
  end

  def display_location
    return "" if location.nil? || location == ""

    list_item_for(label: "Location", content: location)
  end

  private

  def list_item_for(label:, content:)
    helpers.content_tag(:li) do
      item_label(label) + ": #{content}"
    end
  end

  def item_label(label_name)
    helpers.content_tag(:span, label_name, class: "font-bold text-slate-800")
  end
end
