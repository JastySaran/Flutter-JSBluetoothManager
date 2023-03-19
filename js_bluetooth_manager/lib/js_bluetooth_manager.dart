library js_bluetooth_manager;

// ignore_for_file: avoid_print, constant_identifier_names
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:io' show Platform;
import 'package:pointycastle/export.dart';

class BluetoothManager {
  /*create FlutterBlue instance*/
  FlutterBlue flutterBlue = FlutterBlue.instance;

  /*use set so that you get unique devices*/
  // ignore: prefer_collection_literals
  Set<ScanResult> listScannedDevice = Set<ScanResult>();

  /*default value when a device is discovered*/
  String connectStatus = "CONNECT";

  /*start discovery of nearby devices*/
  void scanForDevices() async {
    flutterBlue
        .scan(allowDuplicates: true, scanMode: ScanMode.balanced)
        .listen((scanResult) async {
      print("found device:$scanResult");
      //Assigning bluetooth device
      if (scanResult.device.name == 'PSaviour-AT Series1') {
        listScannedDevice.add(scanResult);
        handleConnectDisconnect(listScannedDevice.first);
      }
      //After that we stop the scanning for device
      endDiscoveringPeripheral();
    });
  }

  /*stop scanning nearby devices*/
  void endDiscoveringPeripheral() {
    flutterBlue.stopScan();
  }

/*connect scanned/discovered nearby device*/
  void connect(BluetoothDevice device) async {
    await device.connect();
    discoverServicesAndCharacteristics(device);
  }

/*disconnect connected device*/
  void disConnect(BluetoothDevice device) async {
    await device.disconnect();
  }

  /*start scanning peripherals only if bluetooth is on*/
  void beginDiscoveringPeripheral() {
    //checks bluetooth current state
    FlutterBlue.instance.state.listen((state) {
      if (state == BluetoothState.on) {
        scanForDevices();
      } else {
        print("Your bluetooth is off please turn on to continue");
      }
    });
  }

  discoverServicesAndCharacteristics(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (Platform.isAndroid) {
          await Future.delayed(const Duration(seconds: 1));
          notifyEvent(characteristic);
        } else {
          notifyEvent(characteristic);
        }
      }
    }
  }

  notifyEvent(BluetoothCharacteristic characteristic) async {
    characteristic.value.listen((value) async {
      String strData = String.fromCharCodes(value);
      print("value received $strData");
      List<String> result = strData.split(',');
      //List<double> castedResults = result.map(double.parse).toList();
      print(result);
    });
    await characteristic.setNotifyValue(true);
  }

  handleConnectDisconnect(ScanResult item) async {
    List<BluetoothDevice> connectedDevices = await flutterBlue.connectedDevices;
    if (connectedDevices.contains(item.device)) {
      disConnect(item.device);
      connectStatus = "CONNECT";
    } else {
      connect(item.device);
      connectStatus = "DISCONNECT";
    }
  }

  writeEncryptedValueToBluetooth(
      BluetoothCharacteristic characteristic, String data) {
    final keyBytes =
        List<int>.generate(32, (i) => Random.secure().nextInt(256));
    final key = KeyParameter(keyBytes as Uint8List);
    final plaintextBytes = utf8.encode(data);
    final cipher = BlockCipher('AES')..init(true, key);
    final ciphertextBytes = cipher.process(plaintextBytes as Uint8List);
    final ciphertext = base64.encode(ciphertextBytes);
    print(ciphertextBytes);
    characteristic.write(utf8.encode(ciphertext));
    readDecryptedValueFromBluetooth(characteristic, key);
  }

  readDecryptedValueFromBluetooth(
      BluetoothCharacteristic characteristic, KeyParameter key) async {
    await for (List<int> value in characteristic.value) {
      final response = utf8.decode(value);
      final encryptedBytes = base64.decode(response);
      final decryptCipher = BlockCipher('AES')..init(false, key);
      final decryptedBytes = decryptCipher.process(encryptedBytes);
      final decryptedText = utf8.decode(decryptedBytes);
      print('Received response from Bluetooth: $decryptedText');
    }
  }
}
