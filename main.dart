import 'package:KTUN/screens/WebView.dart';
import 'package:KTUN/utils/PushNotificationsManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:http/http.dart' as http;
import 'package:KTUN/models/Website.dart';
import 'package:KTUN/utils/UIHelper.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' show parse;
import 'package:connectivity/connectivity.dart';

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
  var _foodListWidget;
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
    _loadWebsites();
    _buildFoodList();
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

  //BODY
  Widget get _buildLoadingBar => SafeArea(
          child: Column(children: [
        Image.asset("assets/images/launcher_icon.png"),
        Image.asset("assets/images/loading.gif")
      ]));

  Widget get _buildPages => PageView(
        onPageChanged: (page) {
          _onPageChangeEvent(page.toInt());
        },
        controller: _pageController,
        children: <Widget>[
          loadingOne ? _buildLoadingBar : _buildShortcuts,
          loadingTwo ? _buildLoadingBar : _buildBroadcasts,
          loadingFour ? _buildLoadingBar : _buildNews,
          loadingThree ? _buildLoadingBar : _foodListWidget
        ],
      );

  Widget get _buildShortcuts => Column(children: <Widget>[
        Expanded(
            child: ListView.builder(
                itemCount: websites.length,
                itemBuilder: (context, index) {
                  return _createShortcut(websites[index]);
                }))
      ]);

  Widget get _buildBroadcasts => Column(children: <Widget>[
        Expanded(
            child: ListView.builder(
                itemCount: broadcasts.length,
                itemBuilder: (context, index) {
                  return _createShortcut(broadcasts[index]);
                }))
      ]);

  Widget get _buildNews => Column(children: <Widget>[
        Expanded(
            child: ListView.builder(
                itemCount: news.length,
                itemBuilder: (context, index) {
                  return _createShortcut(news[index]);
                }))
      ]);

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

  //FoodList
  Widget _buildFoodList() {
    http
        .read(
            "https://gist.githubusercontent.com/oSoloTurk/59b5f708e794162c3c8c1cc67fab16a7/raw/")
        .then((value) {
      setState(() {
        _foodListWidget = SafeArea(
            child: Container(
                color: UIHelper.colorBackground,
                child: PhotoView(imageProvider: Image.network(value).image)));
      });
    });
    setState(() {
      loadingThree = false;
    });
  }

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
        ],
      );

  //TOOLS

  //Connection Check
  Future<bool> checkNetworkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  //Page Change Event
  void _onPageChangeEvent(int number) {
    setState(() {
      _currentPageIndex = number;
    });
  }

  //Collect Data
  void _loadWebsites() {
    checkNetworkConnection().then((internet) {
      if (internet != null && internet) {
        _loadFromGithub();
        _loadFromKtun();
      } else {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('İnternet Bağlantısı Bulunamadı!')));
      }
    });
  }

  //Launch url
  void _launchBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
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
            actions: [
              Text("Sadece SSL ile Bağlan",
                  style: TextStyle(color: UIHelper.colorPaleText)),
              IconButton(
                icon: Icon(
                  connectionBoolean ? Icons.lock : Icons.lock_open,
                  color: Colors.pink,
                ),
                onPressed: () {
                  setState(() {
                    connectionBoolean = !connectionBoolean;
                    connectionProtocol =
                        "htt" + (connectionBoolean ? "ps" : "p");
                    loadingTwo = true;
                    loadingFour = true;
                    _loadFromKtun();
                  });
                },
              )
            ],
          );
        });
  }

  //Load data from github
  void _loadFromGithub() {
    checkNetworkConnection().then((internet) {
      if (internet != null && internet) {
        http
            .read(
                'https://gist.githubusercontent.com/oSoloTurk/905444356d948997abad20974dca901d/raw/')
            .then((contents) {
          websites.clear();
          List<String> response = contents.split(",");
          for (int i = 0; i < response.length; i += 3) {
            websites.add(Website(
                response[i],
                response[i + 1],
                response[i + 2],
                !response[i].startsWith("!"),
                !response[i + 1].startsWith("!")));
          }
          setState(() {
            loadingOne = false;
          });
        });
      } else
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('İnternet Bağlantısı Bulunamadı!')));
    });
  }

  //Load data from ktun
  void _loadFromKtun() {
    checkNetworkConnection().then((internet) {
      if (internet != null && internet) {
        http
            .read(
                '$connectionProtocol://ktun.edu.tr/tr/Universite/TumDuyurular')
            .then((contents) {
          var document = parse(contents);
          var labCells = document
              .getElementsByTagName('table')[0]
              .getElementsByTagName('tbody')[0]
              .getElementsByTagName('tr');
          broadcasts.clear();
          for (int i = 0; i < labCells.length; i++) {
            broadcasts.add(Website(
                labCells[i].getElementsByTagName("td")[0].innerHtml,
                "$connectionProtocol://ktun.edu.tr" +
                    labCells[i]
                        .getElementsByTagName("td")[2]
                        .getElementsByTagName("a")[0]
                        .attributes["href"],
                labCells[i].getElementsByTagName("td")[1].innerHtml,
                true,
                true));
          }
          setState(() {
            loadingTwo = false;
          });
        });
        http
            .read('$connectionProtocol://ktun.edu.tr/tr/Universite/TumHaberler')
            .then((contents) {
          var document = parse(contents);
          var labCells = document
              .getElementsByTagName('table')[0]
              .getElementsByTagName('tbody')[0]
              .getElementsByTagName('tr');
          news.clear();
          for (int i = 0; i < labCells.length; i++) {
            news.add(Website(
                labCells[i].getElementsByTagName("td")[0].innerHtml,
                "$connectionProtocol://ktun.edu.tr" +
                    labCells[i]
                        .getElementsByTagName("td")[2]
                        .getElementsByTagName("a")[0]
                        .attributes["href"],
                labCells[i].getElementsByTagName("td")[1].innerHtml,
                true,
                true));
          }
          setState(() {
            loadingFour = false;
          });
        });
      } else
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('İnternet Bağlantısı Bulunamadı!')));
    });
  }
}
