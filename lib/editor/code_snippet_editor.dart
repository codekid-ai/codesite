import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codekid/editor/code_viewer.dart';
import 'package:codekid/editor/eval_example.dart';
import 'package:codekid/editor/multi_line_text_field.dart';
import 'package:codekid/editor/run_output.dart';
import 'package:codekid/main.dart';
import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eval/flutter_eval.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:js';

import '../common.dart';
import 'globals.dart';

// f() {
//   print('hi');
// }

class CodeSnippetEditor extends ConsumerWidget {
  final DocumentReference docRef;
  final codeCtrl = TextEditingController();

  CodeSnippetEditor({required this.docRef, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          Flexible(
              child: Row(
            children: [
              Expanded(child: MultiLineTextField(
                onSubmitted: (v) {
                  print('submitted');
                  docRef.update({'code': v});
                },
              )),
              Expanded(child: CodeViewer(docRef: docRef)),
            ],
          )),
          Expanded(
              child: Row(
            children: [
              RunOutput(docRef: docRef),
              // SizedBox(width: 300, height: 800, child: EvalExample()),
              ElevatedButton(
                  onPressed: () async {
                    final doc = await docRef
                        .get(); //.add({'code': 'print("hello world")'});
                    addAvatarHandler('move', '()=>{' + doc['code'] + '}'
                        //'()=> {  avatar.moveBy(1,1); }'
                        //'()=> { console.log("lala");} '
                        );
                  },
                  child: Text('Register javascript')),
              ElevatedButton(
                  onPressed: () {
                    print('move');
                    final a = Avatar();
                    callAvatarHandler('move');
                  },
                  child: Text('Run javascript')),
              ElevatedButton(
                  onPressed: () async {
                    final l = test;

                    final doc = await docRef
                        .get(); //.add({'code': 'print("hello world")'});

                    // print(eval('2 + 2')); // -> 4

                    final program = '''
                      class Avatar {
                        String a = 'lol';
                        void moveLeft() {
                          //print('moved Left');
                        }
                      }

                      class Cat {
                        Cat(this.name);
                        final String name;
                        String speak(str) {

                          return 'Meow! My name is \$name and I say \$str';
                        }
                      }
                      String main(String str, String avatar, Object o) {
                        final cat = Cat('Fluffy');
                        print('move');
                        print(avatar);
                        print(o);
                        print(f);

                        //Avatar av= o as Avatar;
                        print(o.a);
                        // print(o.moveLeft);
                        //o.moveLeft();
                        print('moved');
                        return cat.speak(str);
                      }
                    ''';

                    final avatar = Avatar();
                    final Object o = avatar;
                    // print(o.a);
                    print((o as Avatar).a);

                    f() {
                      print('f');
                    }

                    // print(eval(program, function: 'main'));
                    final res = eval(
                        //doc['code'],
                        program,
                        function: 'main',
                        args: [
                          $String('word'),
                          $Object({'hi': 'hi'}),
                          $Object(avatar),
                          // $Object(f),
                        ]).toString();

                    // final res = eval("test1").toString();
                    print(res);
                    doc.reference.update({'result': res});
                  },
                  child: Text('Run')),
            ],
          ))
        ],
      );
}
