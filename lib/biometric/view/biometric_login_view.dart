import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_repositories_list/biometric/vm/biometric_methods.dart';
import 'package:github_repositories_list/biometric/vm/biometric_state_contoller.dart';
import 'package:github_repositories_list/connectivity/connectivity_controller.dart';
import 'package:github_repositories_list/utils/custom_colors.dart';
import 'package:lottie/lottie.dart';

class BiometricLogin extends StatefulWidget {
  const BiometricLogin({Key? key}) : super(key: key);

  @override
  _BiometricLoginState createState() => _BiometricLoginState();
}

class _BiometricLoginState extends State<BiometricLogin> {
  late BiometricStateController _controller;
  @override
  void initState() {
    _controller = Get.put(BiometricStateController());
    BiometricMethods.initLocalAuth();
    checkNet();
    super.initState();
  }

  void checkNet() async {
    final _controller = Get.find<ConnectivityController>();
    _controller.isConnected.value = await _controller.checkNetwork();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: CustomColors.firebaseNavy,
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Biometric Login',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white),
              ),
              const SizedBox(height: 100),
              _getFingerprintGIF(),
              const SizedBox(height: 100),
              Visibility(
                visible: _controller.biometricState.value ==
                        BIOMETRIC_STATE.normal ||
                    _controller.biometricState.value == BIOMETRIC_STATE.failed,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10)),
                  onPressed: () async {
                    _controller.startAuth();
                  },
                  child: Text(
                    _getBtnName(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              Visibility(
                visible: _controller.biometricState.value ==
                    BIOMETRIC_STATE.checking,
                child: const CircularProgressIndicator(),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getFingerprintGIF() {
    switch (_controller.biometricState.value) {
      case BIOMETRIC_STATE.success:
        return Lottie.asset('assets/right-fingerprint.json');
      case BIOMETRIC_STATE.failed:
        return Lottie.asset('assets/wrong-fingerprint.json');
      case BIOMETRIC_STATE.checking:
        return Lottie.asset('assets/checking-fingerprint.json',
            height: 120, width: 120);
      case BIOMETRIC_STATE.normal:
      default:
        return Image.asset('assets/normal-fingerprint.png',
            height: 120, width: 120);
    }
  }

  String _getBtnName() {
    if (_controller.biometricState.value == BIOMETRIC_STATE.failed) {
      return 'Retry Authenticate';
    } else {
      return 'Authenticate';
    }
  }
}
