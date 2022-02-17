import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  RxBool isConnected = true.obs;

  Future<bool> checkNetwork() async {
    bool networkStatus = false;
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        networkStatus = true;
      }
    } on SocketException catch (_) {
      networkStatus = false;
    }
    return networkStatus;
  }

  ConnectivityController() {
    Connectivity().onConnectivityChanged.listen((status) async {
      isConnected.value = await _getNetworkStatus();
      print('****************Internet ${isConnected.value}****************');
    });
  }

  Future<bool> _getNetworkStatus() async {
    return await checkNetwork();
  }
}
