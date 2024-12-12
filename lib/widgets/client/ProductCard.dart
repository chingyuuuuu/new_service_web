import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jkmapp/widgets/image_display.dart';
import 'package:jkmapp/providers/client/cart_provider.dart';
import 'package:provider/provider.dart';



class ProudctCard extends StatelessWidget{
    final Map<String,dynamic>product;
    ProudctCard({required this.product});


    @override
    Widget build(BuildContext context){
        //根據螢幕大小調整內容
        final screenWidth=MediaQuery.of(context).size.width;
        final cardWidth = (screenWidth / 2).clamp(0, 200) - 20.0; //每行顯示2個商品，減去左右間距

        return Container(
            width: cardWidth,
            height:cardWidth*1.2,
            color: Colors.white,
            child: Card(
                color: Colors.white,
                elevation: 4,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        ImageDisplay(imageData: product['image'],width: cardWidth*0.8,height: cardWidth*0.5,),
                        const SizedBox(height: 5),
                        Text(product['name'] ?? '', style: TextStyle(fontSize: cardWidth*0.1),
                        ),
                        const SizedBox(height: 8),
                        Text('NT\$ ${product['price']}', style:  TextStyle(fontSize: cardWidth*0.07, fontWeight: FontWeight.normal,),
                        ),
                        ElevatedButton(
                            onPressed: () {
                                Provider.of<CartProvider>(context, listen: false).addToCart(
                                    product['name'],
                                    product['price'],
                                    product['product_id']//可能傳遞null
                                );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                minimumSize: Size(cardWidth*0.6,40),
                            ),
                            child: const Text('加入購物車', style: TextStyle(color: Colors.black)),
                        ),
                    ],
                ),
            ),
        );
    }
}