import 'package:KTUN/models/image.dart';
import 'package:KTUN/utils/UIHelper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
class TimeTable extends StatefulWidget {
  GlobalKey<NavigatorState> navKey;
  TimeTable(this.navKey);

  @override
  _TimeTableState createState() => _TimeTableState(navKey);
}

class _TimeTableState extends State<TimeTable> {
  Widget image;
  GlobalKey<NavigatorState> navKey;
  bool loading = true;
  _TimeTableState(this.navKey);
  int currentGroup = -1;
  final List<ImageData> urlMap = List<ImageData>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? _buildLoadingBar
        : currentGroup == -1 ? _buildGroupSelection : image;
  }

  Widget get _buildLoadingBar {
    http
        .read(
            "https://gist.githubusercontent.com/oSoloTurk/3f6ec215135cb45c8fe2c6df412e7f59/raw/")
        .then((value) {
      urlMap.clear();
      List<String> values = value.split(",");
      for (int index = 0; index < values.length - 1; index++) {
        urlMap.add(ImageData(
            values.elementAt(index), values.elementAt(++index).trim()));
      }
      setState(() {
        loading = false;
      });
    });
    return SafeArea(
        child: Column(children: [
      Image.asset("assets/images/launcher_icon.png"),
      Image.asset("assets/images/loading.gif")
    ]));
  }

  get _buildGroupSelection => Container(
          child: Column(children: <Widget>[
        Expanded(
            child: ListView.builder(
                itemCount: urlMap.length,
                itemBuilder: (context, index) => _getGroupButton(index)))
      ]));

  _getGroupButton(int index) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: RaisedButton(
          color: currentGroup == index
              ? UIHelper.colorIconSelected
              : UIHelper.colorBorder,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: UIHelper.colorBorder, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(25))),
          onPressed: () => _setCurrentGroup(index),
          child: Row(children: [
            Text(
              "   ${urlMap.elementAt(index).name}",
              style: TextStyle(fontSize: 15, color: UIHelper.colorText),
            )
          ])),
    );
  }

  void _setCurrentGroup(int index) {
    setState(() {
      currentGroup = index;
    });
    loadImage();
  }

  void loadImage() {
    print("[" + urlMap.elementAt(currentGroup).url + "]");
    print(currentGroup);
    setState(() {
      image = Container(
          color: UIHelper.colorBackground,
          child: PhotoView(
              imageProvider:
                  Image.network(urlMap.elementAt(currentGroup).url).image));
    });
  }
}
