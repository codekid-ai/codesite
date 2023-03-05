import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common.dart';

class Interop {
  static CR? logCol;
  static String? lastMessage;
  static DR? lastMessageDoc;
  static void initLog(CR col) {
    logCol = col;
  }

  static void saveLog(args) {
    // print('saving log: ${args}');
    if (logCol == null)
      print(args);
    else {
      final message = args.join(' ');
      if (message == lastMessage && lastMessageDoc != null) {
        lastMessageDoc!.update({'count': FieldValue.increment(1)});
      } else {
        lastMessage = message;
        logCol!.add({
          'count': 1,
          'timestamp': FieldValue.serverTimestamp(),
          'message': message,
        }).then((d) => {lastMessageDoc = d});
      }
    }
  }

  static void saveLogError(args) {
    // print('saving log: ${args}');
    if (logCol == null)
      print(args);
    else {
      final message = args.join(' ');
      if (message == lastMessage && lastMessageDoc != null) {
        lastMessageDoc!
            .update({'count': FieldValue.increment(1), 'error': true});
      } else {
        lastMessage = message;
        logCol!.add({
          'count': 1,
          'timestamp': FieldValue.serverTimestamp(),
          'message': message,
          'error': true,
        }).then((d) => {lastMessageDoc = d});
      }
    }
  }
}

void avatar_MoveBy(int x, int y) {
  print('dart moved by $x, $y');
  // avatar.moveBy(x, y);
}

void object_MoveBy(int x, int y) {
  print('dart moved by $x, $y');
  // avatar.moveBy(x, y);
}

void myDartFunction(String arg) {
  print('Dart function called with argument: $arg');
}

allowInterops(JsObject context) {
  context['myDartFunction'] = allowInterop(myDartFunction);
  context['avatar_MoveBy'] = allowInterop(avatar_MoveBy);
  context['saveLog'] = allowInterop(Interop.saveLog);
  context['saveLogError'] = allowInterop(Interop.saveLogError);
  //context['keyEvent'] = allowInterop(keyEvent);
}

// keyEvent(JsObject event) {
//   print('keyEvent: ${event['key']}');
// }

// void keyEvent(JsObject event) {
//   // Call a JavaScript function from Dart
//   context.callMethod('keyEvent', [event]);
// }

void sendKeyEvent(RawKeyEvent event) {
  JsObject jsEvent = JsObject.jsify({
    'physicalKey': event.physicalKey.toString(),
    'name': event.physicalKey.debugName,
    'logicalKey': event.logicalKey.keyId,
    'isKeyPressed': event is RawKeyDownEvent,
  });
  context.callMethod('keyEvent', [jsEvent]);
}

void spacePressed() {
  print('space pressed');
  context.callMethod('space');
}

void callEventFunc(name) {
  //print(context.callMethod('window.$name'));
  print(context.callMethod('$name'));
}

void registerEvent(name, handler) {
  context.callMethod('createFunc', [name, handler]);
  print('registered: ${context[name]} under ${name}');
  return;

  //from https://stackoverflow.com/questions/30202951/dart-create-method-from-string
  (new JsObject(context['FunctionObject'], [])).callMethod('fun', [handler]);
  print(
      'registered: ${context['FunctionObject']} under ${name}, ${context[name]}');

  context.callMethod('FunctionObject');
  return;
  // JsFunction myJsFunction =
  // JsFunction.apply(['event'], 'console.log("Hello from JavaScript!");');

  // context[name] = JsFunction.withThis((handler, args) {
  //   // This is a dummy function just to demonstrate that the function was attached correctly
  //   print('${name} func was called!');
  // });
  // print('registered: ${context[name]} under ${name}');
  // Call a JavaScript function from Dart
  //context.callMethod('registerEvent', [key, handler]);
}




// Define the JavaScript function as a string
  // String myJsFunctionString = '''
  //   function myJsFunction() {
  //     console.log('Hello from JavaScript!');
  //   }
  // ''';

  // // Create a JsObject from the string and attach it to the global window object
  // context['window']['myJsFunction'] = JsFunction.withThis((self, args) {
  //   // This is a dummy function just to demonstrate that the function was attached correctly
  //   print('myJsFunction was called!');
  // });

  // // Call the JavaScript function from Dart
  // context.callMethod('window.myJsFunction');
