import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imperial/screens/basic/signup.dart';

import '../../common/custom_widget.dart';
import '../../common/localization/localizations.dart';
import 'login.dart';

class Welcome_Screen extends StatefulWidget {
  const Welcome_Screen({Key? key}) : super(key: key);

  @override
  State<Welcome_Screen> createState() => _Welcome_ScreenState();
}

class _Welcome_ScreenState extends State<Welcome_Screen> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        // appBar: AppBar(
        //   systemOverlayStyle: SystemUiOverlayStyle(
        //     statusBarColor: Theme.of(context).primaryColor, // For iOS: (dark icons)
        //     statusBarIconBrightness: Brightness.light, // For Android: (dark icons)
        //   ),
        //   elevation: 0.0,
        //   toolbarHeight: 0.0,
        // ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Image.asset("assets/images/welcome.png",fit: BoxFit.contain),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Fast and Flexible Trading",
                  style: CustomWidget(context: context)
                      .CustomSizedTextStyle(
                      20.0,
                      Theme.of(context).focusColor,
                      FontWeight.w600,
                      'FontRegular'),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Signup_Screen()));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(top: 8.0, bottom: 10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Theme.of(context).primaryColor,
                              border: Border.all(width: 2.0, color: Theme.of(context).disabledColor,)
                          ),
                          child: Text(
                            AppLocalizations.instance.text("loc_sign_up"),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                16.0,
                                Theme.of(context).disabledColor,
                                FontWeight.w500,
                                'FontRegular'),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ), flex: 2,),
                      const SizedBox(width: 20.0,),
                      Flexible(child: InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Login_Screen()));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only( top: 10.0, bottom: 12.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Theme.of(context).disabledColor,
                          ),
                          child: Text(
                            AppLocalizations.instance.text("loc_login"),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                16.0,
                                Theme.of(context).primaryColorLight,
                                FontWeight.w500,
                                'FontRegular'),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ), flex: 2,)
                    ],
                  ),
                ),

                const SizedBox(
                  height: 10.0,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
