// Import scripts
importScripts("https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js");

// Your Firebase config
firebase.initializeApp({
  apiKey: "AIzaSyDjmU9b7trS15dH-amLSYWf349Q0EIpbS0",
  authDomain: "dhigrowth-hotal-managamenet.firebaseapp.com",
  projectId: "dhigrowth-hotal-managamenet",
  storageBucket: "dhigrowth-hotal-managamenet.firebasestorage.app",
  messagingSenderId: "24097679071",
  appId: "1:24097679071:web:09dce1e92aab1cf7e4ab6a",
  measurementId: "G-SVN25C6H0P"
});

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage((payload) => {
  console.log("[firebase-messaging-sw.js] Received background message ", payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: "/icons/Icon-192.png"
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
