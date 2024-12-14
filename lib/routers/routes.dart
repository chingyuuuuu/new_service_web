import 'package:go_router/go_router.dart';
import 'package:jkmapp/widgets/First.dart';
import 'package:jkmapp/screens/user/Login.dart';
import 'package:jkmapp/screens/user/Forget1.dart';
import 'package:jkmapp/screens/user/Register.dart';
import 'package:jkmapp/screens/user/Forget2.dart';
import 'package:jkmapp/screens/user/Forget3.dart';
import 'package:jkmapp/screens/restaurant/dining.dart';
import 'package:jkmapp/screens/products/createmerchandise.dart';
import 'package:jkmapp/screens/restaurant/Setting/settingpage.dart';
import 'package:jkmapp/screens/products/productdetail.dart';
import 'package:jkmapp/screens/restaurant/menu.dart';
import 'package:jkmapp/screens/client/client.dart';
import 'package:jkmapp/screens/client/orderlistpage.dart';
import 'package:jkmapp/screens/client/orderdetailpage.dart';
import 'package:jkmapp/screens/restaurant/Order/userorderlist.dart';
import 'package:jkmapp/screens/restaurant/QA/restaurant_database.dart';
import 'package:jkmapp/screens/restaurant/QA/restaurant_qasytem.dart';
import 'package:jkmapp/screens/restaurant/QA/QA_unanswered.dart';
import 'package:jkmapp/screens/restaurant/Order/order_history.dart';
import 'package:jkmapp/screens/restaurant/Table/TableManagementPage.dart';
import 'package:jkmapp/screens/restaurant/Checkout/checkpage.dart';
import 'package:jkmapp/screens/restaurant/Checkout/RevenuePage.dart';
import 'package:jkmapp/screens/restaurant/Order/useroderdetail.dart';


final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => First(),
    ),
    GoRoute(
      path: '/Login',
      builder: (context, state) => Login(),
    ),
    GoRoute(
      path: '/forget1',
      builder: (context, state) => Forget1(),
    ),
    GoRoute(
      path: '/Register',
      builder: (context, state) => Register(),
    ),
    GoRoute(
      path: '/Forget2',
      builder: (context, state) => Forget2(),
    ),
    GoRoute(
      path: '/Forget3',
      builder: (context, state) => Forget3(),
    ),
    GoRoute(
      path: '/Dining',
      builder: (context, state) => dining(),
    ),
    GoRoute(
      path: '/Createmerchandise',
      builder: (context, state) => CreateMerchandise(),
    ),
    GoRoute(
      path: '/Menu',
      builder: (context, state) => MenuPage(),
    ),
    GoRoute(
      path: '/Client/:table', // 使用动态路径参数
      builder: (context, state) {
        final tableNumber = state.params['table']!;//提取路徑參數
        return Client(tableNumber: tableNumber);
      },
    ),
    GoRoute(
      path: '/Orderlistpage',
      builder: (context, state) {
        final tableNumber = state.queryParams['table'] ?? 'Unknown';
        return Orderlistpage(tableNumber: tableNumber);
      },
    ),
    GoRoute(
      path: '/Productdetail',
      builder: (context, state) {
        final extraData = state.extra as Map<String, dynamic>;
        final productId = extraData['product_id'] as int;
        return ProductDetailPage(productId: productId);
      },
    ),
    GoRoute(
      path: '/SettingsPage',
      builder: (context, state) => SettingsPage(onSave: () {}),
    ),
    GoRoute(
      path: '/restaurant_database',
      builder: (context, state) => restaurantData(),
    ),
    GoRoute(
      path: '/restaurant_qasytstem',
      builder: (context, state) => RestaurantQASystem(),
    ),
    GoRoute(
      path: '/UnansweredQuestions',
      builder: (context, state) => UnansweredQuestionsPage(),
    ),
    GoRoute(
      path: '/Orderhistory',
      builder: (context, state) => orderHistory(),
    ),
    GoRoute(
      path: '/TableManagement',
      builder: (context, state) => TableGeneratorPage(),
    ),
    GoRoute(
      path: '/Checkpage',
      builder: (context, state) => Checkpage(),
    ),
    GoRoute(
      path: '/Revenuepage',
      builder: (context, state) => RevenuePage(),
    ),
    GoRoute(
      path: '/Userorderlist',
      builder: (context, state) => UserOrderList(),
    ),
    GoRoute(
        path: '/OrderdetailPage',
        builder:(context,state){
          final orderId=state.params['OrderId']!;
          return OrderDetailPage(orderId: int.parse(orderId));
      }
    ),
    GoRoute(
      path: '/userorderdetail/:orderId',
      builder: (context, state) {
        // 提取动态参数
        final orderId = state.params['orderId']!;
        return Userorderdetail(orderId: int.parse(orderId));
      },
    ),
  ],
);
