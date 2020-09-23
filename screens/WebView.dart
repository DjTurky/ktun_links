import 'package:flutter/material.dart';
import 'package:KTUN/models/Website.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:KTUN/utils/UIHelper.dart';

class WebViewContainer extends StatefulWidget {
  Website website;

  WebViewContainer(this.website);

  @override
  createState() => _WebViewContainerState(this.website);
}

class _WebViewContainerState extends State<WebViewContainer> {
  Website website;
  _WebViewContainerState(this.website);

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: website.url,
      appBar: AppBar(
        backgroundColor: UIHelper.colorBackground,
        title: Text(website.name, style: UIHelper.textTitle),
      ),
    );
  }
}
