import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';
import 'package:sim_data/sim_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ussd_service/ussd_service.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/*Future<void> launchUssd(String ussdCode) async {
  Ussd.runUssd(ussdCode);
}*/

class _HomeScreenState extends State<HomeScreen> {
  bool _scanning = false;
  String _extractText = '';
  File _pickedImage;
  ImagePicker imagePicker;
  String Number = '';
  int flag = 0;
  bool _value = false;
  int val = -1;
  File croppedFile;
  String ussdResponseMessage = "";
  SimData simData;
  String Numberafter;
  int Card_type = 0;
  int Card_way = 0;

  int c = 0;
  /*get_sim_data() async {
    simData = await SimDataPlugin.getSimData();
  }*/

  makeMyRequest(String code) async {
    int subscriptionId = 1; // sim card subscription ID
    // ussd code payload
    try {
      ussdResponseMessage = await UssdService.makeRequest(
        subscriptionId,
        code,
        Duration(seconds: 10), // timeout (optional) - default is 10 seconds
      );
      print("succes! message: $ussdResponseMessage");
      Fluttertoast.showToast(
          msg: "$ussdResponseMessage",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey[350],
          textColor: Colors.black);
    } catch (e) {
      debugPrint("error! code: ${e.code} - message: ${e.message}");
    }
  }

  _importtake(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Get the picture of the card"),
            actions: <Widget>[
              new FlatButton(
                child: new Text('import from gallery'),
                onPressed: () {
                  c = 1;
                  takephoto();
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('use camera'),
                onPressed: () {
                  c = 2;
                  takephoto();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  takephoto() async {
    Number = "";
    setState(() {
      _scanning = true;
    });
    if (c == 1) {
      _pickedImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    } else {
      _pickedImage = await ImagePicker.pickImage(source: ImageSource.camera);
    }
    croppedFile = await ImageCropper.cropImage(
      sourcePath: _pickedImage.path,
      aspectRatio: CropAspectRatio(ratioX: 8.0, ratioY: 1.0),
      maxWidth: 600,
      maxHeight: 600,
    );

    _extractText = await TesseractOcr.extractText(croppedFile.path);
    setState(() {
      _scanning = false;
    });
    for (int i = 0; i < _extractText.length; i++) {
      if (double.tryParse(_extractText[i]) != null) {
        Number = Number + _extractText[i];
      }
    }
    if (val == 1) {
      if (Number.length != 16) {
        Fluttertoast.showToast(
            msg: "يرجى إالتقاط صورة أخرى لكود الكارت",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey[350],
            textColor: Colors.black);
        takephoto();
      }
    } else if (val == 2) {
      if (Number.length != 15) {
        Fluttertoast.showToast(
            msg: "يرجى إالتقاط صورة أخرى لكود الكارت",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey[350],
            textColor: Colors.black);
        takephoto();
      }
    } else if (val == 3) {
      if (Number.length != 14) {
        Fluttertoast.showToast(
            msg: "يرجى إالتقاط صورة أخرى لكود الكارت",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey[350],
            textColor: Colors.black);
        takephoto();
      }
    } else if (val == 4) {
      if (Number.length != 14) {
        Fluttertoast.showToast(
            msg: "يرجى إالتقاط صورة أخرى لكود الكارت",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey[350],
            textColor: Colors.black);
        takephoto();
      }
    }
  }

  TextEditingController _textFieldController = TextEditingController();

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("قم بتعديل الرقم"),
            content: TextField(
              controller: _textFieldController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(hintText: "$Number"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Number = _textFieldController.text.toString();
                  Numberafter = Number;
                },
              )
            ],
          );
        });
  }

