import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'common.dart';

class SignalProcessor {
  static registerSignal(String s) {
    kDB.collection(s).snapshots().listen((event) {
      print('SignalProcessor: received ${event.docs.length}');
    });
  }
}

//colSP
// Provider autoDisposeStateProviderSP<T>(T Function() create) =>
//     AutoDisposeStateProvider<T>(
//       (ref) {
//         return create();
//         // final qs = ref.watch(qsProvider);
//         // SignalProcessor.registerSignal(qs);
//         // return create();
//       },
//       'signals',
//     );

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final collectionProvider =
    StreamProvider.autoDispose.family<QS, String>((ref, path) {
  final firestore = ref.watch(firestoreProvider);
  return firestore.collection(path).snapshots();
});
