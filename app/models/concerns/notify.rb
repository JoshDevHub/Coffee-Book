module Notify
  extend ActiveSupport::Concern

  def notify(sender, recipient)
    notifications.create(
      user: recipient,
      message: notify_message_from(sender.name),
      url: self.class::NOTIFICATION_PATH
    )
  end

  def notify_message_from(sender)
    "#{sender} #{self.class::NOTIFICATION_ACTION}"
  end
end
