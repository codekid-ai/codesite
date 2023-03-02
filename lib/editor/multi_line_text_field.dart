import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MultiLineTextField extends StatefulWidget {
  final Function? onSubmitted;
  MultiLineTextField({this.onSubmitted, super.key});

  @override
  _MultiLineTextFieldState createState() => _MultiLineTextFieldState();
}

class _MultiLineTextFieldState extends State<MultiLineTextField> {
  final _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
        if (event.isControlPressed &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          print('Ctrl + Enter pressed!');
          if (widget.onSubmitted != null)
            widget.onSubmitted!(_textFieldController.text);
        }
      },
      child: TextField(
        controller: _textFieldController,
        maxLines: 5,
        decoration: InputDecoration(
          labelText: 'Enter your text here',
        ),
      ),
    );
  }
}

// TextField(
//   // Define a controller to get the text value of TextField
//   controller: _textFieldController,
//   // Wrap TextField with RawKeyboardListener to listen for key events
//   child: RawKeyboardListener(
//     focusNode: FocusNode(), // Use a FocusNode to receive key events
//     onKey: (RawKeyEvent event) {
//       // Check if the Ctrl key and Enter key were pressed simultaneously
//       if (event.isControlPressed && event.logicalKey == LogicalKeyboardKey.enter) {
//         // Do something here
//         print('Ctrl + Enter pressed!');
//       }
//     },
//     child: TextFormField(
//       // Add other properties as needed
//       decoration: InputDecoration(
//         labelText: 'Enter your text here',
//       ),
//     ),
//   ),
// )