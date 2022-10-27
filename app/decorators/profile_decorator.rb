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

    list_item_for("Gender: #{gender.capitalize}")
  end

  def display_age
    return "" unless birthday

    list_item_for("Age: #{age_at(Time.now.utc.to_date)}")
  end

  def display_location
    return "" unless location

    list_item_for("Location: #{location}")
  end

  private

  def list_item_for(content)
    helpers.content_tag(:li, content)
  end
end
