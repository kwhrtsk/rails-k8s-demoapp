App.cable.subscriptions.create(
  { channel: "NotificationChannel" },
  { received: function(data) { location.reload() } }
)
