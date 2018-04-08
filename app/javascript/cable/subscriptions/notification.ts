import cable from '../cable';

cable.subscriptions.create(
  "NotificationChannel",
  {
    connected: function() {
      console.log("[connected] notification channel");
    },
    disconnected: function() {
      console.log("[disconnected] notification channel");
    },
    received: function(data: any) {
      console.log(`[received] notification channel: ${data}`);
      location.reload();
    },
  },
)