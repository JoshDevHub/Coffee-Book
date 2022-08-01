module ProfilesHelper
  def avatar_url_for(profile, opts = {})
    variant = opts.fetch(:variant, :thumb)
    if profile.avatar.attached?
      profile.avatar.variant(variant)
    else
      gravatar_url_for(profile.user)
    end
  end
end
