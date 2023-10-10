import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:rin_wallet/src/services/auth.dart';
import 'package:rin_wallet/src/ui/layout/baseAppBar.dart';

class LoginPage extends StatefulWidget {
  final onChangeAuthenticate;
  const LoginPage({Key? key, required dynamic this.onChangeAuthenticate})
      : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.grey.shade300,
      appBar: const BaseAppBar(title: 'Authentication'),
      body: ListView(
        children: [
          Center(
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
                    child: ElevatedButton(
                      onPressed: () async {
                        bool isAuthenticated =
                            await AuthService.authenticateUser();
                        if (isAuthenticated) {
                          print('authenticated');
                          if (widget.onChangeAuthenticate != null) {
                            widget.onChangeAuthenticate(true);
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Authentication failed.'),
                            ),
                          );
                        }
                      },
                      // style: TextButton.styleFrom(
                      //   padding: const EdgeInsets.all(20),
                      //   backgroundColor: Colors.blue,
                      //   shadowColor: const Color(0xFF323247),
                      // ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Login with Face/TouchID',
                            // style: TextStyle(
                            //   fontSize: 15,
                            //   color: Colors.white,
                            //   fontWeight: FontWeight.w600,
                            //   wordSpacing: 1.2,
                            // ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  const Text('Or with passsword'),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          label: Text(
                            'Password',
                            textAlign: TextAlign.center,
                          ),
                          hintText: 'Enter password here'),
                      onEditingComplete: () {
                        if (passwordController.text == null) {
                          return;
                        }
                        var bytes = utf8.encode(
                            'pa9284fi304u0P*@(' + passwordController.text);
                        var res = md5.convert(bytes);
                        if (res.toString() == 'e1cf77dcd65231c20dcbad0d642af14c') {
                          passwordController.clear();
                          if (widget.onChangeAuthenticate != null) {
                            widget.onChangeAuthenticate(true);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              duration: Duration(milliseconds: 1000),
                              backgroundColor: Colors.green,
                              content: Text('Successfully logged in!'),
                            ));
                          }
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            duration: Duration(milliseconds: 1000),
                            backgroundColor: Colors.red,
                            content: Text('Wrong password!'),
                          ));
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
