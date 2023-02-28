import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/bar/app_bar.dart';
import 'package:codekid/common.dart';
import 'package:codekid/state/generic_state_notifier.dart';
import 'package:codekid/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:codekid/resume/resume_list.dart';

final activeResumeBatch =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

final firestoreInstance = FirebaseFirestore.instance;
final TextEditingController jobTitlechCtrl = TextEditingController();
TextEditingController resumeController = TextEditingController();

class UserResumePage extends ConsumerWidget {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: MyAppBar.getBar(context, ref),
      drawer: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
          ? TheDrawer.buildDrawer(context)
          : null,
      body: Container(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: ResumeList()),
                  Expanded(
                      flex: 4,
                      child: TextField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3,
                                color: Color.fromARGB(255, 19, 20, 20)),
                          ),
                        ),
                        autocorrect: true,
                        minLines: 10,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: Theme.of(context).textTheme.headline3,
                        onChanged: (v) {},
                        controller: resumeController,
                      )),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      child: Text(
                        "Add",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: Text('Add job title here'),
                                content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                      controller: jobTitlechCtrl,
                                      onChanged: (v) {},
                                    )),
                                actions: [
                                  TextButton(
                                      child: Text("Add"),
                                      onPressed: () {
                                        print(uid);
                                        if (jobTitlechCtrl.text.isEmpty) return;

                                        //fetchAlbum(searchCtrl.text);
                                        firestoreInstance
                                            .collection("user")
                                            .doc(uid)
                                            .collection("resume")
                                            .add({
                                          'jobTitle': jobTitlechCtrl.text,
                                          'resume':
                                              resumeController.text.toString(),
                                          'timeCreated':
                                              FieldValue.serverTimestamp(),
                                          'author': FirebaseAuth
                                              .instance.currentUser!.uid,
                                        });
                                        jobTitlechCtrl.clear();
                                        Navigator.of(context).pop();
                                      }),
                                  TextButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        jobTitlechCtrl.clear();
                                        Navigator.of(context).pop();
                                      })
                                ],
                              );
                            });
                      })
                ],
              ),

              //
            ],
          )),
    );
  }
}
