import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imperial/screens/basic/home.dart';
import 'package:imperial/screens/basic/welcome.dart';
import 'package:imperial/screens/basic/welcome_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/theme/custom_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String check = "";



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails();
  }

  getDetails()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    String data=preferences.getString("token").toString();
    if(data==null|| data=="null")
      {
        check="false";
      }
    else{
      check="true";
    }
    onLoad();
  }
  onLoad() {
    setState(() {
      if(check=="true")
        {
          Timer(Duration(seconds: 8),
                ()=>Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) => Home_Screen(),
                )
            ),
          );
        }
      else{
        Timer(Duration(seconds: 8),
              ()=>Navigator.pushReplacement(context,
              MaterialPageRoute(builder:
                  (context) => WelcomeInfo(),
              )
          ),
        );
      }

      // checkDeviceID(deviceData['device_id'].toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).primaryColor, // For iOS: (dark icons)
          statusBarIconBrightness: Brightness.light, // For Android: (dark icons)
        ),
        elevation: 0.0,
        toolbarHeight: 0.0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png",height: 220.0,width: 200.0,fit: BoxFit.contain),
            const SizedBox(height: 10.0,),
            // SvgPicture.asset("assets/images/name.svg",height: 30.0,width: 50.0,fit: BoxFit.contain),
            // Image.asset("assets/images/name.png",height: 40.0,width: 120.0,fit: BoxFit.contain),
          ],
        ),
      ),
    );
  }
}
