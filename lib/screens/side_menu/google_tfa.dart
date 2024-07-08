import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imperial/data/crypt_model/common_model.dart';
import 'package:imperial/data/crypt_model/profile_model.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/custom_widget.dart';
import '../../common/textformfield_custom.dart';
import '../../common/theme/custom_theme.dart';
import '../../data/api_utils.dart';
import '../../data/crypt_model/googleTFA_model.dart';

class GoogleTFAScreen extends StatefulWidget {
  // final String code;
  // final String type;

  const GoogleTFAScreen({
    Key? key,
     // required this.code,
    // required this.type,
  }) : super(key: key);

  @override
  State<GoogleTFAScreen> createState() => _GoogleTFAScreenState();
}

class _GoogleTFAScreenState extends State<GoogleTFAScreen> {
  APIUtils apiUtils = APIUtils();
  String appName = "ImperialX";

  bool codesent = false;
  // Googletfa? details;
  String qrCode = "";
  String qrImage = "";
  String status = "";
  TextEditingController code = TextEditingController();
  GlobalKey globalKeyauth = GlobalKey(debugLabel: 'auth');
  FocusNode codeFocus = FocusNode();
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loading = true;
    accessTwoFA();
    profileDetails();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: CustomTheme.of(context).cardColor,
            elevation: 0.0,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor:Colors.transparent,
              focusColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 25.0,
                  color: CustomTheme.of(context).focusColor,
                ),
              ),
            ),
            centerTitle: true,
            title: Text(
              "Google Authenticator",
              style: TextStyle(
                fontFamily: 'FontSpecial',
                color: CustomTheme.of(context).focusColor,
                fontWeight: FontWeight.w500,
                fontSize: 17.0,
              ),
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
             color: Theme.of(context).cardColor,
            ),
            child: Stack(
              children: [
                loading
                    ? CustomWidget(context: context).loadingIndicator(
                        Theme.of(context).disabledColor,
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10.0,
                              ),
                              Column(
                                      children: [
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        // qrImage == ""
                                        //     ? Container()
                                        //     :
                                        Container(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),
                                                    color: Theme.of(context)
                                                        .focusColor,
                                                    border: Border.all(
                                                      width: 0.2,
                                                      color: Theme.of(context)
                                                          .canvasColor,
                                                    )),
                                                child: QrImageView(
                                                  data:  "https://chart.googleapis.com/chart?chs=250x250&cht=qr&chl=" +
                                                      qrCode.toString(),
                                                  version: QrVersions.auto,
                                                  size: 155.0,
                                                ),
                                              ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        status=="true"? Container(): Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                qrCode,
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomTextStyle(
                                                        Theme.of(context)
                                                            .focusColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Clipboard.setData(ClipboardData(
                                                    text: qrCode.toString()));
                                                CustomWidget(context: context)
                                                    .showSuccessAlertDialog(
                                                        "Google TFA",
                                                        "Secret Key Copied to Clipboard...!",
                                                        "success");
                                              },
                                              icon: Icon(
                                                Icons.copy,
                                                color:
                                                    Theme.of(context).focusColor.withOpacity(0.4),
                                                size: 25.0,
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        codesent?
                                        TextFormFieldCustom(
                                          onEditComplete: () {
                                            codeFocus.unfocus();
                                            // FocusScope.of(context).requestFocus(signupPasswordFocus);
                                          },
                                          radius: 8.0,
                                          error: "Enter Google Code",
                                          textColor: CustomTheme.of(context).focusColor,
                                          borderColor: Colors.transparent,
                                          fillColor: CustomTheme.of(context)
                                              .canvasColor,
                                          hintStyle:
                                              CustomWidget(context: context)
                                                  .CustomSizedTextStyle(
                                                      15.0,
                                                      CustomTheme.of(context)
                                                          .dividerColor,
                                                      FontWeight.w400,
                                                      'FontRegular'),
                                          textStyle:
                                              CustomWidget(context: context)
                                                  .CustomTextStyle(
                                                      CustomTheme.of(context)
                                                          .focusColor,
                                                      FontWeight.w500,
                                                      'FontRegular'),
                                          textInputAction: TextInputAction.next,
                                          focusNode: codeFocus,
                                          maxlines: 1,
                                          text: '',
                                          hintText: "Google Code",
                                          obscureText: false,
                                          suffix: Container(
                                            width: 0.0,
                                          ),
                                          textChanged: (value) {},
                                          onChanged: () {},
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please enter Google Code";
                                            }
                                            return null;
                                          },
                                          enabled: true,
                                          textInputType: TextInputType.number,
                                          controller: code,
                                        ):Container(),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    ),

                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if(status=="true"){
                                      disTwoFA();
                                    }else if(codesent) {
                                    loading = true;
                                        verifyOTP();
                                    }
                                    else{
                                      codesent = true;
                                    }

                                    // if(codesent)
                                    //   {
                                    //     if(status=="true")
                                    //       {
                                    //         disTwoFA();
                                    //       }
                                    //     else{
                                    //       if (code.text.isEmpty) {
                                    //         CustomWidget(context: context)
                                    //             .showSuccessAlertDialog(
                                    //             "Google Authenticator",
                                    //             "Enter Goolge Auth Code",
                                    //             "error");
                                    //       } else {
                                    //         loading=true;
                                    //         verifyOTP();
                                    //       }
                                    //     }
                                    //   }
                                    // else{
                                    //  accessTwoFA();
                                    // }

                                  });
                                },
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor:Colors.transparent,
                                focusColor: Colors.transparent,
                                child: Container(
                                  padding:
                                      EdgeInsets.only(top: 12.0, bottom: 12.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).disabledColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    status=="true"? "Disable" :codesent? "Verify Code" :"Enable",
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            17.0,
                                            CustomTheme.of(context).focusColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Note :".toUpperCase(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context).hoverColor,
                                              FontWeight.w600,
                                              'FontRegular'),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "Keep the secret key at safe place, it allows you to recover your 2FA code if it's lost",
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context).focusColor,
                                              FontWeight.normal,
                                              'FontRegular'),
                                      textAlign: TextAlign.start,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          Navigator.of(context).pop(true);
          setState(() {
            loading = false;
          });
          return false;
        },
      ),
    );
  }

  accessTwoFA() {
    apiUtils.enableTwoFA().then((GoogleAuthCodeModel loginData) {
      if (loginData.success!) {
        setState(() {
          // loading = false;
          qrCode = loginData.result!.secret.toString();
          // CustomWidget(context: context).showSuccessAlertDialog(
          //     "Security", loginData.message.toString(), "success");
          profileDetails();
        });
      } else {
        setState(() {
          loading = false;
          codesent=false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Security", loginData.message.toString(), "error");
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

  disTwoFA() {
    apiUtils.disableTwoFA().then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          codesent=false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Security", loginData.message.toString(), "success");
          Navigator.pop(context, true);
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Security", loginData.message.toString(), "error");
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }


  verifyOTP() {
    apiUtils.veifyEmailOTP(code.text.toString()).then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          code.clear();
          CustomWidget(context: context).showSuccessAlertDialog(
              "Security", loginData.message.toString(), "success");
          Navigator.pop(context, true);
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Security", loginData.message.toString(), "error");
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

  profileDetails() {
    apiUtils.getProfileDetils().then((GetProfileModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          status = loginData.result!.f2AStatus!.toString();
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

  storeData(bool google) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("tfa", google);
  }
}
