import 'package:flutter/material.dart';

class OrderPageProvider extends ChangeNotifier {

  /// Tab的下标
  int _index = 0;
  int get index => _index;

  int _badgeNumber1 = 13; // 默认值为12

  int get badgeNumber1 => _badgeNumber1;

  void setBadgeNumber1(int value) {
    _badgeNumber1 = value;
    notifyListeners();
  }

  int _badgeNumber2 = 13; // 默认值为12

  int get badgeNumber2 => _badgeNumber2;

  void setBadgeNumber2(int value) {
    _badgeNumber2 = value;
    notifyListeners();
  }
  
  void refresh() {
    notifyListeners();
  }
  
  void setIndex(int index) {
    _index = index;
    notifyListeners();
  }

}
