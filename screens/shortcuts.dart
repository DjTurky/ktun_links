import 'package:KTUN/models/website.dart';
import 'package:KTUN/screens/webview.dart';
import 'package:KTUN/utils/UIHelper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ShortCuts extends StatefulWidget {
  GlobalKey<NavigatorState> navKey;
  ShortCuts(this.navKey);

  @override
  _ShortCutsState createState() => _ShortCutsState(navKey);
}

class _ShortCutsState extends State<ShortCuts> {
  List<Website> websites = List<Website>();
  GlobalKey<NavigatorState> navKey;
  bool loading = true;
  String connectionProtocol = "https";

  _ShortCutsState(this.navKey);

  @override
  void initState() {
    readDocument();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? _buildLoadingBar
        : Column(children: <Widget>[
            Expanded(
                child: ListView.builder(
                    itemCount: websites.length,
                    itemBuilder: (context, index) {
                      return _createShortcut(websites[index]);
                    }))
          ]);
  }

  Widget _createShortcut(Website website) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
            color: UIHelper.colorCard,
            border: Border.all(color: UIHelper.colorBorder)),
        child: Column(
          children: [
            ListTile(
              leading: Icon(website.isWebsite ? Icons.link : Icons.textsms,
                  color: Colors.white),
              title: Text(
                  website.isWebsite ? website.name : website.name.substring(1),
                  style: UIHelper.textTitle),
              subtitle: Text(website.isOpenable ? website.url : website.desc,
                  style: UIHelper.textSubtitle),
            ),
            if (website.isOpenable)
              Text(website.desc,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                  textAlign: TextAlign.center),
            if (website.isOpenable)
              ButtonBar(
                alignment: MainAxisAlignment.start,
                children: [
                  FlatButton(
                    textColor: UIHelper.colorPaleText,
                    onPressed: () {
                      Navigator.push(
                          navKey.currentState.overlay.context,
                          MaterialPageRoute(
                              builder: (context) => WebViewContainer(website)));
                    },
                    child: const Text('Uygulamada Aç'),
                  ),
                  if (website.isOpenable)
                    FlatButton(
                      textColor: UIHelper.colorPaleText,
                      onPressed: () {
                        _launchBrowser(website.url);
                      },
                      child: const Text('Tarayıcıda Aç'),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  //Launch url
  void _launchBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Widget get _buildLoadingBar => SafeArea(
          child: Column(children: [
        Image.asset("assets/images/launcher_icon.png"),
        Image.asset("assets/images/loading.gif")
      ]));

  void readDocument() {
    http
        .read(
            'https://gist.githubusercontent.com/oSoloTurk/905444356d948997abad20974dca901d/raw/')
        .then((contents) {
      websites.clear();
      List<String> response = contents.split(",");
      for (int i = 0; i < response.length; i += 3) {
        websites.add(Website(response[i], response[i + 1], response[i + 2],
            !response[i].startsWith("!"), !response[i + 1].startsWith("!")));
      }
      setState(() {
        loading = false;
      });
    });
  }
}
