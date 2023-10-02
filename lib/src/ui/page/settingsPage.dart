import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rin_wallet/src/base/db.dart';
import 'package:rin_wallet/src/models/cart.dart';
import 'package:rin_wallet/src/models/catalog.dart';
import 'package:rin_wallet/src/services/sharedPreferences.service.dart';
import 'package:rin_wallet/src/ui/page/walletDetailPage.dart';
import 'package:image_cropper/image_cropper.dart';

class Test {
  int id = 0;
  String name = 'Hello';
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class SettingPage extends StatefulWidget {
  const SettingPage({
    super.key,
  });

  getItems() {
    var jsonData = new Test();

    return jsonData;
  }

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int _counter = 0;
  File? imageFile;
  var dbHelper = new DbHelper();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _addToCart() {
    var cart = context.read<CartModel>();
    cart.add(new Item(1, 'Abc'));
  }

  void _navigateToSetting() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WalletDetailPage()),
    );
  }

  _requestPermission() async {
    var status = await Permission.manageExternalStorage.status;
    if (status!.isRestricted) {
      status = await Permission.manageExternalStorage.request();
    }

    if (status!.isDenied) {
      status = await Permission.manageExternalStorage.request();
    }
    if (status!.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content:
            Text('Please add permission for app to manage external storage'),
      ));
    }
    await Permission.storage.request();
  }

  _onRestoreDb() async {
    await _requestPermission();
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    String? path = result?.files.single.path;

    if (path != null) {
      dbHelper.restoreDB(path);
    }
  }

  _onBackupDb() async {
    await _requestPermission();

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) return;

    dbHelper.backupDB(selectedDirectory);
  }

  @override
  Widget build(BuildContext context) {
    var data = SettingPage().getItems();
    var jsonData = data.toJson();

    return Scaffold(
      // appBar: BaseAppBar(
      //   title: Text('Settings'),
      //   appBar: AppBar(),
      //   widgets: <Widget>[Icon(Icons.more_vert)],
      // ),
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('Backup DB'),
                  onPressed: () {
                    _onBackupDb();
                  },
                ),
                ElevatedButton(
                  child: const Text('Restore DB'),
                  onPressed: () {
                    _onRestoreDb();
                  },
                ),
                TextButton(
                  onPressed: () => {saveStorage('{a: 1; b: 2}')},
                  child: const Text('Save storage'),
                ),
                TextButton(
                  onPressed: () async {
                    final data = await getStorage();
                    print(data);
                  },
                  child: const Text('Get storage'),
                ),
                TextButton(
                  onPressed: _addToCart,
                  child: const Text('Add item to cart'),
                ),
                TextButton(
                  onPressed: _navigateToSetting,
                  child: const Text('NavigateTo detail wallet'),
                ),
                TextButton(
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                        child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Column(children: <Widget>[
                              SizedBox(height: 15),
                              Text('This is a typical dialog.'),
                              SizedBox(height: 15),
                            ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Close'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Submit'),
                                  )
                                ]),
                          ],
                        ),
                      ),
                    )),
                  ),
                  child: const Text('Show Dialog'),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter your text',
                  ),
                ),
                JsonView.map(
                  jsonData,
                  theme: const JsonViewTheme(
                    backgroundColor: Colors.white,
                    keyStyle: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    doubleStyle: TextStyle(
                      color: Colors.orange,
                      fontSize: 16,
                    ),
                    intStyle: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    stringStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 85, 0),
                      fontSize: 16,
                    ),
                    boolStyle: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                    ),
                    closeIcon: Icon(
                      Icons.arrow_drop_up,
                      color: Colors.green,
                      size: 20,
                    ),
                    openIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.green,
                      size: 20,
                    ),
                    separator: Text(':'),
                  ),
                ),
                Text(jsonEncode(data.toJson())),
                ElevatedButton(
                  child: const Text('Copy json'),
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: jsonEncode(jsonData)));
                    Fluttertoast.showToast(
                        msg: "Coppied!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Container(
                    child: imageFile == null
                        ? Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    _getFromGallery();
                                  },
                                  child: Text("PICK FROM GALLERY"),
                                ),
                                Container(
                                  height: 40.0,
                                ),
                                TextButton(
                                  onPressed: () {
                                    _getFromCamera();
                                  },
                                  child: Text("PICK FROM CAMERA"),
                                )
                              ],
                            ),
                          )
                        : Container(
                            child: Image.file(
                              imageFile!,
                              fit: BoxFit.contain,
                              width: 400,
                              height: 400,
                            ),
                          ))
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  /// Get from gallery
  _getFromGallery() async {
    var pickedFile = (await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    ));
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    var pickedFile = (await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    ));
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      if (croppedFile!.path.isNotEmpty) {
        setState(() => imageFile = File(croppedFile.path as String));
      }
    }
  }
}
