module ProfilesHelper
  def avatar_url_for(profile, opts = {})
    size = opts.fetch(:variant, :thumb)
    if profile.avatar.attached?
      profile.avatar.variant(size)
    else
      gravatar_url_for(profile.user, size:)
    end
  end
end