  _displayDialogct(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("أختر نوع الكارت"),
            actions: <Widget>[
              new FlatButton(
                child: new Text('كارت شحن'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Card_type = 1;
                  vodafoneCharge(1);
                },
              ),
              new FlatButton(
                child: new Text('كارت فكة'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _displayDialogw1(context);
                },
              ),
              new FlatButton(
                child: new Text('كارت المارد'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _displayDialogw(context);
                },
              )
            ],
          );
        });
  }

  _displayDialogw(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("أختر طريقة شحن الكارت"),
            actions: <Widget>[
              new FlatButton(
                child: new Text('دقايق و ميجابايتس'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Card_way = 1;
                  vodafoneCharge(1);
                },
              ),
              new FlatButton(
                child: new Text('ميجابايت سوشيال و واتس'),
                onPressed: () {
                  Navigator.of(context).pop();

                  Card_way = 2;
                  vodafoneCharge(3);
                },
              ),
            ],
          );
        });
  }

  _displayDialogw1(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("أختر طريقة شحن الكارت"),
            actions: <Widget>[
              new FlatButton(
                child: new Text('دقايق و ميجابايتس'),
                onPressed: () {
                  vodafoneCharge(4);
                  Navigator.of(context).pop();

                  Card_way = 3;
                },
              ),
              new FlatButton(
                child: new Text('ميجابايت سوشيال و واتس'),
                onPressed: () {
                  vodafoneCharge(5);
                  Navigator.of(context).pop();
                  Card_way = 4;
                },
              ),
            ],
          );
        });
  }

  _displayDialoget(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("أختر طريقة شحن الكارت"),
            actions: <Widget>[
              new FlatButton(
                child: new Text('كارت عادي'),
                onPressed: () {
                  etislatCharge(1);
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('ميكسات'),
                onPressed: () {
                  etislatCharge(2);
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('دقايق'),
                onPressed: () {
                  etislatCharge(3);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _displayDialogor(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("أختر طريقة شحن الكارت"),
            actions: <Widget>[
              new FlatButton(
                child: new Text('كارت اورنج اكسترا / فكة'),
                onPressed: () {
                  orangeCharge(1);
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('كارت احسن ناس'),
                onPressed: () {
                  _displayDialogor2(context);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _displayDialogor2(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("أختر طريقة شحن الكارت"),
            actions: <Widget>[
              new FlatButton(
                child: new Text('دقايق'),
                onPressed: () {
                  etislatCharge(2);
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('ميجابايتس'),
                onPressed: () {
                  etislatCharge(3);
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('شحن عادي'),
                onPressed: () {
                  etislatCharge(1);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _askPhonePermission() async {
    if (await Permission.phone.request().isGranted) {
    } else {
      await Permission.phone.request();
    }
  }

  void _askCameraPermission() async {
    if (await Permission.camera.request().isGranted) {
    } else {
      await Permission.camera.request();
    }
  }

  String vCode = "";
  vodafoneCharge(int cardway) async {
    if (cardway == 1) {
      vCode = "*858*" + Number + "#" + ",";
      makeMyRequest(vCode);
    } else if (cardway == 2) {
      vCode = "*1*858*" + Number + "#" + ",";
      makeMyRequest(vCode);
    } else if (cardway == 3) {
      vCode = "*858*2*" + Number + "#" + ",";
      makeMyRequest(vCode);
    } else if (cardway == 4) {
      vCode = "*858*" + Number + "#" + ",";
      makeMyRequest(vCode);
    } else if (cardway == 5) {
      vCode = "*858*4*" + Number + "#" + ",";
      makeMyRequest(vCode);
    }
  }

  etislatCharge(int cardway) async {
    if (cardway == 1) {
      vCode = "*556*" + Number + "#" + ",";
      makeMyRequest(vCode);
    } else if (cardway == 2) {
      vCode = "*556*1*" + Number + "#" + ",";
      makeMyRequest(vCode);
    } else if (cardway == 3) {
      vCode = "*556*2*" + Number + "#" + ",";
      makeMyRequest(vCode);
    }
  }

  orangeCharge(int cardway) async {
    if (cardway == 1) {
      vCode = "*102*" + Number + "#" + ",";
      makeMyRequest(vCode);
    } else if (cardway == 2) {
      vCode = "*1*102*" + Number + "#" + ",";
      makeMyRequest(vCode);
    } else if (cardway == 3) {
      vCode = "*2*102*" + Number + "#" + ",";
      makeMyRequest(vCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.purple[900],
          title: Text(
            'QUICK CARD CHARGE',
          )),
      body: ListView(
        children: [
          _pickedImage == null
              ? Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image,
                    size: 100,
                  ),
                )
              : Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      image: DecorationImage(
                        image: FileImage(croppedFile),
                        fit: BoxFit.fill,
                      )),
                ),
          Column(
            children: <Widget>[
              ListTile(
                title: Text("Vodafone"),
                leading: Radio(
                  value: 1,
                  groupValue: val,
                  onChanged: (value) {
                    setState(() {
                      val = value;
                    });
                  },
                  activeColor: Colors.green,
                ),
              ),
              ListTile(
                title: Text("Etsilat"),
                leading: Radio(
                  value: 2,
                  groupValue: val,
                  onChanged: (value) {
                    setState(() {
                      val = value;
                    });
                  },
                  activeColor: Colors.green,
                ),
              ),
              ListTile(
                title: Text("We"),
                leading: Radio(
                  value: 3,
                  groupValue: val,
                  onChanged: (value) {
                    setState(() {
                      val = value;
                    });
                  },
                  activeColor: Colors.green,
                ),
              ),
              ListTile(
                title: Text("Orange"),
                leading: Radio(
                  value: 4,
                  groupValue: val,
                  onChanged: (value) {
                    setState(() {
                      val = value;
                    });
                  },
                  activeColor: Colors.green,
                ),
              ),
            ],
          ),
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: RaisedButton(
                color: Colors.purple[800],
                child: Text(
                  'التقط/أختر صورة واضحة لكود الكارت',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  _askCameraPermission();
                  if (val == -1) {
                    Fluttertoast.showToast(
                        msg: "يرجي اختيار الشبكه",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.grey[350],
                        textColor: Colors.black);
                  } else {
                    _importtake(context);
                    flag = 1;
                  }
                }),
          ),
          SizedBox(height: 20),
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: RaisedButton(
                color: Colors.purple[800],
                child: Text(
                  'تعديل',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  if (flag == 1) {
                    _displayDialog(context);
                    _textFieldController.text = "$Number";
                  }
                }),
          ),
          Center(
            child: Text(
              _textFieldController.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: RaisedButton(
                color: Colors.purple[800],
                child: Text(
                  'اشحن الكارت',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  // _displayDialogct(context);
                  _askPhonePermission();
                  if (flag == 0) {
                    Fluttertoast.showToast(
                        msg: "يرجي إلتقاط صورة لكود الكارت",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.grey[350],
                        textColor: Colors.black);
                  } else {
                    String vCode;
                    if (val == 1) {
                      _displayDialogct(context);
                    } else if (val == 2) {
                      _displayDialoget(context);
                    } else if (val == 3) {
                      vCode = "*555*" + Number + "#" + ",";
                      makeMyRequest(vCode);
                    } else if (val == 4) {
                      _displayDialogor(context);
                    }
                  }
                }),
          ),

          /* SizedBox(height: 20),
          Center(
            child: Text(
              ussdResponseMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}

class Ussd {
  static const MethodChannel _channel = const MethodChannel('ussd');

  static Future<String> runUssd(String ussdCode) async {
    final String launch =
        await _channel.invokeMethod('runUssd', <String, dynamic>{
      'ussdCode': ussdCode,
    });
    return launch;
  }
}
