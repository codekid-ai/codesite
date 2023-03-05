import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codekid/editor/coding_panel.dart';
import 'package:flutter/material.dart';
import 'package:codekid/controls/doc_field_text_edit.dart';

class Sandbox extends StatelessWidget {
  const Sandbox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: Colors.grey,
                )),
            child: Text('hi')
            //CodingPanel('YKOkpTjeSUzXzy7xKCKx')
            ));
  }
}
