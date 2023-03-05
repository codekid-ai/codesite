import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
// Import the language & theme
import 'package:highlight/languages/dart.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/javascript.dart';

import '../common.dart';

class SimpleCodeEditor extends StatefulWidget {
  final DR docRef;
  final String field;

  const SimpleCodeEditor({Key? key, required this.docRef, required this.field})
      : super(key: key);
  @override
  _SimpleCodeEditorState createState() => _SimpleCodeEditorState();
}

class _SimpleCodeEditorState extends State<SimpleCodeEditor> {
  CodeController _ctrl = CodeController(
    text: '',
    //language: javascript,
    language: dart,
    // theme: monokaiSublimeTheme,
    //theme: monokaiSublimeTheme,
  );
  Timer? descSaveTimer;
  StreamSubscription? sub;

  @override
  void initState() {
    super.initState();
    sub = widget.docRef.snapshots().listen((event) {
      if (!event.exists) return;
      print('received ${event.data()![widget.field]}');
      if (_ctrl.text != event.data()![widget.field]) {
        _ctrl.text = event.data()![widget.field];
      }
    });

    // final source = "void main() {\n    print(\"Hello, world!\");\n}";
    // Instantiate the CodeController
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
    if (sub != null) {
      sub!.cancel();
      sub = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CodeField(
      controller: _ctrl,
      textStyle: TextStyle(fontFamily: 'SourceCode'),
      onChanged: (v) {
        if (descSaveTimer != null && descSaveTimer!.isActive) {
          descSaveTimer!.cancel();
        }
        descSaveTimer = Timer(Duration(milliseconds: 2000), () {
          // if (docSnapshot.data() == null ||
          //     v != docSnapshot.data()![widget.field]) {
          Map<String, dynamic> map = {};
          map[widget.field] = v;
          // the document will get created, if not exists
          widget.docRef.set(map, SetOptions(merge: true));
          // throws exception if document doesn't exist
          //widget.docRef.update({widget.field: v});
          // }
        });
      },
    );
  }
}
