import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/editor/editor_page.dart';

import '../editor/keyboard_processor.dart';
import 'generic_state_notifier.dart';

// class ActiveObjectNotifier extends StateNotifier<String?> {
//   ActiveObjectNotifier(String? d) : super(d);

//   // set value(String v) {
//   //   state = v;
//   // }

//   // String get value => {
//   //   return state;
//   // };

// }

// final activeObject = StateNotifierProvider<ActiveObjectNotifier, String?>(
//     (ref) => ActiveObjectNotifier(null));


// // final activeObjectProviderId = StreamProvider<String?>((ref) {
//   final activeCellL = ref.watch(activeCellLeft);
//   final activeCellT = ref.watch(activeCellTop);

//   var objects = FirebaseFirestore.instance
//       .collection('project/1/page/1/object')
//       .snapshots();

//   if (activeCellL == null || activeCellT == null) {
//     print('no active cell L or T');
//     return Stream.value(null);
//   }

//   return objects
//       .map<String?>((event) => event.docs.fold<String?>(null, (prev, el) {
//             if (prev == null) {
//               if (activeCellL >= el.data()['left'] &&
//                   activeCellL < el.data()['left'] + el.data()['width'] &&
//                   activeCellT >= el.data()['top'] &&
//                   activeCellT < el.data()['top'] + el.data()['height']) {
//                 print('found item: ${el.id}');
//                 return el.id;
//               } else {
//                 return null;
//               }
//             } else {
//               return prev;
//             }
//           }));
// });


// final activeObjectSP = StreamProvider<Map<String, dynamic>?>((ref) {
//   final activeCellL = ref.watch(activeCellLeft);
//   final activeCellT = ref.watch(activeCellTop);

//   var objects = FirebaseFirestore.instance
//       .collection('project/1/page/1/object')
//       .snapshots();

//   if (activeCellL == null || activeCellT == null) {
//     print('no active cell L or T');
//     return Stream.value(null);
//   }

//   return objects.map<Map<String, dynamic>?>(
//       (event) => event.docs.fold<Map<String, dynamic>?>(null, (prev, el) {
//             if (prev == null) {
//               if (activeCellL >= el.data()['left'] &&
//                   (activeCellL < el.data()['left'] + el.data()['width']) &&
//                   activeCellT >= el.data()['top'] &&
//                   (activeCellT < el.data()['top'] + el.data()['height'])) {
//                 print('found item: ${el.id}');
//                 return {'id': el.id, 'data': el.data()};
//               } else {
//                 return null;
//               }
//             } else {
//               return prev;
//             }
//           }));
// });


// final AutoDisposeStreamProviderFamily<String?, String> activeObjectProvider =
//     StreamProvider.autoDispose.family<String?, String>((ref, filter) {
//   final activeCellL = ref.watch(activeCellLeft);
//   final activeCellT = ref.watch(activeCellTop);

//   var objects = FirebaseFirestore.instance
//       .collection('project/1/page/1/object')
//       .snapshots();

//   if (activeCellL == null || activeCellT == null) return Stream.value(null);

//   return objects.map<String?>((event) => event.docs.fold<String?>(
//       null,
//       (prev, el) => prev == null
//           ? (activeCellL >= el.data()['left'] &&
//                   activeCellL < el.data()['left'] + el.data()['width'] &&
//                   activeCellT >= el.data()['top'] &&
//                   activeCellT < el.data()['top'] + el.data()['height']
//               ? el.id
//               : null)
//           : prev));
// });
