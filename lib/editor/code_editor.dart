import 'dart:convert';
import 'package:code_editor/code_editor.dart' as ce;
import 'package:codekid/editor/simple_code_editor.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:jiffy/jiffy.dart';
import '../common.dart';
import '../controls/doc_field_text_edit.dart';
import '../controls/doc_multiline_text_field.dart';
import '../interop.dart';
import 'package:flutter_firestore_providers/providers.dart';

class CodeEditor extends ConsumerWidget {
  final DR docRef;
  final DS projectDoc;
  // final controller = CodeController(
  //     text: projectDoc.data()!['codeContext'], // Initial code
  //     language: javascript
  //     // language: Language.dart, // Language
  //     );

  CodeEditor(this.docRef, this.projectDoc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The model used by the CodeEditor widget, you need it in order to control it.
    // But, since 1.0.0, the model is not required inside the CodeEditor Widget.
    ce.EditorModel model = ce.EditorModel(
      files: [
        ce.FileEditor(
          name: "page1.html",
          language: "html",
          code: 'test', // [code] needs a string
        ),
      ], // the files created above
      // you can customize the editor as you want
      styleOptions: ce.EditorModelStyleOptions(
        fontSize: 13,
      ),
    );

    // A custom TextEditingController.
    final myController = TextEditingController(text: 'hello!');

    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
              child: DocFieldTextEdit2(docRef, 'key',
                  decoration: InputDecoration(label: Text('Key')))),
          Expanded(
              child: SizedBox(
                  height: 200,
                  child: Row(
                    children: [
                      Flexible(
                          child: DocMultilineTextField(docRef, 'prompt', 5,
                              decoration: InputDecoration(
                                  label: Text(
                                      'Prompt GPT to write code here...')))),
                      Flexible(
                          child: SizedBox(
                              height: 200,
                              child: SimpleCodeEditor(
                                  docRef: docRef, field: 'code')))
                    ],
                  ))),
          ElevatedButton(
              onPressed: () async {
                docRef.get().then((doc) async {
                  // print(doc.data());
                  if (doc.data()?['prompt'] != null) {
                    final prompt =
                        "${projectDoc.data()?['codeContext']} \n //${doc.data()?['prompt']}";
                    print('generate code for ${prompt}');
                    final userId = kUSR.currentUser!.uid;

                    kDB.doc('user/${userId}').get().then((userDoc) async {
                      final Response response = await http.post(
                          Uri.parse('https://api.openai.com/v1/completions'),
                          headers: {
                            'Content-Type': 'application/json',
                            'Authorization':
                                'Bearer ' + userDoc.data()?['openai_key']
                          },
                          body: jsonEncode({
                            //'model': 'text-davinci-003',
                            'model': 'code-davinci-002',
                            'prompt': prompt,
                            'max_tokens': 30,
                            'temperature': 0,
                            'top_p': 1,
                            'frequency_penalty': 0,
                            'presence_penalty': 0,
                            // 'stop': ["###"],
                            //'n': 1,
                            //'stop': '\n'
                          }));

                      if (response.statusCode == 200) {
                        print(jsonDecode(response.body));
                        docRef.update({
                          'code': jsonDecode(response.body)['choices'][0]
                              ['text']
                        });
                      } else {
                        print(
                            'Request failed with status: ${response.statusCode} ${response.body}.');
                      }
                    });
                  }
                });
              },
              child: Text('Generate code')),
          // DocMultilineTextField(docRef, 'code', 10,
          //     decoration: InputDecoration(label: Text('Write your code here...'))),
          //CodeField(controller: controller),
          // SizedBox(
          //     height: 200,
          //     child: ref.watch(docFP(docRef.path)).when(
          //         data: (code) => SimpleCodeEditor(),
          //         // ce.CodeEditor(
          //         //       model:
          //         //           model, // the model created above, not required since 1.0.0
          //         //       edit: true, // can edit the files ? by default true
          //         //       disableNavigationbar:
          //         //           false, // hide the navigation bar ? by default false
          //         //       onSubmit: (String? language, String? value) {
          //         //         print(value);
          //         //       }, // when the user confirms changes in one of the files
          //         //       // textEditingController:
          //         //       //     myController, // Provide an optional, custom TextEditingController.
          //         //     ),
          //         loading: () => Center(child: CircularProgressIndicator()),
          //         error: (e, s) => Center(child: Text(e.toString())))),
        ]);
  }
}
