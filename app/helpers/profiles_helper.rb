module ProfilesHelper
  def avatar_url_for(profile)
    if profile.avatar.attached?
      profile.avatar.variant(:thumb)
    else
      gravatar_url_for(profile.user)
    end
  end
end
