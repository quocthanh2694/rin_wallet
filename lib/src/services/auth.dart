import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class AuthService {
  static Future<bool> authenticateUser() async {
    //initialize Local Authentication plugin.
    final LocalAuthentication _localAuthentication = LocalAuthentication();

    //status of authentication.
    bool isAuthenticated = false;

    final bool canAuthenticateWithBiometrics =
        await _localAuthentication.canCheckBiometrics;

    //check if device supports biometrics authentication.
    bool isBiometricSupported = await _localAuthentication.isDeviceSupported();
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || isBiometricSupported;

    List<BiometricType> biometricTypes =
        await _localAuthentication.getAvailableBiometrics();

    print(canAuthenticate);
    print("@@@@@@");
    print(isBiometricSupported);
    print(biometricTypes);

    //if device supports biometrics, then authenticate.
    if (canAuthenticate) {
      try {
        isAuthenticated = await _localAuthentication.authenticate(
            localizedReason: 'To continue, you must complete the biometrics',
            // options: const AuthenticationOptions(biometricOnly: true)
            // biometricOnly: true,
            // useErrorDialogs: true,
            // stickyAuth: true
            );
      } on PlatformException catch (e) {
        if (e.code == auth_error.notAvailable) {
          print('no hardware');
        } else if (e.code == auth_error.notEnrolled) {
          // ...
        } else {
          // ...
        }
      }
    }

    return isAuthenticated;
  }
}
