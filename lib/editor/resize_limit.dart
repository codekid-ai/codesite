import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/common.dart';
import 'package:codekid/editor/properties.dart';
import 'package:codekid/state/generic_state_notifier.dart';
import '../state/current_selector.dart';
import 'editor_page.dart';

// create object that has type and max width and max height for each type

class ResizeLimit {
  final String type;
  final double maxWidth;
  final double maxHeight;
  final double minWidth;
  final double minHeight;

  ResizeLimit(
      this.type, this.maxWidth, this.maxHeight, this.minWidth, this.minHeight);
}

// final resizeLimits = [
//   ResizeLimitimage', 1000, 1000, 1, 1),
//   ResizeLimit('button', 1000, 1000, 1, 1),
//   ResizeLimit('checkbox', 5, 5, 1, 1),
//   ResizeLimit('radio', 5, 5, 1, 1),
//   ResizeLimit('dropdown', 1000, 3, 2, 1),
// ];
final ResizeLimits = {
  'image': ResizeLimit('image', 1000, 1000, 1, 1),
  'button': ResizeLimit('button', 1000, 1000, 1, 1),
  'checkbox': ResizeLimit('checkbox', 5, 5, 1, 1),
  'radio': ResizeLimit('radio', 5, 5, 1, 1),
  'dropdown': ResizeLimit('dropdown', 1000, 3, 2, 1),
};
