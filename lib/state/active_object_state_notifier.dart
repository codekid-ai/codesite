import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'generic_state_notifier.dart';

class SelectedObjectStateNotifier extends StateNotifier<Map<String, dynamic>?> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final dbInstance = FirebaseFirestore.instance;

  final int? activeCellLeft;
  final int? activeCellTop;
  final String objectColPath;

  SelectedObjectStateNotifier(
      this.activeCellLeft, this.activeCellTop, this.objectColPath)
      : super(null) {
    final activeCellL = activeCellLeft;
    final activeCellT = activeCellTop;

    if (activeCellL == null || activeCellT == null) {
      print('no active cell L or T');
      state = null;
      return;
    }

    FirebaseFirestore.instance
        .collection(objectColPath)
        .snapshots()
        .listen((objects) {
      print('check col: ${objectColPath}');

      final object = objects.docs.firstWhere((el) =>
          activeCellL >= el.data()['left'] &&
          (activeCellL < el.data()['left'] + el.data()['width']) &&
          activeCellT >= el.data()['top'] &&
          (activeCellT < el.data()['top'] + el.data()['height']));

      print('found item: ${object.id}');
      state = {'id': object.id, 'data': object.data()};
    });
  }
  void setSelectedObject(Map<String, dynamic>? object) {
    state = object;
  }
}
