import 'package:flutter/material.dart';

class UIHelper {
  static final spaceFlex10 = Spacer(flex: 10);
  static final colorLogo = Colors.pink;
  static final colorBackground = Color.fromRGBO(18, 21, 25, 1);
  static final colorBorder = Color.fromRGBO(112, 123, 251, 1);
  static final colorIcon = Color.fromRGBO(185, 187, 190, 1);
  static final colorButton = Color.fromRGBO(142, 146, 151, 1);
  static final colorIconSelected = Colors.pink;
  static final colorCard = Color.fromRGBO(22, 26, 30, 1);
  static final colorText = Colors.white;
  static final colorPaleText = Colors.white70;
  static final textTitle = TextStyle(
      fontSize: 18,
      fontStyle: FontStyle.italic,
      color: UIHelper.colorText,
      fontWeight: FontWeight.bold);
  static final textSubtitle = TextStyle(
      fontSize: 11, fontStyle: FontStyle.italic, color: UIHelper.colorPaleText);
}
