import 'package:country_calling_code_picker/picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imperial/data/api_utils.dart';
import 'package:imperial/data/crypt_model/common_model.dart';
import 'package:imperial/screens/basic/login.dart';
import '../../common/custom_widget.dart';
import '../../common/localization/localizations.dart';
import '../../common/textformfield_custom.dart';
import '../../common/theme/custom_theme.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool loading = false;
  bool _passwordVisible = false;
  bool _confirmpasswordVisible = false;
  Country? _selectedCountry;
  TextEditingController mobile = TextEditingController();

  TextEditingController mobile_verify = TextEditingController();
  TextEditingController mobile_refer = TextEditingController();
  FocusNode mobileFocus = FocusNode();
  FocusNode mobilePassFocus = FocusNode();
  FocusNode mobileVerifyFocus = FocusNode();
  FocusNode mobileReferFocus = FocusNode();
  TextEditingController email = TextEditingController();
  TextEditingController email_password = TextEditingController();
  TextEditingController email_confirm_password = TextEditingController();
  TextEditingController email_verify = TextEditingController();
  TextEditingController email_refer = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode emailPassFocus = FocusNode();
  FocusNode confirmemailPassFocus = FocusNode();
  FocusNode emailVerifyFocus = FocusNode();
  FocusNode emailreferFocus = FocusNode();
  ScrollController controller = ScrollController();
  bool countryB = false;
  bool isMobile = false;
  bool isDisplay = true;
  bool isEmail = true;
  bool emailVerify = true;
  bool emailCodeVerify = false;
  bool emailPassVerify = false;
  bool emailReferVerify = false;
  final emailformKey = GlobalKey<FormState>();
  final mobileformKey = GlobalKey<FormState>();
  final verifyformKey = GlobalKey<FormState>();
  bool check = false;

  bool getCode = true;

  String token = "";
  var snackBar;

  bool mobileVerify = true;
  bool mobileCodeVerify = false;
  bool mobilePassVerify = true;

  bool mobileReferVerify = false;
  APIUtils apiUtils = APIUtils();

  @override
  void initState() {
    initCountry();
    super.initState();
  }

  void initCountry() async {
    final country = await getDefaultCountry(context);
    setState(() {
      _selectedCountry = country;
      countryB = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor, // For iOS: (dark icons)
            statusBarIconBrightness: Brightness.light, // For Android: (dark icons)
          ),
          elevation: 0.0,
          // toolbarHeight: 0.0,
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
                size: 20.0,
                color: Theme.of(context).focusColor,
              ),
            ),
          ),
          title: Text(
            AppLocalizations.instance.text("loc_forgot_pass"),
            style: CustomWidget(context: context)
                .CustomSizedTextStyle(
                18.0,
                Theme.of(context).focusColor,
                FontWeight.w600,
                'FontRegular'),
          ),
          centerTitle: true,

        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
             color: CustomTheme
                 .of(context)
                 .primaryColor,
            ),
            child: SingleChildScrollView(
              controller: controller,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 15.0,
                        ),
                        !getCode
                            ? Container()
                            : Text(
                            "Please enter your email that you use to sign up to CryptoCoin",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                14.0,
                                Theme.of(context).bottomAppBarColor,
                                FontWeight.w400,
                                'FontRegular')),
                        !getCode
                            ? Container()
                            : const SizedBox(
                          height: 30.0,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        !getCode
                            ? Container()
                            : emailWidget(),
                        getCode
                            ? Container()
                            : Form(
                          key: verifyformKey,
                          child: Column(children: [
                            TextFormFieldCustom(
                              onEditComplete: () {
                                mobileVerifyFocus.unfocus();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Code";
                                }

                                return null;
                              },
                              radius: 5.0,
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              // inputFormatters: [
                              //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9@.]')),
                              // ],
                              error: "Enter Valid Email",
                              textColor: CustomTheme.of(context)
                                  .focusColor,
                              borderColor: CustomTheme.of(context)
                                  .canvasColor,
                              fillColor: CustomTheme.of(context)
                                  .canvasColor,
                              textInputAction: TextInputAction.next,
                              focusNode: mobileVerifyFocus,
                              maxlines: 1,
                              text: '',
                              hintText: "Enter Verification Code",
                              obscureText: false,
                              suffix: Container(
                                width: 0.0,
                              ),
                              textChanged: (value) {},
                              onChanged: () {},
                              enabled: true,
                              textInputType: TextInputType.number,
                              controller: mobile_verify,
                              hintStyle: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                16.0,
                                  Theme.of(context)
                                      .dividerColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                              textStyle: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                16.0,
                                  Theme.of(context).focusColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextFormFieldCustom(
                              obscureText: !_passwordVisible,
                              textInputAction: TextInputAction.done,
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              // inputFormatters: [
                              //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@#0-9!_]')),
                              // ],
                              hintStyle: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                16.0,
                                  Theme.of(context)
                                      .dividerColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                              textStyle: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                16.0,
                                  Theme.of(context).focusColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                              radius: 5.0,
                              focusNode: emailPassFocus,
                              controller: email_password,
                              enabled: true,
                              textColor:
                              CustomTheme.of(context).splashColor,
                              borderColor: CustomTheme.of(context)
                                  .canvasColor,
                              fillColor: CustomTheme.of(context)
                                  .canvasColor,
                              onChanged: () {},
                              hintText: AppLocalizations.instance
                                  .text("loc_new_password"),
                              textChanged: (value) {},
                              suffix: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: CustomTheme.of(context)
                                      .splashColor
                                      .withOpacity(0.5),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Password";
                                }
                                else if(value.length<8){
                                  return "Please enter Valid  Password";
                                }

                                return null;
                              },
                              maxlines: 1,
                              error: "Enter Valid Password",
                              text: "",
                              onEditComplete: () {
                                emailPassFocus.unfocus();
                              },
                              textInputType:
                              TextInputType.visiblePassword,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextFormFieldCustom(
                              obscureText: !_confirmpasswordVisible,
                              textInputAction: TextInputAction.done,
                              // inputFormatters: [
                              //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@#0-9!_]')),
                              // ],
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              hintStyle: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                16.0,
                                  Theme.of(context)
                                      .dividerColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                              textStyle: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                16.0,
                                  Theme.of(context).focusColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                              radius: 5.0,
                              focusNode: confirmemailPassFocus,
                              controller: email_confirm_password,
                              enabled: true,
                              textColor:
                              CustomTheme.of(context).primaryColor,
                              borderColor: CustomTheme.of(context)
                                  .canvasColor,
                              fillColor: CustomTheme.of(context)
                                  .canvasColor,
                              onChanged: () {},
                              hintText: AppLocalizations.instance
                                  .text("loc_confirm_password"),
                              textChanged: (value) {},
                              suffix: IconButton(
                                icon: Icon(
                                  _confirmpasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: CustomTheme.of(context)
                                      .focusColor
                                      .withOpacity(0.5),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _confirmpasswordVisible =
                                    !_confirmpasswordVisible;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Confirm Password";
                                }
                                return null;
                              },
                              maxlines: 1,
                              error: "Enter Valid Password",
                              text: "",
                              onEditComplete: () {
                                confirmemailPassFocus.unfocus();
                              },
                              textInputType:
                              TextInputType.visiblePassword,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),

                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              width: MediaQuery.of(context).size.width,
                              child:  Text(
                                "Note:".toUpperCase(),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                    fontFamily: 'BALLOBHAI-REGULAR',
                                    fontSize: 12.0),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              width: MediaQuery.of(context).size.width,
                              child:  Text(
                                "To make your password more secure: (Minimum 8 characters,Use numbers,Use uppercase,Use lowercase and Use special characters)",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white.withOpacity(0.6),
                                    fontFamily: 'BALLOBHAI-REGULAR',
                                    fontSize: 11.0),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ]),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),

                        InkWell(
                          onTap: (){
                            setState(() {

                              FocusScope.of(context).unfocus();
                              if (getCode) {
                                if (isEmail) {
                                  if(email.text.isEmpty  || !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(email.text))                         {
                                    CustomWidget(context: context).showSuccessAlertDialog("Forgot", "Please Enter Email", "error");

                                  }
                                  else{
                                    loading = true;
                               sendCodeMail();
                                  }

                                } else {
                                  if(mobile.text.isEmpty)
                                  {
                                    CustomWidget(context: context).showSuccessAlertDialog("Forgot", "Please Enter Mobile Number", "error");

                                  }
                                  else {
                                    setState(() {

                                    });
                                  }
                                }
                              } else {
                                if (verifyformKey.currentState!.validate()) {
                                  if (email_password.text.toString() ==
                                      email_confirm_password.text
                                          .toString()) {
                                    if (isEmail) {
                                      setState(() {
                                      verifyMail();

                                      });
                                    } else {
                                      setState(() {

                                      });
                                    }
                                  } else {
                                    CustomWidget(context: context).showSuccessAlertDialog("Forgot Password",
                                        "Password and confirm password do not match", "error");
                                  }
                                }
                              }
                            });

                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                             color: Theme.of(context).disabledColor,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              getCode ? "Next" : "Verify Code",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  16.0,
                                  Theme.of(context).backgroundColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          child: Text(
                            "Cancel",
                            textAlign: TextAlign.center,
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                16.0,
                                Theme.of(context).primaryColor,
                                FontWeight.normal,
                                'FontRegular'),

                          ),
                        ),

                      ],
                    ),
                  ),
                  loading
                      ? CustomWidget(context: context).loadingIndicator(
                    CustomTheme.of(context).disabledColor,
                  )
                      : Container()
                ],
              ),
            )),
      ),
    );
  }


  Widget emailWidget() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "Email",
              style: CustomWidget(context: context)
                  .CustomSizedTextStyle(
                  14.0,
                  Theme.of(context).focusColor,
                  FontWeight.w500,
                  'FontRegular')),
          const SizedBox(height: 8.0,),
          TextFormFieldCustom(
            onEditComplete: () {
              emailFocus.unfocus();
              FocusScope.of(context).requestFocus(emailPassFocus);
            },
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            radius: 5.0,
            error: "Enter Valid Email",
            textColor: CustomTheme.of(context).focusColor,
            borderColor: CustomTheme.of(context).canvasColor,
            fillColor: CustomTheme.of(context).canvasColor,
            textInputAction: TextInputAction.next,
            focusNode: emailFocus,
            maxlines: 1,
            text: '',
            hintText: "Enter your email address",
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@0-9.]')),
            // ],
            obscureText: false,
            suffix: Container(
              width: 0.0,
            ),
            textChanged: (value) {},
            onChanged: () {},
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter email";
              } else if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value)) {
                return "Please enter valid email";
              }

              return null;
            },
            enabled: true,
            textInputType: TextInputType.emailAddress,
            controller: email,
            hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
              16.0,
                Theme.of(context).dividerColor,
                FontWeight.w400,
                'FontRegular'),
            textStyle: CustomWidget(context: context).CustomSizedTextStyle(
              16.0,
                Theme.of(context).focusColor, FontWeight.w500, 'FontRegular'),
          ),
          const SizedBox(
            height: 20.0,
          ),

        ],
      ),
      key: emailformKey,
    );
  }


  sendCodeMail() {
    apiUtils
        .forgotPassword(email.text.toString())
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          getCode = false;
          isDisplay=false;
        });
        // custombar("Forgot Password", loginData.message.toString(), true);
        CustomWidget(context: context).showSuccessAlertDialog("Forgot Password", loginData.message.toString(), "success");

      } else {
        setState(() {

          loading = false;
          // custombar("Forgot Password", loginData.message.toString(), false);
          CustomWidget(context: context).showSuccessAlertDialog("Forgot Password", loginData.message.toString(), "error");

        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }



  verifyMail() {
    apiUtils
        .doVerifyOTP(email.text.toString(),mobile_verify.text.toString(),email_password.text.toString(),)
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          emailVerify = true;

          email.clear();
          mobile_verify.clear();
          email_verify.clear();
          email_confirm_password.clear();

          mobileCodeVerify = true;
        });
        CustomWidget(context: context).showSuccessAlertDialog("Forgot Password", loginData.message.toString(), "success");


        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Login_Screen()));

      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog("Forgot Password", loginData.message.toString(), "error");


        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }



}
