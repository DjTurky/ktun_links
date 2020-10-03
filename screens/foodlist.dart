import 'package:KTUN/utils/UIHelper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
class FoodList extends StatefulWidget {
  GlobalKey<NavigatorState> navKey;
  FoodList(this.navKey);

  @override
  _FoodListState createState() => _FoodListState(navKey);
}

class _FoodListState extends State<FoodList> {
  GlobalKey<NavigatorState> navKey;
  bool loading = true;
  _FoodListState(this.navKey);
  String foodUrl;
  Widget imageEmbed;

  @override
  void initState() {
    http
        .read(
            'https://gist.githubusercontent.com/oSoloTurk/59b5f708e794162c3c8c1cc67fab16a7/raw/')
        .then((contents) {
      setState(() {
        imageEmbed = SafeArea(
            child: Container(
                color: UIHelper.colorBackground,
                child:
                    PhotoView(imageProvider: Image.network(contents).image)));
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? _buildLoadingBar : imageEmbed;
  }

  Widget get _buildLoadingBar => SafeArea(
          child: Column(children: [
        Image.asset("assets/images/launcher_icon.png"),
        Image.asset("assets/images/loading.gif")
      ]));
}
