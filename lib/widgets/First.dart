import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class First extends StatelessWidget{
      @override
      Widget build(BuildContext context){
        Future.delayed(Duration(seconds:3),(){
          context.go('/Login');
        });
        return Scaffold(
          backgroundColor: Color(0xFF223888),
          body: Center(
            child:Text(
              'Service',
              style: TextStyle(
                 color:Colors.white,
                 fontFamily: 'Kapakana',
                 fontSize:120,
                 fontWeight:FontWeight.bold,
            ),
          ),
        ),
        );
      }
}

