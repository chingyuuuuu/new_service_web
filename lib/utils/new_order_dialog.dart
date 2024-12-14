import 'package:flutter/material.dart';

class NewOrderDialog {
  static void showNewOrderDialog(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("新訂單通知"),
          content: Text(message), // 顯示消息
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 關閉對話框
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // 背景色設置為黑色
                foregroundColor: Colors.white, // 字體顏色設置為白色
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // 調整按鈕內間距
                textStyle: const TextStyle(
                  fontSize: 18, // 字體大小
                ),
              ),
              child: const Text("接收訂單"),
            ),
          ],
        ),
      );
    });
  }
}
