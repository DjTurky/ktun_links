import 'package:KTUN/utils/UIHelper.dart';
import 'package:connectivity/connectivity.dart';
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
  bool groupSelection = true;
  int currentGroup;
  final urlMap = {
    1: "https://gist.githubusercontent.com/oSoloTurk/3f6ec215135cb45c8fe2c6df412e7f59/raw/",
    2: "https://gist.githubusercontent.com/oSoloTurk/1b7e55a041a14f76d89273b6ec58acf7/raw/"
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!groupSelection && loading) loadImage();
    return groupSelection
        ? _buildGroupSelection
        : loading ? _buildLoadingBar : image;
  }

  Widget get _buildLoadingBar => SafeArea(
          child: Column(children: [
        Image.asset("assets/images/launcher_icon.png"),
        Image.asset("assets/images/loading.gif")
      ]));

  get _buildGroupSelection => Container(
          child: Column(children: <Widget>[
        Expanded(
            child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) => _getGroupButton(index + 1)))
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
              "   $index. Öğretim",
              style: TextStyle(fontSize: 15, color: UIHelper.colorText),
            )
          ])),
    );
  }

  _setCurrentGroup(int index) {
    setState(() {
      currentGroup = index;
      groupSelection = false;
    });
  }

  void loadImage() {
    http.read(urlMap[currentGroup]).then((contents) {
      setState(() {
        print("url" + contents);
        image = Container(
            color: UIHelper.colorBackground,
            child: PhotoView(imageProvider: Image.network(contents).image));
        loading = false;
      });
    });
  }
}
