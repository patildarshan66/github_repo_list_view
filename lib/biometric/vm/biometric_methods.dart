import 'package:flutter/services.dart';
import 'package:github_repositories_list/utils/ui_helper.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class BiometricMethods {
  static late LocalAuthentication _localAuth;

  static void initLocalAuth() {
    try {
      _localAuth = LocalAuthentication();
    } on PlatformException catch (e) {
      showSnackBar(e.message ?? e.code);
    }
  }

  static Future<bool> checkingForBioMetrics() async {
    try {
      initLocalAuth();
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      return canCheckBiometrics;
    } on PlatformException catch (e) {
      showSnackBar(e.message ?? e.code);
      return false;
    }
  }

  static Future<bool> cancelAuthentication() async {
    try {
      bool isCancelled = await _localAuth.stopAuthentication();
      return isCancelled;
    } on PlatformException catch (e) {
      showSnackBar(e.message ?? e.code);
      return false;
    }
  }

  static Future<bool> authenticate() async {
    try {
      bool isAvailable = await checkingForBioMetrics();
      if (isAvailable) {
        bool didAuthenticate = await _localAuth.authenticate(
            localizedReason: 'Please authenticate to login',
            biometricOnly: true);
        return didAuthenticate;
      } else {
        showSnackBar('Biometric not supported for this device.');
        return false;
      }
    } on PlatformException catch (e) {
      showSnackBar(e.message ?? e.code);
      return false;
    }
  }

  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      List<BiometricType> availableBiometrics =
          await _localAuth.getAvailableBiometrics();
      return availableBiometrics;
    } on PlatformException catch (e) {
      showSnackBar(e.message ?? e.code);
      return [];
    }
  }
}
