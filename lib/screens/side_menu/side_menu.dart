import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imperial/screens/side_menu/google_tfa.dart';
import 'package:imperial/screens/side_menu/kyc_info.dart';
import 'package:imperial/screens/side_menu/support_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../common/custom_widget.dart';
import '../../common/localization/localizations.dart';
import '../../data/api_utils.dart';
import '../../data/crypt_model/profile_model.dart';
import '../basic/login.dart';
import '../basic/notification.dart';
import '../basic/profile_setting.dart';
import '../basic/referral.dart';
import '../basic/signup.dart';
import '../basic/subscription.dart';

class Side_Menu_Setting extends StatefulWidget {
  const Side_Menu_Setting({Key? key}) : super(key: key);

  @override
  State<Side_Menu_Setting> createState() => _Side_Menu_SettingState();
}

class _Side_Menu_SettingState extends State<Side_Menu_Setting> {

  APIUtils apiUtils = APIUtils();
  bool loading = false;
  String name= "";
  bool googleUpdate = false;
  String secret  = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        // leadingWidth: 1.0,
        leading: Padding(
          padding: EdgeInsets.only(right: 5.0),
          child: InkWell(
            onTap: (){
              setState(() {
                Navigator.pop(context);
              });
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20.0,
              color: Theme.of(context).focusColor,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
         Padding(padding: EdgeInsets.only(right: 10.0),
         child:  Row(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             InkWell(
                 onTap: () {

                 },
                 child: SvgPicture.asset(
                   "assets/images/setting.svg",
                   height: 26.0,
                   fit: BoxFit.fill,
                   color: Theme.of(context).disabledColor,
                 )),
             const SizedBox(width: 15.0,),
             InkWell(
                 onTap: () {
                   Navigator.of(context).push(MaterialPageRoute(
                       builder: (context) => Notification_Screen()));
                 },
                 child: SvgPicture.asset(
                   "assets/images/bell.svg",
                   height: 26.0,
                   fit: BoxFit.fill,
                   color: Theme.of(context).focusColor,
                 )),
           ],
         ),),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/image.png", height: 70.0,fit: BoxFit.contain,),
                    const SizedBox(width: 10.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // "Johny Kim",
                          name,
                          style: CustomWidget(context: context).CustomSizedTextStyle(
                              16.0,
                              Theme.of(context).focusColor,
                              FontWeight.w600,
                              'FontRegular'),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 5.0,),
                        Container(
                          padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Theme.of(context).canvasColor,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Verified",
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    14.0,
                                    Theme.of(context).disabledColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(width: 5.0,),
                              Icon(
                                Icons.verified,
                                color: Theme.of(context).disabledColor,
                                size: 14.0,
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10.0,),
              Container(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                color: Theme.of(context).canvasColor,
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Referral_Screen()));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/sidemenu/gift.svg", height: 24.0, color: Theme.of(context).disabledColor,),
                      const SizedBox(width: 5.0,),
                      Text(
                        "Invite friends. Earn Crypto Together!",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            12.0,
                            Theme.of(context).focusColor,
                            FontWeight.w400,
                            'FontRegular'),
                        textAlign: TextAlign.start,
                      ),

                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25.0,),
              Container(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "App Setting",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          16.0,
                          Theme.of(context).focusColor,
                          FontWeight.w600,
                          'FontRegular'),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 15.0,),
                    Container(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 15.0, left: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Theme.of(context).canvasColor,
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap:(){
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => Profile_Settings()));
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 20.0,
                                        width: 20.0,
                                        child: SvgPicture.asset("assets/sidemenu/profile.svg", height: 18.0, color: Theme.of(context).disabledColor,),
                                      ),
                                      const SizedBox(width: 10.0,),
                                      Text(
                                        "Profile Setting",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],), ),
                                  Flexible(child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18.0,
                                    color: Theme.of(context).primaryColorDark,
                                  ),)
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 1.5,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).primaryColorDark.withOpacity(0.5),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => Notification_Screen()));
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 20.0,
                                        width: 20.0,
                                        child: SvgPicture.asset("assets/sidemenu/notify.svg", height: 18.0, color: Theme.of(context).disabledColor,),
                                      ),
                                      const SizedBox(width: 10.0,),
                                      Text(
                                        "Notifications",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],), ),
                                  Flexible(child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18.0,
                                    color: Theme.of(context).primaryColorDark,
                                  ),)
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 1.5,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).primaryColorDark.withOpacity(0.5),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => Subscription_Screen()));
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 20.0,
                                        width: 20.0,
                                        child: SvgPicture.asset("assets/sidemenu/subs.svg", height: 18.0, color: Theme.of(context).disabledColor,),
                                      ),
                                      const SizedBox(width: 10.0,),
                                      Text(
                                        "Subscription",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],), ),
                                  Flexible(child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18.0,
                                    color: Theme.of(context).primaryColorDark,
                                  ),)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    Container(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 15.0, left: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Theme.of(context).canvasColor,
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => KYCPage()));
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 20.0,
                                        width: 20.0,
                                        child: SvgPicture.asset("assets/images/feed.svg", height: 18.0, color: Theme.of(context).disabledColor,),
                                        // child: Icon(Icons.file_present_outlined, size: 22.0,color: Theme.of(context).disabledColor),
                                      ),
                                      const SizedBox(width: 10.0,),
                                      Text(
                                        "KYC",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],), ),
                                  Flexible(child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18.0,
                                    color: Theme.of(context).primaryColorDark,
                                  ),)
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 1.5,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).primaryColorDark.withOpacity(0.5),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => GoogleTFAScreen()),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 20.0,
                                        width: 20.0,
                                        child: SvgPicture.asset("assets/sidemenu/security.svg", height: 18.0, color: Theme.of(context).disabledColor,),
                                      ),
                                      const SizedBox(width: 10.0,),
                                      Text(
                                        "Google Authenticator",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],), ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18.0,
                                    color: Theme.of(context).primaryColorDark,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 1.5,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).primaryColorDark.withOpacity(0.5),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 20.0,
                                      width: 20.0,
                                      child: SvgPicture.asset("assets/sidemenu/currency.svg", height: 18.0, color: Theme.of(context).disabledColor,),
                                    ),
                                    const SizedBox(width: 10.0,),
                                    Text(
                                      "Default Currencies",
                                      style: CustomWidget(context: context).CustomSizedTextStyle(
                                          14.0,
                                          Theme.of(context).focusColor,
                                          FontWeight.w400,
                                          'FontRegular'),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],), flex: 3,),
                                Flexible(child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "USDT & BTC",
                                      style: CustomWidget(context: context).CustomSizedTextStyle(
                                          10.0,
                                          Theme.of(context).primaryColorDark,
                                          FontWeight.w400,
                                          'FontRegular'),
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(width: 10.0,),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 18.0,
                                      color: Theme.of(context).primaryColorDark,
                                    )
                                  ],
                                ),flex: 2,)
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25.0,),
              Container(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "About & Support",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          16.0,
                          Theme.of(context).focusColor,
                          FontWeight.w600,
                          'FontRegular'),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 15.0,),
                    Container(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 15.0, left: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Theme.of(context).canvasColor,
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 20.0,
                                      width: 20.0,
                                      child: SvgPicture.asset("assets/sidemenu/terms.svg", height: 18.0, color: Theme.of(context).disabledColor,),
                                    ),
                                    const SizedBox(width: 10.0,),
                                    Text(
                                      "Terms and Privacy",
                                      style: CustomWidget(context: context).CustomSizedTextStyle(
                                          14.0,
                                          Theme.of(context).focusColor,
                                          FontWeight.w400,
                                          'FontRegular'),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],), ),
                                Flexible(child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18.0,
                                  color: Theme.of(context).primaryColorDark,
                                ),)
                              ],
                            ),
                          ),
                          Container(
                            height: 1.5,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).primaryColorDark.withOpacity(0.5),
                          ),
                         InkWell(
                           onTap: (){
                             Navigator.of(context).push(
                               MaterialPageRoute(
                                 builder: (context) => Support_Menu_Screen(),
                               ),
                             );
                           },
                           child:  Container(
                             padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
                             child: Row(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Flexible(child: Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     SizedBox(
                                       height: 20.0,
                                       width: 20.0,
                                       // child: SvgPicture.asset("assets/sidemenu/notify.svg", height: 18.0, color: Theme.of(context).disabledColor,),
                                       child: Icon(Icons.support_agent_outlined, size: 22.0,color: Theme.of(context).disabledColor),
                                     ),
                                     const SizedBox(width: 10.0,),
                                     Text(
                                       "Support",
                                       style: CustomWidget(context: context).CustomSizedTextStyle(
                                           14.0,
                                           Theme.of(context).focusColor,
                                           FontWeight.w400,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),
                                   ],), ),
                                 Flexible(child: Icon(
                                   Icons.arrow_forward_ios_rounded,
                                   size: 18.0,
                                   color: Theme.of(context).primaryColorDark,
                                 ),)
                               ],
                             ),
                           ),
                         ),
                          Container(
                            height: 1.5,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).primaryColorDark.withOpacity(0.5),
                          ),
                          InkWell(
                            onTap: (){
                              showSuccessAlertDialog(
                                  "Logout", "Are you sure want to Logout ?");
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 20.0,
                                        width: 20.0,
                                        child: SvgPicture.asset("assets/sidemenu/logout.svg", height: 18.0, color: Theme.of(context).disabledColor,),
                                      ),
                                      const SizedBox(width: 10.0,),
                                      Text(
                                        "Logout",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],), ),
                                  Flexible(child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18.0,
                                    color: Theme.of(context).primaryColorDark,
                                  ),)
                                ],
                              ),
                            ),
                          ),



                        ],
                      ),
                    )

                  ],
                ),
              ),
              const SizedBox(height: 100.0,),
            ],
          ),
        ),
      ),
    );
  }

  showSuccessAlertDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)), //this right here
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Theme.of(context).focusColor,
                // gradient: LinearGradient(
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                //   colors: <Color>[
                //     Theme.of(context).disabledColor,
                //    Theme.of(context).primaryColor,
                //   ],
                //   tileMode: TileMode.mirror,
                // ),
              ),
              height: MediaQuery.of(context).size.height * 0.22,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          17.0,
                          Theme.of(context).disabledColor,
                          FontWeight.w600,
                          'FontRegular'),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Theme.of(context).cardColor,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 7.0, bottom: 5.0),
                      height: 2.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                          colors: <Color>[
                            Theme.of(context).disabledColor,
                            Theme.of(context).disabledColor.withOpacity(0.5),
                            Theme.of(context).focusColor,
                          ],
                          tileMode: TileMode.mirror,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(child: GestureDetector(
                          onTap: (){
                            Navigator.of(context).pop(true);
                            setState(() {
                              callLogout();
                            });
                          },
                          child: Text(
                            "Okay",
                            style: TextStyle(
                              fontSize: 17.0,
                              color: Theme.of(context).disabledColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        ),flex: 1,),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                Theme.of(context).disabledColor,
                                Theme.of(context).disabledColor.withOpacity(0.5),
                                Theme.of(context).focusColor,
                              ],
                              tileMode: TileMode.mirror,
                            ),
                          ),
                          height: 40.0,
                          width: 1.5,
                        ),
                        Flexible(child: GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 17.0,
                              color: Theme.of(context).disabledColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        ),flex: 1,)

                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
    // show the dialog
  }

  Future callLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        // TODO:SET MYMAP
        builder: (BuildContext context) => Login_Screen(),
      ),
          (Route route) => false,
    );
  }

  profileDetails() {
    apiUtils.getProfileDetils().then((GetProfileModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          name = loginData.result!.name.toString();
          googleUpdate=loginData.result!.f2AStatus.toString()=="1"?true:false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        print("welcome");
        loading = false;
      });
    });
  }

}
