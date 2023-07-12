import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intermec_printer/constants.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Printer Controller for Honeywell Printers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
          title: 'Printer Controller App for Honeywell Printer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _connected = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  final TextEditingController _writeController = TextEditingController();

  static const MethodChannel _channel = const MethodChannel('IntermecPrint');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Divider(
                  thickness: 3,
                  indent: 10,
                  endIndent: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.02,
                    child: Text("Connect device via bluetooth"),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Text(
                      'Device:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Expanded(
                      child: DropdownButton(
                        items: _getDeviceItems(),
                        onChanged: (BluetoothDevice? value) =>
                            setState(() => _device = value),
                        value: _device,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        initPlatformState();
                      },
                      icon: Icon(Icons.refresh),
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Divider(
                  thickness: 3,
                  indent: 10,
                  endIndent: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 9,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.lightBlueAccent.shade100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "First of all, Select your device and connect the printer"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: false,
                            child: CircularProgressIndicator(
                            ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width*0.08,),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: _device == null
                                      ? Colors.black
                                      : (_connected ? Colors.red : Colors.green)),
                              onPressed: () {
                                _device == null
                                    ? null
                                    : (_connected
                                        ? {_disconnect, Disconnect()}
                                        : {
                                            CreatePrinter(Constants.deviceName, _device!.address!),
                                            _load()
                                          });
                              },
                              child: Text(_device == null
                                  ? 'Select Device'
                                  : (_connected
                                      ? 'Disconnect'
                                      : 'Connect Printer'))),
                          SizedBox(width: MediaQuery.of(context).size.width*0.08,),
                          Visibility(
                            visible: _isLoading,
                            child: CircularProgressIndicator(
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 3,
                  indent: 10,
                  endIndent: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      //CreatePrinter(Constants.deviceName, "bt://00:1D:DF:58:0D:3D");
                      NewLine(4);
                      WriteGraphicBase64(
                          Constants.graphic64Code, 0, 180, 220, 70);
                      NewLine(1);
                      Write(
                          "                 SHIRIKA LA TELI TANZANIA         ");
                      NewLine(2);
                      setBold(true);

                      Write("Trip No" + " : " + "TrainID");
                      NewLine(2);

                      Write("Journey Name" +
                          " : " +
                          "Station name" +
                          " - " +
                          "Landing station name");
                      NewLine(2);

                      Write("PassengerID" + " : " + "PenaltyID");
                      NewLine(2);

                      Write("PassengerName" + " : " + "Username");
                      NewLine(2);

                      Write("PenaltyDate: Time-TrainID");
                      NewLine(2);

                      Write("PenaltyType: PenaltyReason");
                      NewLine(2);

                      Write("PenaltyAmount: X TL");
                      NewLine(2);

                      Write("Description: Penalty Description");
                      NewLine(2);

                      Write("Issued By: " + "IssuedByXXX");
                      NewLine(3);
                      NewLine(4);
                    },
                    child: Text("Print Ticket")),
                Divider(
                  thickness: 3,
                  indent: 10,
                  endIndent: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      NewLine(3);
                    },
                    child: Text("Add New Line")),
                Divider(
                  thickness: 3,
                  indent: 10,
                  endIndent: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      WriteGraphicBase64(
                          // PRINT IMAGE FUNCTION
                          Constants.graphic64Code, //BASE64 CODE OF THE IMAGE
                          0, // ROTATION DEGREE MUST BE 0,90,180 OR 270
                          180, // OFFSET FROM THE LEFT HAND SIDE OF THE PAGE
                          220, // GRAPHIC WIDTH
                          250 // GRAPHIC HEIGHT
                          );
                    },
                    child: Text("Write Graphic Base 64")),
                Divider(
                  thickness: 3,
                  indent: 10,
                  endIndent: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: TextFormField(
                        controller: _writeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter text';
                          }
                          return null;
                        },
                        onChanged: (String text) {},
                        decoration: const InputDecoration(
                          hintText: 'Enter text to print..',
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Write(_writeController.text);
                        },
                        child: Text("Write")),
                  ],
                ),
                SizedBox(height: 10),
                Divider(
                  thickness: 3,
                  indent: 10,
                  endIndent: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(flex: 1, child: Center(child: Text("Set Bold"))),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  setBold(true);
                                },
                                child: Text("Yes")),
                            ElevatedButton(
                                onPressed: () {
                                  setBold(false);
                                },
                                child: Text("No")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 3,
                  indent: 10,
                  endIndent: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1, child: Center(child: Text("Set Compress"))),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  setCompress(true);
                                },
                                child: Text("Yes")),
                            ElevatedButton(
                                onPressed: () {
                                  setCompress(false);
                                },
                                child: Text("No")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 3,
                  indent: 10,
                  endIndent: 10,
                ),
                Divider(
                  thickness: 3,
                  indent: 10,
                  endIndent: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Center(child: Text("Set DoubleHigh"))),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  setDoubleHigh(true);
                                },
                                child: Text("Yes")),
                            ElevatedButton(
                                onPressed: () {
                                  setDoubleHigh(false);
                                },
                                child: Text("No")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 3,
                  indent: 10,
                  endIndent: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Center(child: Text("Set DoubleWide"))),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  setDoubleWide(true);
                                },
                                child: Text("Yes")),
                            ElevatedButton(
                                onPressed: () {
                                  setDoubleWide(false);
                                },
                                child: Text("No")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 3,
                  indent: 10,
                  endIndent: 10,
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name ?? ""),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device != null) {
      bluetooth.isConnected.then((isConnected) {
        if (isConnected == true) {
          bluetooth.connect(_device!).catchError((error) {
            print("connect error iddiası");
            setState(() => _connected = false);
          });
          print(_device!.name);
          print("    ");
          print(_device!.address);
          CreatePrinter(Constants.deviceName, _device!.address!);
          setState(() => _connected = true);
        }
      });
    } else {
      show('No device selected.');
    }
  }

  void _load() {
    setState(() => _isLoading = true);
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = false);
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }

  Future<dynamic> CreatePrinter(String PrinterID, String PrinterUri) async {
    final String resCreate = await _channel.invokeMethod('CreatePrinter', {
      "PrinterID": PrinterID,
      "PrinterUri": PrinterUri,
    });

    return resCreate;
  }

  Future<dynamic> Write(String index) async {
    final String resWrite = await _channel.invokeMethod('Write', {
      "index": index,
    });
    return resWrite;
  }

  Future<dynamic> NewLine(int lineSpace) async {
    final String resNewLine = await _channel.invokeMethod('NewLine', {
      "lineSpace": lineSpace,
    });
    return resNewLine;
  }

  Future<dynamic> WriteGraphicBase64(String aBase64Image, int aRotation,
      int aXOffset, int aWidth, int aHeight) async {
    final String resGraphic64 =
        await _channel.invokeMethod('WriteGraphicBase64', {
      "aBase64Image": aBase64Image,
      "aRotation": aRotation,
      "aXOffset": aXOffset,
      "aWidth": aWidth,
      "aHeight": aHeight,
    });
    return resGraphic64;
  }

  Future<dynamic> WriteTicket(
    String ticketDesign,
  ) async {
    final String resTicket = await _channel.invokeMethod('WriteTicket', {
      "ticketDesign": ticketDesign,
    });
    return resTicket;
  }

  Future<dynamic> setBold(bool isTrue) async {
    final String resSetBold = await _channel.invokeMethod('setBold', {
      "isTrue": isTrue,
    });
    return resSetBold;
  }

  Future<dynamic> setCompress(bool isTrue) async {
    final String resSetCompress = await _channel.invokeMethod('setCompress', {
      "isTrue": isTrue,
    });
    return resSetCompress;
  }

  Future<dynamic> setItalic(bool isTrue) async {
    final String resSetItalic = await _channel.invokeMethod('setItalic', {
      "isTrue": isTrue,
    });
    return resSetItalic;
  }

  Future<dynamic> setDoubleHigh(bool isTrue) async {
    final String resSetDoubleHigh =
        await _channel.invokeMethod('setDoubleHigh', {
      "isTrue": isTrue,
    });
    return resSetDoubleHigh;
  }

  Future<dynamic> setUnderline(bool isTrue) async {
    final String resSetDoubleHigh =
        await _channel.invokeMethod('setUnderline', {
      "isTrue": isTrue,
    });
    return resSetDoubleHigh;
  }

  Future<dynamic> setStrikeout(bool isTrue) async {
    final String resSetDoubleHigh =
        await _channel.invokeMethod('setUnderline', {
      "isTrue": isTrue,
    });
    return resSetDoubleHigh;
  }

  Future<dynamic> setDoubleWide(bool isTrue) async {
    final String resSetDoubleWide =
        await _channel.invokeMethod('setDoubleWide', {
      "isTrue": isTrue,
    });
    return resSetDoubleWide;
  }

  Future<dynamic> Disconnect() async {
    final String resDisconnect = await _channel.invokeMethod('Disconnect');
    return resDisconnect;
  }

  Future<dynamic> Close() async {
    final String resClose = await _channel.invokeMethod('Close');
    return resClose;
  }

  Future<void> initPlatformState() async {
    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            _isLoading = false;
            print("bluetooth device state: connected");
            show("Successfully Connected!");
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnected");
          });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnect requested");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning off");
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth off");
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth on");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning on");
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            _connected = false;
            print("bluetooth device state: error");
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected == true) {
      setState(() {
        _connected = true;
      });
    }
  }
}
