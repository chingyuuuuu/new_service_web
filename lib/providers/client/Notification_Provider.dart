import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  bool isServiceBellTapped = false;
  String? _tableNumber;
  String? get tableNumber =>_tableNumber;


  //服務鈴通知
  void toggleServiceBell(String tableNumber) {
    if(isServiceBellTapped)return;//如果服務鈴已經被按下返回true

    isServiceBellTapped = true;
    _tableNumber=tableNumber;
    notifyListeners();//通知更新

    Future.delayed(const Duration(seconds:20), () {//過了20秒之後關閉
      isServiceBellTapped = false;
      _tableNumber=null;
      notifyListeners();//通知更新
    });
  }

}