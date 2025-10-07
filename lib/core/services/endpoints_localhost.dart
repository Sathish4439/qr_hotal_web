class EndPointsLocalhost {
  // Use localhost instead of ngrok
  static const String baseUrl = "http://localhost:5000/api/admin";

  //--------------------customer----------
//menu
  static const String menu = "$baseUrl/menu";
  static const String getMenu = "$menu/getMenu";
//order
  static const String customer = "$baseUrl/customer";
  static const String createOrder = "$customer/createOrder";
  static const String createCustomer = "$customer/createCustomer";

//cart
  static const String cart = "$baseUrl/cart";
  static const String createCart = "$cart/createCart";
  static const String getCart = "$cart/getCart";
  static const String deleteCart = "$cart/deleteCart";
  static const String updateCart = "$cart/updateCart";
  static const String clearCart = "$cart/clearCart";

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
