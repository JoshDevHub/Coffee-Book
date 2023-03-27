# frozen_string_literal: true

class ProfileComponent < ViewComponent::Base
  LABEL_CLASSES = "font-bold text-slate-800"

  def initialize(profile:, current_user:)
    @profile = profile
    @current_user = current_user
  end

  private

  attr_reader :profile, :current_user

  def gender
    return "" unless profile.gender

    list_item_for(label_name: "Gender", content: profile.gender.capitalize)
  end

  def age
    return "" unless profile.birthday

    list_item_for(label_name: "Age", content: profile.age_at(Time.now.utc.to_date))
  end

  def location
    return "" if profile.location.blank?

    list_item_for(label_name: "Location", content: profile.location)
  end

  def list_item_for(label_name:, content:)
    label_element = helpers.content_tag(:span, label_name, class: LABEL_CLASSES)

    helpers.content_tag(:li) do
      label_element + ": #{content}"
    end
  end
end
