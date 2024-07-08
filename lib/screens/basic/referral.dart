import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imperial/data/api_utils.dart';
import 'package:imperial/data/crypt_model/profile_model.dart';
import 'package:imperial/screens/basic/view_rules.dart';

import '../../common/custom_widget.dart';
import '../../common/localization/localizations.dart';
import '../../common/textformfield_custom.dart';

class Referral_Screen extends StatefulWidget {
  const Referral_Screen({Key? key}) : super(key: key);

  @override
  State<Referral_Screen> createState() => _Referral_ScreenState();
}

class _Referral_ScreenState extends State<Referral_Screen> {


  FocusNode codeFocus=new FocusNode();
  FocusNode linkFocus=new FocusNode();

  TextEditingController codeController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  bool loading = false;
  APIUtils apiUtils = APIUtils();
  String refCode = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;

    profileDetails();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: Padding(
            padding: EdgeInsets.only(right: 1.0),
            child: InkWell(
              onTap: (){
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 22.0,
                color: Theme.of(context).focusColor,
              ),
            ),
          ),

          title: Text(
            AppLocalizations.instance.text("loc_share_frnd"),
            style: CustomWidget(context: context).CustomSizedTextStyle(18.0,
                Theme.of(context).focusColor, FontWeight.w600, 'FontRegular'),
          ),
          centerTitle: true,
          actions: [
            Padding(padding: EdgeInsets.only(right: 10.0),child:  InkWell(
              child: Icon(
                Icons.info_outline,
                size: 20.0,
                color: Theme.of(context).focusColor,
              ),
            ),)
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
            child : Stack(
              children: [

                loading
                    ? CustomWidget(context: context).loadingIndicator(
                  Theme.of(context).disabledColor,
                )
                    : Referral(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget Referral(){
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Invite Friends and Earn \nCommissions!",
              style: CustomWidget(context: context).CustomSizedTextStyle(
                  16.0,
                  Theme.of(context).focusColor,
                  FontWeight.w700,
                  'FontRegular'),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10.0,),
            Text(
              "Earn up to 20% commission from every trade completed by your referees (you can also earn commissions from referees of previous program. Please read up on program rules.)",
              style: CustomWidget(context: context).CustomSizedTextStyle(
                  10.0,
                  Theme.of(context).focusColor.withOpacity(0.5),
                  FontWeight.w400,
                  'FontRegular'),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10.0,),
            InkWell(
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => View_Rules()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,)
                  // color: Theme.of(context).disabledColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "View Rules",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          9.0,
                          Theme.of(context).disabledColor,
                          FontWeight.w600,
                          'FontRegular'),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 5.0,),
                    Icon(
                      Icons.arrow_forward,
                      size: 10.0,
                      color: Theme.of(context).disabledColor,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25.0,),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Theme.of(context).canvasColor,
                // border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "30,000 USDT Deposit Blast-Off Rewards",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            12.0,
                            Theme.of(context).focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        "0",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            12.0,
                            Theme.of(context).focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0,),
                  InkWell(
                    onTap: (){
                      // Navigator.of(context).push(
                      //     MaterialPageRoute(builder: (context) => View_Rules()));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,)
                        // color: Theme.of(context).disabledColor,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Redeem",
                            style: CustomWidget(context: context).CustomSizedTextStyle(
                                9.0,
                                Theme.of(context).disabledColor,
                                FontWeight.w600,
                                'FontRegular'),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(width: 5.0,),
                          SvgPicture.asset("assets/menu/next.svg", height: 8.0, color: Theme.of(context).disabledColor,),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
            const SizedBox(height: 25.0,),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Theme.of(context).canvasColor,
                // border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Generate Invite Code and Link",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        14.0,
                        Theme.of(context).focusColor,
                        FontWeight.w500,
                        'FontRegular'),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 15.0,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "My Commission",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            14.0,
                            Theme.of(context).focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                        textAlign: TextAlign.start,
                      ),

                      Text(
                        "20%",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            16.0,
                            Theme.of(context).focusColor,
                            FontWeight.w700,
                            'FontRegular'),
                        textAlign: TextAlign.start,
                      ),

                    ],
                  ),
                  const SizedBox(height: 15.0,),
                  Text(
                    "Referral Code",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        14.0,
                        Theme.of(context).focusColor,
                        FontWeight.w500,
                        'FontRegular'),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 13.0, bottom: 13.0, left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color:  Theme.of(context).primaryColor,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          refCode.toString(),
                          style: CustomWidget(context: context).CustomSizedTextStyle(
                              14.0,
                              Theme.of(context).focusColor,
                              FontWeight.w500,
                              'FontRegular'),
                          textAlign: TextAlign.start,
                        ),
                        InkWell(
                          onTap: (){
                            if (refCode == "") {
                            } else {
                              Clipboard.setData(ClipboardData(text: refCode));
                              CustomWidget(context: context).showSuccessAlertDialog(
                                  "Referral", "Referral Id was Copied", "success");
                            }
                          },
                          child: Icon(
                            Icons.copy_outlined,
                            size: 16.0,
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // TextFormFieldCustom(
                  //   onEditComplete: () {
                  //     codeFocus.unfocus();
                  //     FocusScope.of(context).requestFocus(linkFocus);
                  //   },
                  //   radius: 6.0,
                  //   error: "Enter Email",
                  //   textColor: Theme.of(context).focusColor,
                  //   borderColor: Colors.transparent,
                  //   fillColor: Theme.of(context).primaryColor,
                  //   hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                  //       14.0, Theme.of(context).focusColor, FontWeight.w400, 'FontRegular'),
                  //   textStyle: CustomWidget(context: context).CustomSizedTextStyle(
                  //       14.0,
                  //       Theme.of(context).focusColor, FontWeight.w500, 'FontRegular'),
                  //   textInputAction: TextInputAction.next,
                  //   focusNode: codeFocus,
                  //   maxlines: 1,
                  //   text: '',
                  //   hintText: refCode.toString(),
                  //   obscureText: false,
                  //   suffix: InkWell(
                  //     onTap: (){
                  //       if (refCode == "") {
                  //       } else {
                  //         Clipboard.setData(ClipboardData(text: refCode));
                  //         CustomWidget(context: context).showSuccessAlertDialog(
                  //             "Referral", "Referral Id was Copied", "success");
                  //       }
                  //     },
                  //     child: Icon(
                  //       Icons.copy_outlined,
                  //       size: 16.0,
                  //       color: Theme.of(context).disabledColor,
                  //     ),
                  //   ),
                  //   textChanged: (value) {},
                  //   onChanged: () {},
                  //   validator: (value) {
                  //     return null;
                  //   },
                  //   enabled: false,
                  //   textInputType: TextInputType.text,
                  //   controller: codeController,
                  // ),
                  // const SizedBox(height: 15.0,),
                  // Text(
                  //   "Referral Link",
                  //   style: CustomWidget(context: context).CustomSizedTextStyle(
                  //       14.0,
                  //       Theme.of(context).focusColor,
                  //       FontWeight.w500,
                  //       'FontRegular'),
                  //   textAlign: TextAlign.start,
                  // ),
                  // const SizedBox(
                  //   height: 8.0,
                  // ),
                  // TextFormFieldCustom(
                  //   onEditComplete: () {
                  //     linkFocus.unfocus();
                  //   },
                  //   radius: 6.0,
                  //   error: "Enter Email",
                  //   textColor: Theme.of(context).focusColor,
                  //   borderColor: Colors.transparent,
                  //   fillColor: Theme.of(context).primaryColor,
                  //   hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                  //       14.0, Theme.of(context).dividerColor, FontWeight.w400, 'FontRegular'),
                  //   textStyle: CustomWidget(context: context).CustomSizedTextStyle(
                  //       14.0,
                  //       Theme.of(context).focusColor, FontWeight.w500, 'FontRegular'),
                  //   textInputAction: TextInputAction.next,
                  //   focusNode: linkFocus,
                  //   maxlines: 1,
                  //   text: '',
                  //   hintText: "Link",
                  //   obscureText: false,
                  //   suffix: InkWell(
                  //     child: Icon(
                  //       Icons.copy_outlined,
                  //       size: 16.0,
                  //       color: Theme.of(context).disabledColor,
                  //     ),
                  //   ),
                  //   textChanged: (value) {},
                  //   onChanged: () {},
                  //   validator: (value) {
                  //     // if (value!.isEmpty) {
                  //     //   return "Please enter Code";
                  //     // } else if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  //     //     .hasMatch(value)) {
                  //     //   return "Please enter valid email";
                  //     // }
                  //     return null;
                  //   },
                  //   enabled: false,
                  //   textInputType: TextInputType.text,
                  //   controller: linkController,
                  // ),
                  const SizedBox(height: 30.0,),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: (){
                        // Navigator.of(context).push(
                        //     MaterialPageRoute(builder: (context) => Subs_details()));
                      },
                      child: Container(
                        // width: MediaQuery.of(context).size.width * 0.4,
                        padding: EdgeInsets.only(top: 14.0, bottom: 14.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          // border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,)
                          color: Theme.of(context).disabledColor,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Invite Friends",
                              style: CustomWidget(context: context).CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).focusColor,
                                  FontWeight.w600,
                                  'FontRegular'),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(width: 5.0,),
                            Icon(
                              Icons.arrow_forward,
                              size: 16.0,
                              color: Theme.of(context).focusColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0,),

                ],
              ),
            ),
            const SizedBox(height: 25.0,),

            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/images/referral_1.svg", height: 80.0,),
                  const SizedBox(height: 15.0,),
                  Text(
                    "Invite Friends to Deposit",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        16.0,
                        Theme.of(context).focusColor,
                        FontWeight.w600,
                        'FontRegular'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10.0,),
                  Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0),child: Text(
                    "Invite your friend to sign up via your referral link and get them to deposit at least \$100 worth of asset(s) within seven (7) days of signing up. You'll each receive a 10 USDT reward.",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme.of(context).focusColor.withOpacity(0.5),
                        FontWeight.w400,
                        'FontRegular'),
                    textAlign: TextAlign.center,
                  ),),
                ],
              ),
            ),
            const SizedBox(height: 25.0,),

            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).disabledColor,
                    ),
                    child: SvgPicture.asset("assets/images/referral_2.svg", height: 80.0,),
                  ),
                  const SizedBox(height: 15.0,),
                  Text(
                    "Referee Trade",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        16.0,
                        Theme.of(context).focusColor,
                        FontWeight.w600,
                        'FontRegular'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10.0,),
                  Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0),child: Text(
                    "Get your referee to trade at least \$500 on within 30 days of signing up. You'll each receive a 15 USDT reward.",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme.of(context).focusColor.withOpacity(0.5),
                        FontWeight.w400,
                        'FontRegular'),
                    textAlign: TextAlign.center,
                  ),),
                ],
              ),
            ),
            const SizedBox(height: 25.0,),

            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/images/referral_3.svg", height: 80.0,),
                  const SizedBox(height: 15.0,),
                  Text(
                    "Trade More, Earn More",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        16.0,
                        Theme.of(context).focusColor,
                        FontWeight.w600,
                        'FontRegular'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10.0,),
                  Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0),child: Text(
                    "When your referee accumulates a trading volume of at least \$10,000, you'll each receive a Mystery Box worth up to 1,000 USDT.",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme.of(context).focusColor.withOpacity(0.5),
                        FontWeight.w400,
                        'FontRegular'),
                    textAlign: TextAlign.center,
                  ),),
                ],
              ),
            ),
            const SizedBox(height: 35.0,),

          ],
        ),
      ),
    );
  }

  profileDetails() {
    apiUtils.getProfileDetils().then((GetProfileModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          refCode = loginData.result!.referralCode.toString();
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
