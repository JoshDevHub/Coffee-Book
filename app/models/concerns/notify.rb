module Notify
  extend ActiveSupport::Concern

  def notify(sender, recipient)
    notifications.create(
      user: recipient,
      message: "#{sender.name} #{notification_action}",
      url: notification_path
    )
  end
end
