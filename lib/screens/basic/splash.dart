import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imperial/screens/basic/home.dart';
import 'package:imperial/screens/basic/welcome.dart';
import 'package:imperial/screens/basic/welcome_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/custom_widget.dart';
import '../../common/theme/custom_theme.dart';
import '../../data/api_utils.dart';
import '../../data/crypt_model/login_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String check = "";
  String email="";
  String password="";
  String name="";
  APIUtils apiUtils = APIUtils();
  bool loading=false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails();
  }

  getDetails()async{



    SharedPreferences preferences=await SharedPreferences.getInstance();
    setState(() {
    String data=preferences.getString("token").toString();
    email=preferences.getString("email").toString();
    password=preferences.getString("password").toString();
    name=preferences.getString("name").toString();
    if(data==null|| data=="null")
      {
        check="false";
      }
    else{
      check="true";
    }
    });
    onLoad();
  }

  onLoad() {
    setState(() {
      loading=true;
      if(check=="true")
        {
          if(email.isNotEmpty && password.isNotEmpty){
            verifyMail();
          }
          else if(email.isNotEmpty && password.isEmpty){
            loginGoogle(name,email);
          }
          else{
            Timer(Duration(seconds: 6),
                  ()=>Navigator.pushReplacement(context,
                  MaterialPageRoute(builder:
                      (context) => WelcomeInfo(),
                  )
              ),
            );
          }


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
  loginGoogle(String name,String mail) {
    apiUtils
        .doGoogleRegister(
        name,
        mail
    )
        .then((LoginDetailsModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;

          // CustomWidget(context: context).showSuccessAlertDialog(
          //     "Login", loginData.message.toString(), "success");
          storeData(
              loginData.result!.token.toString(),loginData.result!.user!.traderType.toString(),loginData.result!.user!.id.toString(),
              loginData.result!.user!.email.toString(),"",loginData.result!.user!.name.toString()
          );
        });
        Timer(Duration(seconds: 2),
              ()=>Navigator.pushReplacement(context,
              MaterialPageRoute(builder:
                  (context) => Home_Screen(),
              )
          ),
        );
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Login", loginData.message.toString(), "error");
        });
      }
    }).catchError((Object error) {
      print("error");
      setState(() {
        loading = false;
      });
    });
  }
  storeData(
      String token, String trader_type,String id,String email,String password,String name) async {
    print("token${token}");
    print("type$trader_type");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("token", token);
    preferences.setString("trader_type", trader_type);
    preferences.setString("user_id", id);
    preferences.setString("email", email);
    preferences.setString("password", password);
    preferences.setString("name", name);
  }
  verifyMail() async {
    apiUtils
        .doLoginEmail(
     email,
      password,
    )
        .then((LoginDetailsModel loginData) {
      if (loginData.success!) {
        setState(() {
          //loading = false;
          // if(loginData.result.user.){
          //
          // }
          storeData(loginData.result!.token.toString(), loginData.result!.user!.traderType.toString(),loginData.result!.user!.id.toString(),
              loginData.result!.user!.email.toString(),password.toString(),loginData.result!.user!.name.toString()
          );
          loading=false;
          Timer(Duration(seconds: 2),
                ()=>Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) => Home_Screen(),
                )
            ),
          );
          // profileDetails();
          // emailController.clear();
          // passwordController.clear();
        });

        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (context) => Home_Screen(),
        //   ),
        // );
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Login", loginData.message.toString(), "error");
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
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
