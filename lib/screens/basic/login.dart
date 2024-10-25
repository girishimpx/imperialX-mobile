import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/functions.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:imperial/common/colors.dart';
import 'package:imperial/common/otp_fields/otp_style.dart';
import 'package:imperial/data/api_utils.dart';
import 'package:imperial/data/crypt_model/common_model.dart';
import 'package:imperial/data/crypt_model/login_model.dart';
import 'package:imperial/screens/basic/change_pass.dart';
import 'package:imperial/screens/basic/signup.dart';
import 'package:imperial/screens/basic/subscription.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../common/country.dart';
import '../../common/custom_widget.dart';
import '../../common/localization/localizations.dart';
import '../../common/otp_fields/otp_field_custom.dart';
import '../../common/otp_fields/style.dart';
import '../../common/textformfield_custom.dart';
import '../../common/theme/custom_theme.dart';
import '../../data/crypt_model/profile_model.dart';
import '../market.dart';
import 'forgot.dart';
import 'home.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({Key? key}) : super(key: key);

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen>
    with TickerProviderStateMixin {
  bool signin = false;
  bool email = false;
  FocusNode emailFocus = FocusNode();
  FocusNode signupEmailFocus = FocusNode();
  FocusNode fnameFocus = FocusNode();
  FocusNode lnameFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  FocusNode signupPasswordFocus = FocusNode();
  FocusNode conPassFocus = FocusNode();
  bool passVisible = false;
  bool conpassVisible = false;
  Country? _selectedCountry;
  var pinValue;
  bool countryB = false;
  FocusNode mobileFocus = new FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController signupEmailController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController conPasswordController = TextEditingController();

  final regformKey = GlobalKey<FormState>();
  final loginformKey = GlobalKey<FormState>();
  bool loading = false;
  APIUtils apiUtils = APIUtils();

  GoogleSignInAccount? _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoggedIn = false;
  String loginType = "";

  String? _sdkVersion;
  String? _email;
  String? _imageUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    signin = true;
    email = true;
    //
    //emailController.text="deposit@mailinator.com";
    //passwordController.text="deposit@123";
    initCountry();
  }

  void initCountry() async {
    final country = await getDefaultCountry(context);
    setState(() {
      _selectedCountry = country;
      countryB = true;
    });
  }

  void _onPressedShowBottomSheet() async {
    final country = await showCountryPickerSheets(
      context,
    );
    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor:
                Theme.of(context).primaryColor, // For iOS: (dark icons)
            statusBarIconBrightness:
                Brightness.light, // For Android: (dark icons)
          ),
          elevation: 0.0,
          // toolbarHeight: 0.0,
          leading: Padding(
              padding: EdgeInsets.only(left: 0.0, top: 5.0, bottom: 5.0),
              child: Container(
                width: 0.0,
              )),
          title: Text(
            AppLocalizations.instance.text("loc_login"),
            style: CustomWidget(context: context).CustomSizedTextStyle(18.0,
                Theme.of(context).focusColor, FontWeight.w600, 'FontRegular'),
          ),
          centerTitle: true,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Padding(
              padding: EdgeInsets.only(
                  left: 15.0, right: 15.0, bottom: 10.0, top: 10.0),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Form(
                            key: loginformKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.instance.text("loc_email"),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          14.0,
                                          CustomTheme.of(context).focusColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                TextFormFieldCustom(
                                  onEditComplete: () {
                                    emailFocus.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(passFocus);
                                  },
                                  radius: 8.0,
                                  error: "Enter Email",
                                  textColor: CustomTheme.of(context).focusColor,
                                  borderColor: Colors.transparent,
                                  fillColor: CustomTheme.of(context).canvasColor,
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      16.0,
                                      CustomTheme.of(context).dividerColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                                  textStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      16.0,
                                      CustomTheme.of(context).focusColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                  textInputAction: TextInputAction.next,
                                  focusNode: emailFocus,
                                  maxlines: 1,
                                  text: '',
                                  hintText: "Enter your email address",
                                  obscureText: false,
                                  suffix: Container(
                                    width: 0.0,
                                  ),
                                  textChanged: (value) {},
                                  onChanged: () {},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter email";
                                    } else if (!RegExp(
                                        r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)) {
                                      return "Please enter valid email";
                                    }
                                    return null;
                                  },
                                  enabled: true,
                                  textInputType: TextInputType.emailAddress,
                                  controller: emailController,
                                ),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                Text(
                                  AppLocalizations.instance.text("loc_password"),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      CustomTheme.of(context).focusColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                TextFormFieldCustom(
                                  obscureText: !passVisible,
                                  textInputAction: TextInputAction.next,
                                  textColor: CustomTheme.of(context).primaryColor,
                                  borderColor: Colors.transparent,
                                  fillColor: CustomTheme.of(context).canvasColor,
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      16.0,
                                      CustomTheme.of(context).dividerColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                                  textStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      16.0,
                                      CustomTheme.of(context).focusColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                  radius: 8.0,
                                  focusNode: passFocus,
                                  suffix: IconButton(
                                    icon: Icon(
                                      passVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: CustomTheme.of(context).dividerColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        passVisible = !passVisible;
                                      });
                                    },
                                  ),
                                  controller: passwordController,
                                  enabled: true,
                                  onChanged: () {},
                                  hintText: AppLocalizations.instance
                                      .text("loc_pass_hint"),
                                  textChanged: (value) {},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter Password";
                                    }

                                    return null;
                                  },
                                  maxlines: 1,
                                  error: "Enter Valid Password",
                                  text: "",
                                  onEditComplete: () {
                                    passFocus.unfocus();
                                  },
                                  textInputType: TextInputType.visiblePassword,
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => ForgotPassword()));
                                  },
                                  child: Text(
                                    AppLocalizations.instance
                                        .text("loc_forgot_password"),
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        14.0,
                                        Theme.of(context).disabledColor,
                                        FontWeight.w400,
                                        'FontRegular'),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                const SizedBox(
                                  height: 40.0,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                     // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Home_Screen(),));
                                      if (loginformKey.currentState!.validate()) {
                                        loading = true;

                                        verifyMail();
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding:
                                    EdgeInsets.only(top: 12.0, bottom: 12.0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).disabledColor,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      AppLocalizations.instance.text("loc_login"),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          18.0,
                                          Theme.of(context).primaryColorLight,
                                          FontWeight.w500,
                                          'FontRegular'),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 35.0,
                                ),

                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 10.0),
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () {
                                   _googleSignIn.disconnect();

                                    _googleSignIn.signIn().then((userData) {
                                      setState(() {
                                        _isLoggedIn = true;
                                        loginType = _isLoggedIn.toString();
                                        _userObj = userData;
                                        print("userData" + userData.toString());
                                        print(userData!.email.toString());
                                        print(userData.displayName.toString());
                                        //   googleLogin();
                                        loading = true;
                                        loginGoogle(userData.displayName.toString(),userData.email.toString());

                                      });
                                    }).catchError((e) {
                                      print(e);
                                    });
                                  },
                                  child: Container(  alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),
                                                    // color: Theme.of(context).disabledColor,
                                                    border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,)),
                                                width: MediaQuery.of(context).size.width * 0.6,
                                                // child: SvgPicture.asset("assets/images/g_logo.svg", height: 25.0,),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/g_logo.png",
                                                      height: 25.0,
                                                    ),
                                                    SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    Text(
                                                      "Login with Google",
                                                      style: CustomWidget(
                                                          context: context)
                                                          .CustomSizedTextStyle(
                                                          16.0,
                                                          // Theme.of(context).backgroundColor,
                                                          Theme.of(context).disabledColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      )
                                  )),
                              const SizedBox(
                                height: 20.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Signup_Screen()));
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have account?",
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          14.0,
                                          CustomTheme.of(context).dividerColor,
                                          FontWeight.w400,
                                          'FontRegular'),
                                    ),
                                    Text(
                                      " Create an account",
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          14.0,
                                          CustomTheme.of(context).disabledColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                    ),
                                  ],
                                ),
                              )
                            ],
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
              )),
        ),
      ),
    );
  }

  verifyMail() {
    apiUtils
        .doLoginEmail(
      emailController.text.toString(),
      passwordController.text.toString(),
    )
        .then((LoginDetailsModel loginData) {
      if (loginData.success!) {
        setState(() {
          //loading = false;
          // if(loginData.result.user.){
          //
          // }
          storeData(loginData.result!.token.toString(), loginData.result!.user!.traderType.toString(),loginData.result!.user!.id.toString(),
            loginData.result!.user!.email.toString(),passwordController.text.toString(), loginData.result!.user!.name.toString()
          );
          profileDetails();
          emailController.clear();
          passwordController.clear();
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
  profileDetails() {
    apiUtils.getProfileDetils().then((GetProfileModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          if(loginData.result?.f2AStatus=="true"){
            viewDetails(context,"Verify Google Authenticator");
          }
          else{
            setState(() {
              CustomWidget(context: context).showSuccessAlertDialog(
                  "Login", loginData.message.toString(), "success");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home_Screen(),));
            });

          }
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {

      setState(() {

        loading = false;
      });
    });
  }

  viewDetails(BuildContext contexts,String textData) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,shape: OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: BorderSide(color: Theme.of(context).indicatorColor)),
        backgroundColor: Theme.of(context).cardColor,elevation: 4.0,
        builder: (context) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter ssetState) {
                return Container(
                  margin: EdgeInsets.only(top: 5.0),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                    right: 5.0,
                    left: 0.0,
                  ),
                  decoration: BoxDecoration(
                      color: CustomTheme.of(context).cardColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0),
                      )),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 30.0,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    textData,
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        16.0,
                                        Theme.of(context).focusColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(
                                    height: 35.0,
                                  ),
                                  OTPTextField(otpFieldStyle:OtpFieldStyle(backgroundColor: Theme.of(context).canvasColor.withOpacity(0.7),borderColor: Theme.of(context).focusColor,),

                                    length: 6,
                                    width: MediaQuery.of(context).size.width,
                                    fieldWidth: 45,
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        14.0,
                                        Theme.of(context).cardColor,
                                        FontWeight.w600,
                                        'FontRegular'),
                                    textFieldAlignment:
                                    MainAxisAlignment.spaceAround,
                                    fieldStyle: FieldStyle.underline,
                                    onCompleted: (pin) {
                                      setState(() {
                                        pinValue = pin;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 45.0,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      onTap: () {
                                        // if(type=="google") {
                                          if (pinValue.isEmpty ||
                                              pinValue.length < 6) {
                                            CustomWidget(context: context)
                                                .showSuccessAlertDialog(
                                                "Login",
                                                "Please enter OTP",
                                                "error");
                                          } else {
                                            ssetState(() {
                                              loading = true;
                                              confirmTwoFA();
                                              Navigator.pop(context);
                                            });
                                          }
                                       // }
                                        // else{
                                        //   if (pinValue.isEmpty ||
                                        //       pinValue.length < 6) {
                                        //     CustomWidget(context: context)
                                        //         .showSuccessAlertDialog(
                                        //         "Login",
                                        //         "Please enter OTP",
                                        //         "error");
                                        //   } else {
                                        //     ssetState(() {
                                        //       loading = true;
                                        //       confirmTwoFA();
                                        //       Navigator.pop(context);
                                        //     });
                                        //   }
                                        // }
                                      },
                                      child: Container(
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.6,
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 10.0, 0.0, 10.0),
                                        decoration: BoxDecoration(
                                          // border: Border.all(
                                          //   width: 1.0,
                                          //   color: Theme.of(context).cardColor,
                                          // ),
                                          borderRadius:
                                          BorderRadius.circular(6.0),
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: <Color>[
                                              CustomTheme.of(context).indicatorColor,
                                              CustomTheme.of(context)
                                                  .indicatorColor,
                                            ],
                                            tileMode: TileMode.mirror,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Verify",
                                            style:
                                            CustomWidget(context: context)
                                                .CustomSizedTextStyle(
                                                16.0,
                                                Theme.of(context)
                                                    .cardColor,
                                                FontWeight.w500,
                                                'FontRegular'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  // Align(
                                  //   alignment: Alignment.center,
                                  //   child: InkWell(
                                  //     onTap: (){
                                  //       ssetState(() {
                                  //         loading=true;
                                  //         resndOTP();
                                  //       });
                                  //
                                  //
                                  //     },
                                  //     child: Text(
                                  //       "Resend OTP",
                                  //       style: CustomWidget(context: context)
                                  //           .CustomSizedTextStyle(
                                  //           14.0,
                                  //           Theme.of(context).shadowColor,
                                  //           FontWeight.w800,
                                  //           'FontRegular'),
                                  //     ),
                                  //   ),
                                  // ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                );
              }),
        ));
  }
  confirmTwoFA() {
    apiUtils.veifyEmailOTP( pinValue.toString())
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog("Login", loginData.message.toString(), "success");
          //storeData(loginData.result!.accessToken.toString());
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home_Screen(),));
        });

      }
      else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog("Login", loginData.message.toString(), "error");
        });
      }
    }).catchError((Object error) {
      print("Mano");
      print(error);
      setState(() {
        loading = false;
      });
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

          CustomWidget(context: context).showSuccessAlertDialog(
              "Login", loginData.message.toString(), "success");
          storeData(
            loginData.result!.token.toString(),loginData.result!.user!.traderType.toString(),loginData.result!.user!.id.toString(),
              loginData.result!.user!.email.toString(),"",name
          );
        });

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Home_Screen(),
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
}
