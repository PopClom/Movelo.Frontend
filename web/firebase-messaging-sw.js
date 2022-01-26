importScripts('https://www.gstatic.com/firebasejs/9.6.3/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.6.3/firebase-messaging-compat.js');

   /*Update with yours config*/
  const firebaseConfig = {
   apiKey: "AIzaSyDsWnT1HypUtmu3V5pazE1bU3NtDNNdwW8",
   authDomain: "movelo-27642.firebaseapp.com",
   projectId: "movelo-27642",
   storageBucket: "movelo-27642.appspot.com",
   messagingSenderId: "1087559493788",
   appId: "1:1087559493788:web:2819b7390ac37b2b11a559"
  };
  firebase.initializeApp(firebaseConfig);
  const messaging = firebase.messaging();