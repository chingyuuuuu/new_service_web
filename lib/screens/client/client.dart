import 'package:flutter/material.dart';
import 'package:jkmapp/screens/client/orderlistpage.dart';
import 'package:jkmapp/widgets/client/TypeButton.dart';
import 'package:jkmapp/utils/diolog.dart';
import 'package:jkmapp/widgets/client/cart.dart';
import 'package:jkmapp/widgets/client/ProductCard.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/providers/restaurant/order_provider.dart';
import 'package:jkmapp/routers/app_routes.dart';
import 'package:jkmapp/providers/client/client_provider.dart';
import  'package:jkmapp/providers/client/Notification_Provider.dart';
import 'dart:html' as html;


class Client extends StatefulWidget {
  final String? tableNumber;//接收桌號
  Client({required this.tableNumber});

  @override
  ClientState createState() => ClientState();
}

class ClientState extends State<Client> {
  bool _isSearching =false;//是否開啟搜尋狀態
  bool _isEditingTableNumber=false;//是否正在編輯桌號
  TextEditingController _tableNumberController=TextEditingController();
  TextEditingController _searchController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late String tableNumber; //桌號

  @override
  void initState() {
    super.initState();
    //從widgt中或是url當中獲取桌號
    tableNumber = widget.tableNumber ?? _getTableNumberFromUrl();
    _tableNumberController.text=tableNumber;//初始化桌號輸入框
    //確保UI完全加載後
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final clientProvider = Provider.of<ClientProvider>(context, listen: false);//表示只會載入一次
      clientProvider.loadProducts();//加載
    });
  }

  String _getTableNumberFromUrl() {
    final url = html.window.location.href; // 獲取目前的url
    final uri = Uri.parse(url);
    return uri.queryParameters['table'] ?? 'Unknown'; // 如果没有桌號，则返回 "Unknown"
  }

  @override
  Widget build(BuildContext context) {
    final clientProvider = Provider.of<ClientProvider>(context);
    final notificationProvider=Provider.of<NotificationProvider>(context);

    return Scaffold(
      drawer: Drawer( //側邊儀表板
        backgroundColor: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 35),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('訂單'),
              onTap: () {
                 final orderProvider=Provider.of<OrderProvider>(context, listen: false);
                 orderProvider.fetchOrders(tableNumber, context);
                if (context.mounted) { //滑鼠點擊之後
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Orderlistpage(tableNumber: tableNumber),
                   ),
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            ListTile(
               leading:const Icon(Icons.question_answer_outlined),
               title: const Text('客服'),
               onTap:(){
                  Navigator.pushNamed(context, Routers.restaurant_qasytstem);
               }
            ),
            const SizedBox(height: 40),
            ListTile(
              leading: Icon(Icons.notifications,
                  color: notificationProvider.isServiceBellTapped
                        ? Colors.yellow
                        : Colors.black),
              title: Text('服務鈴'),
              onTap: () {
                notificationProvider.toggleServiceBell(tableNumber);
              },
            ),
            const SizedBox(height: 10),
            ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('設定'),
            onTap: () {
            showPasswordDialog(context, passwordController, () { // 傳遞回調函數
                  Navigator.pushNamed(context, Routers.dining); // 密碼正確後導航到 dining
            });
           },
         ),
        ],
      ),
    ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(color: Colors.white),
            ),
            title: _isSearching
             ?TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜尋商品...',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                clientProvider.filterProducts(value); //搜尋-根據輸入的值過濾商品
              },
             )
            :GestureDetector(
              onTap: (){
                 setState(() {
                    _isEditingTableNumber=true;
                 });
              },
            child:_isEditingTableNumber
               ?TextField(
                 controller: _tableNumberController,
                 autofocus: true,
                 onSubmitted: (value){
                    setState(() {
                        tableNumber=value.isNotEmpty
                            ?value
                            :tableNumber; //確保桌號不為空的
                        _isEditingTableNumber=false;
                    });
                 },
                 style:TextStyle(color:Colors.black,fontSize: 20),
                 decoration: InputDecoration(
                     border:InputBorder.none,
                     hintText: '輸入桌號',
                 ),
                )
              :Text( //顯示桌號
               '桌號:$tableNumber',
                key: ValueKey('tabletitle'),
                style: TextStyle(color:Colors.black,fontSize:20),
                textAlign: TextAlign.center,
              ),
            ),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            actions: [
              Padding(
              padding: const EdgeInsets.only(right:16.0),
              child:IconButton(
                icon: Icon(_isSearching
                    ? Icons.close
                    : Icons.search, color: Colors.black,size:30.0),
                  onPressed: () {
                  setState(() {
                    if (_isSearching) {
                      _isSearching = false; // 關閉搜尋框
                      _searchController.clear(); // 清空搜尋框
                      clientProvider.applyFilters(); // 重置顯示的商品
                    } else {
                      _isSearching = true; // 顯示搜尋框
                    }
                  });
                },
              ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                    size: 30.0,
                  ),
                  onPressed: () {
                    showModalBottomSheet(//打開購物車
                      context: context,
                      builder: (context) {
                        return buildCartBottomSheet(context,tableNumber);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(//介面設計-type欄
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TypeButtonList(
                typeOptions: clientProvider.typeOptions,
                selectedType: clientProvider.selectedTypes,
                onTypeSelected: clientProvider.filterProductsByType, // 點擊按鈕過濾類型
              ),
            ),
          ),
          SliverPadding( //商品資訊
            padding: const EdgeInsets.all(8.0),
            sliver: SliverGrid(
              gridDelegate:SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200, // 每個商品卡的最大寬度
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.8, // 控制圖片和文字的比例
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                  return ProudctCard(product: clientProvider.displayedProducts[index]);
                },
                childCount: clientProvider.displayedProducts.length,//告訴有多少個子項目需要去處理
              ),
            ),
          ),
        ],
      ),
    );
  }
}
