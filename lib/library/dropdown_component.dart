import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DropdownComponent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => const ListTile(
      title: DropdownMenu(
        // dummy items
        dropdownMenuEntries: [
          DropdownMenuEntry(value: "dropdown", label: "Dropdown")
        ],
        enableFilter: false,
        enabled: false,
        initialSelection: "dropdown",
      ),
      trailing: Text("Shift+d"));
}
