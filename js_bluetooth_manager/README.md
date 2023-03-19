<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

A JSBluetoothManager helps in scanning and connecting to peripherals along with discovering charecterstics of the bluetooth.Also helps in notify, write, read based on the bluetooth charecterstic.This is developed for private projects which might help others in understanding the flow of Bluetooth Connections, Sending and receiving data etc.

## Features
Connects to Pheripheral device.
Discovering Pheripheral device charecterstics.
Based on charecterstics found it performs the following action
 1. Write encrypted data to charecterstic 
 2. Read encryted data from charecterstic value and decrypts the value to human readable message
 3. Notify the listners on subscribing to a charecterstic and reads the charecterstic value

## Getting started

To Understand the library you need to have basic knowledge on Dart Programming language and Bluetooth Pheripherals connectivity and the usage.It doesn't work on emulators.You require a real device and a Bluetooth Device to test it.

Note: The bluetooth device should have a proper firmware which supports encryption or any kind of sending and receiving data.

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
