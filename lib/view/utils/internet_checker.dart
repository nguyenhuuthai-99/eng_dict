import 'package:connectivity_plus/connectivity_plus.dart';

class InternetChecker {
  // Function to check internet connectivity
  static Future<bool> checkInternet() async {
    List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.mobile) &&
        !connectivityResult.contains(ConnectivityResult.wifi)) {
      return false;
    } else {
      return true;
    }
  }
}
