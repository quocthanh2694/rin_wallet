import 'package:flutter/material.dart';
import 'package:rin_wallet/src/services/auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(title: const Text('Local Authentication Example')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.lock, size: size.width * 0.3),
              const SizedBox(height: 20),
              const Text(
                  'Tap on the button to authenticate with the device\'s local authentication system.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.black,
                  )),
              const SizedBox(height: 30),
              SizedBox(
                width: size.width,
                child: TextButton(
                  onPressed: () async {
                    bool isAuthenticated = await AuthService.authenticateUser();
                    if (isAuthenticated) {
                      print('authenticated');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Authentication failed.'),
                        ),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Colors.blue,
                    shadowColor: const Color(0xFF323247),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'LOGIN WITH BIOMETRICS',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          wordSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
