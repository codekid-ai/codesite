import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationComponent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        decoration: BoxDecoration(
            color: Colors.black, border: Border.all(color: Colors.white)),
        child: ExpansionTile(
          title: const Text('Navigation'),
          children: [
            ListTile(
                title: const Text('Move'),
                trailing: Image.asset('../../assets/arrow_key.png',
                    width: 30, height: 30)),
            ListTile(
              title: const Text('Move element'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Shift + '),
                  Image.asset('../../assets/arrow_key.png',
                      width: 30, height: 30),
                ],
              ),
            ),
            ListTile(
              title: const Text('Resize element'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('AltLeft + '),
                  Image.asset('../../assets/arrow_key.png',
                      width: 30, height: 30),
                ],
              ),
            )
          ],
        ),
      );
}
