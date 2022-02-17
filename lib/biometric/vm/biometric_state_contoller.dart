import 'dart:developer';

import 'package:get/get.dart';
import 'package:github_repositories_list/biometric/vm/biometric_methods.dart';
import 'package:github_repositories_list/routes/my_routes_names.dart';
import 'package:github_repositories_list/utils/ui_helper.dart';

enum BIOMETRIC_STATE { normal, success, failed, checking }

class BiometricStateController extends GetxController {
  Rx<BIOMETRIC_STATE> biometricState = BIOMETRIC_STATE.normal.obs;

  Future<void> startAuth() async {
    try {
      biometricState.value = BIOMETRIC_STATE.checking;
      await Future.delayed(const Duration(seconds: 1));
      bool auth = await BiometricMethods.authenticate();
      if (auth) {
        biometricState.value = BIOMETRIC_STATE.success;
        await Future.delayed(const Duration(seconds: 1,milliseconds: 500));
        Get.offAllNamed(MyRoutes.githubRepoList);
      } else {
        biometricState.value = BIOMETRIC_STATE.failed;
      }
    } catch (e) {
      biometricState.value = BIOMETRIC_STATE.failed;
      log(e.toString());
      showSnackBar(e.toString());
    }
  }
}
