// import 'dart:ui' as ui;ui.platformViewRegistry.registerViewFactory();

// final IFrameElement _iframeElement = IFrameElement();

// _iframeElement.height = '500';
// _iframeElement.width = '500';_iframeElement.src = 'https://www.youtube.com/embed/RQzhAQlg2JQ';
// _iframeElement.style.border = 'none';

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

Widget buildIFrameWidget() {
  var element = IFrameElement()
    ..width = '640'
    ..height = '360'
    ..src =
        // 'https://codekid-ai.github.io/testgame/index.html'
        'https://gkweb-aab07.web.app/#/';

  return HtmlWidget(
    '<div>${element.outerHtml}</div>',
  );
}
