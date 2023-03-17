import 'dart:html';

import 'package:flutter/material.dart';

Widget buildIFrameNativeWidget() {
  var element = IFrameElement()
    ..width = '640'
    ..height = '360'
    ..src = 'https://www.youtube.com/embed/dQw4w9WgXcQ';

  return HtmlElementView(
    viewType: 'iframe-html-view',
    key: UniqueKey(),
  );
}

class IFrameHtmlElement extends HtmlElement {
  static void register() {
    document.registerElement('iframe-html-view', IFrameHtmlElement,
        extendsTag: 'iframe');
  }

  IFrameHtmlElement.created() : super.created();
}
