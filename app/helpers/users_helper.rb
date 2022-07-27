module UsersHelper
  def gravatar_url_for(user)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://secure.gravatar.com/avatar/#{gravatar_id}"
  end
end
