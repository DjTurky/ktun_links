import 'package:KTUN/screens/broadcasts.dart';
import 'package:KTUN/screens/foodlist.dart';
import 'package:KTUN/screens/news.dart';
import 'package:KTUN/screens/shortcuts.dart';
import 'package:KTUN/screens/timetable.dart';
import 'package:KTUN/utils/PushNotificationsManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:KTUN/models/Website.dart';
import 'package:KTUN/utils/UIHelper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final navKey = new GlobalKey<NavigatorState>();
  @override
  _MyAppState createState() => _MyAppState(navKey);
}

class _MyAppState extends State<MyApp> {
  //Fields
  PageController _pageController;
  var loadingOne = true;
  var loadingTwo = true;
  var loadingThree = true;
  var loadingFour = true;
  var loadingFive = true;

  String connectionProtocol = "https";
  bool connectionBoolean = true;
  List<Website> websites = List<Website>();
  List<Website> broadcasts = List<Website>();
  List<Website> news = List<Website>();
  int _currentPageIndex = 0;
  GlobalKey<NavigatorState> navKey;
  var notification = PushNotificationsManager();
  SnakeShape customSnakeShape = SnakeShape(
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      centered: true);
  ShapeBorder customBottomBarShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15), topRight: Radius.circular(15)),
  );
  ShapeBorder customBottomBarShape1 = BeveledRectangleBorder(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15), topRight: Radius.circular(15)),
  );

  SnakeBarStyle snakeBarStyle = SnakeBarStyle.floating;
  SnakeShape snakeShape = SnakeShape.circle;
  ShapeBorder bottomBarShape = RoundedRectangleBorder(
      side: BorderSide(color: UIHelper.colorBorder, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(25)));
  double elevation = 0;
  bool showSelectedLabels = false;
  bool showUnselectedLabels = false;
  Color selectionColor = Colors.pink;
  EdgeInsets padding = EdgeInsets.all(12);
  TextStyle labelTextStyle = TextStyle(
      fontSize: 11, fontFamily: 'Ubuntu', fontWeight: FontWeight.bold);

  _MyAppState(this.navKey);

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  //Widgets
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: UIHelper.colorBackground,
      home: _buildHome,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      navigatorKey: navKey,
      title: "KTUN Hızlı Erişim",
    );
  }

  Widget get _buildHome {
    return Scaffold(
        appBar: _buildAppBar,
        body: _buildPages,
        backgroundColor: UIHelper.colorBackground,
        bottomNavigationBar: _buildBottomNavigationBar);
  }

  // APP BAR
  AppBar get _buildAppBar {
    return AppBar(
        centerTitle: true,
        title: Text(
          "KTUN Hızlı Erişim",
          style:
              TextStyle(color: UIHelper.colorLogo, fontWeight: FontWeight.bold),
        ),
        backgroundColor: UIHelper.colorBackground,
        actions: [_buildInformationButton]);
  }

  FloatingActionButton get _buildInformationButton => FloatingActionButton(
      heroTag: "information",
      child: Icon(Icons.info_outline),
      backgroundColor: Colors.transparent,
      onPressed: () {
        _popUpInformation();
      });

  Widget get _buildPages => PageView(
        onPageChanged: (page) {
          _onPageChangeEvent(page.toInt());
        },
        controller: _pageController,
        children: <Widget>[
          ShortCuts(navKey),
          Broadcasts(navKey),
          News(navKey),
          FoodList(navKey),
          TimeTable(navKey)
        ],
      );

  //Bottom APP Bar
  Widget get _buildBottomNavigationBar => SnakeNavigationBar(
        style: snakeBarStyle,
        snakeShape: snakeShape,
        snakeColor: selectionColor,
        backgroundColor: UIHelper.colorBackground,
        showUnselectedLabels: showUnselectedLabels,
        showSelectedLabels: showSelectedLabels,
        shape: bottomBarShape,
        padding: padding,
        currentIndex: _currentPageIndex,
        onPositionChanged: (index) {
          _pageController.animateToPage(index,
              duration: Duration(seconds: 1), curve: Curves.easeIn);
          _onPageChangeEvent(index);
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.link,
                  color: _currentPageIndex == 0 ? Colors.pink : Colors.white),
              title: Text('Bağlantılar', style: labelTextStyle)),
          BottomNavigationBarItem(
              icon: Icon(Icons.announcement,
                  color: _currentPageIndex == 1 ? Colors.pink : Colors.white),
              title: Text('Duyurular', style: labelTextStyle)),
          BottomNavigationBarItem(
              icon: Icon(Icons.line_style,
                  color: _currentPageIndex == 2 ? Colors.pink : Colors.white),
              title: Text('Haberler', style: labelTextStyle)),
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood,
                  color: _currentPageIndex == 3 ? Colors.pink : Colors.white),
              title: Text('Yemek Listesi', style: labelTextStyle)),
          BottomNavigationBarItem(
              icon: Icon(Icons.table_chart,
                  color: _currentPageIndex == 4 ? Colors.pink : Colors.white),
              title: Text('Ders Programı', style: labelTextStyle)),
        ],
      );

  //Page Change Event
  void _onPageChangeEvent(int number) {
    setState(() {
      _currentPageIndex = number;
    });
  }

  //Show Alert
  void _popUpInformation() {
    showDialog(
        context: navKey.currentState.overlay.context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: UIHelper.colorBackground,
            shape: RoundedRectangleBorder(
                side: new BorderSide(color: UIHelper.colorBorder, width: 2.0),
                borderRadius: BorderRadius.circular(4.0)),
            title: Text(
                "Uygulama yalnızca webview uygulamasıdır ve KTUN (Konya Teknik Üniversitesi) ile bağlılığı yoktur.",
                style: TextStyle(
                    color: UIHelper.colorPaleText,
                    fontWeight: FontWeight.bold)),
            content: Text("İletişim: oSoloTurk#1692 (Discord)",
                style: TextStyle(
                    color: UIHelper.colorPaleText,
                    fontStyle: FontStyle.italic)),
          );
        });
  }
}
