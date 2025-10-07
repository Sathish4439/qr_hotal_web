class EndPoints {
  static const String baseUrl = "http://192.168.0.8:8000/api/admin";

  //--------------------customer----------
//menu
  static const String menu = "$baseUrl/menu";
  static const String getMenu = "$menu/getMenu";
//order
  static const String customer = "$baseUrl/customer";
  static const String orders = "$baseUrl/orders";
  static const String createOrder = "$baseUrl/orders/createOrder";
  static const String getOrdersByCustomerId = "$baseUrl/orders/getOrdersByCustomerId";
  static const String createCustomer = "$customer/createCustomer";

//cart
  static const String cart = "$baseUrl/cart";
  static const String createCart = "$cart/createCart";
  static const String getCart = "$cart/getCart";
  static const String deleteCart = "$cart/deleteCart";
  static const String updateCart = "$cart/updateCart";
  static const String clearCart = "$baseUrl/orders/clearCart";

//fcm
  static const String vapKey =
      "BGvYqjjJi7Do3ncDV3Hm4JPcyLpJ7dHbOFpON7-A1K4NWZKGKsJTIXy_FMSD7QkfopFaGRMK9hPxXVcU4oqoEFs";

  static const String apiKey = "AIzaSyDjmU9b7trS15dH-amLSYWf349Q0EIpbS0";
  static const String projectId = "dhigrowth-hotal-managamenet";
  static const String storageBucket = "dhigrowth-hotal-managamenet.appspot.com";
  static const String messagingSenderId = "24097679071";
  static const String appId = "1:24097679071:web:09dce1e92aab1cf7e4ab6a";
  static const String measurementId = "G-SVN25C6H0P";
}


/*

// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyDjmU9b7trS15dH-amLSYWf349Q0EIpbS0",
  authDomain: "dhigrowth-hotal-managamenet.firebaseapp.com",
  projectId: "dhigrowth-hotal-managamenet",
  storageBucket: "dhigrowth-hotal-managamenet.firebasestorage.app",
  messagingSenderId: "24097679071",
  appId: "1:24097679071:web:09dce1e92aab1cf7e4ab6a",
  measurementId: "G-SVN25C6H0P"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
 */