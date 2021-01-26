import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './imglist_provider.dart';
import './home_screen.dart';
import './confirm_screen.dart';

void main() => runApp(SimpleImgToPdf());

class SimpleImgToPdf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ImgListProvider(),
      child: MaterialApp(
        title: 'Simple Images To PDF',
        debugShowCheckedModeBanner: false,
        //home: HomeScreen(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'ProductSans',
        ),
        routes: {
          '/': (context) => HomeScreen(),
          ConfirmScreen.routeName: (context) => ConfirmScreen(),
          //ScreenWidgetClass.routeNameString: (context) => ScreenWidgetClass(_dataToPass),
        },
      ),
    );
  }
}



