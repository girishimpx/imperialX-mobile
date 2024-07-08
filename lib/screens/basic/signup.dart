import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imperial/common/textformfield_custom.dart';
import 'package:imperial/data/api_utils.dart';
import 'package:imperial/data/crypt_model/common_model.dart';

import '../../common/custom_widget.dart';
import '../../common/localization/localizations.dart';
import '../../common/theme/custom_theme.dart';
import 'login.dart';

class Signup_Screen extends StatefulWidget {
  const Signup_Screen({Key? key}) : super(key: key);

  @override
  State<Signup_Screen> createState() => _Signup_ScreenState();
}

class _Signup_ScreenState extends State<Signup_Screen> {


  bool check = false;
  bool refCheck = false;

  final regformKey = GlobalKey<FormState>();
  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode PasswordFocus = FocusNode();
  FocusNode conPassFocus = FocusNode();
  FocusNode referralFocus = FocusNode();
  bool passVisible = false;
  bool conpassVisible = false;
  bool loading=false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController conPasswordController = TextEditingController();
  TextEditingController referralController = TextEditingController();
  APIUtils apiUtils=APIUtils();


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
            AppLocalizations.instance.text("loc_sign_up"),
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0, top: 10.0),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Form(
                              key: regformKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.instance.text("loc_name") ,
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
                                    onEditComplete: () {
                                      nameFocus.unfocus();
                                      FocusScope.of(context).requestFocus(emailFocus);
                                    },
                                    radius: 8.0,
                                    error: "Enter Name",
                                    textColor: CustomTheme.of(context).focusColor,
                                    borderColor: Colors.transparent,
                                    fillColor: CustomTheme.of(context).canvasColor,
                                    hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                                        16.0, CustomTheme.of(context).dividerColor, FontWeight.w400, 'FontRegular'),
                                    textStyle: CustomWidget(context: context).CustomSizedTextStyle(
                                        16.0,
                                        CustomTheme.of(context).focusColor, FontWeight.w500, 'FontRegular'),
                                    textInputAction: TextInputAction.next,
                                    focusNode: nameFocus,
                                    maxlines: 1,
                                    text: '',
                                    hintText: "Enter your name",
                                    obscureText: false,
                                    suffix: Container(
                                      width: 0.0,
                                    ),
                                    textChanged: (value) {},
                                    onChanged: () {},
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter Name";
                                      } else if(value.length <= 2){
                                        return "Enter Minimumm 3 letters in name ";
                                      }
                                      return null;
                                    },
                                    enabled: true,
                                    textInputType: TextInputType.text,
                                    controller: nameController,
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  const SizedBox(height: 8.0,),
                                  TextFormFieldCustom(
                                    onEditComplete: () {
                                      emailFocus.unfocus();
                                      FocusScope.of(context).requestFocus(PasswordFocus);
                                    },
                                    radius: 8.0,
                                    error: "Enter Email",
                                    textColor: CustomTheme.of(context).focusColor,
                                    borderColor: Colors.transparent,
                                    fillColor: CustomTheme.of(context).canvasColor,
                                    hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                                        16.0, CustomTheme.of(context).dividerColor, FontWeight.w400, 'FontRegular'),
                                    textStyle: CustomWidget(context: context).CustomSizedTextStyle(
                                        16.0,
                                        CustomTheme.of(context).focusColor, FontWeight.w500, 'FontRegular'),
                                    textInputAction: TextInputAction.next,
                                    focusNode: emailFocus,
                                    maxlines: 1,
                                    text: '',
                                    hintText: AppLocalizations.instance.text("loc_email_hint"),
                                    obscureText: false,
                                    suffix: Container(
                                      width: 0.0,
                                    ),
                                    textChanged: (value) {},
                                    onChanged: () {},
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter Email";
                                      } else if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value)) {
                                        return "Please enter valid Email";
                                      }
                                      return null;
                                    },
                                    enabled: true,
                                    textInputType: TextInputType.emailAddress,
                                    controller: emailController,
                                  ),
                                  const SizedBox(
                                    height: 20.0,
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
                                    textColor: CustomTheme.of(context).focusColor,
                                    borderColor: Colors.transparent,
                                    fillColor: CustomTheme.of(context).canvasColor,
                                    hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                                        16.0, CustomTheme.of(context).dividerColor, FontWeight.w400, 'FontRegular'),
                                    textStyle: CustomWidget(context: context).CustomSizedTextStyle(
                                        16.0,
                                        CustomTheme.of(context).focusColor, FontWeight.w500, 'FontRegular'),
                                    radius: 8.0,
                                    focusNode: PasswordFocus,
                                    suffix: IconButton(
                                      icon: Icon(
                                        passVisible ? Icons.visibility : Icons.visibility_off,
                                        color: CustomTheme.of(context).dividerColor,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          passVisible = !passVisible;
                                        });
                                      },
                                    ),
                                    controller: PasswordController,
                                    enabled: true,
                                    onChanged: () {},
                                    hintText: AppLocalizations.instance.text("loc_pass_hint"),
                                    textChanged: (value) {},
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter Password";
                                      }
                                      else if(value.length <= 7){
                                        return "Please enter 8 characters Password";
                                      }

                                      return null;
                                    },
                                    maxlines: 1,
                                    error: "Enter Valid Password",
                                    text: "",
                                    onEditComplete: () {
                                      PasswordFocus.unfocus();
                                    },
                                    textInputType: TextInputType.visiblePassword,
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(
                                    "At least 8 characters with uppercase letters and numbers",
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        12.0,
                                        CustomTheme.of(context).primaryColorDark,
                                        FontWeight.w400,
                                        'FontRegular'),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    AppLocalizations.instance.text("loc_conf_password"),
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
                                    obscureText: !conpassVisible,
                                    textInputAction: TextInputAction.next,
                                    textColor: CustomTheme.of(context).focusColor,
                                    borderColor: Colors.transparent,
                                    fillColor: CustomTheme.of(context).canvasColor,
                                    hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                                        16.0, CustomTheme.of(context).dividerColor, FontWeight.w400, 'FontRegular'),
                                    textStyle: CustomWidget(context: context).CustomSizedTextStyle(
                                        16.0,
                                        CustomTheme.of(context).focusColor, FontWeight.w500, 'FontRegular'),
                                    radius: 8.0,
                                    focusNode: conPassFocus,
                                    suffix: IconButton(
                                      icon: Icon(
                                        conpassVisible ? Icons.visibility : Icons.visibility_off,
                                        color: CustomTheme.of(context).dividerColor,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          conpassVisible = !conpassVisible;
                                        });
                                      },
                                    ),
                                    controller: conPasswordController,
                                    enabled: true,
                                    onChanged: () {},
                                    hintText: AppLocalizations.instance.text("loc_pass_hint"),
                                    textChanged: (value) {},
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter Confirm Password";
                                      }
                                      // else if(conPasswordController!=PasswordController){
                                      //   return "Confirm Password Mismatched";
                                      // }

                                      return null;
                                    },
                                    maxlines: 1,
                                    error: "Enter Valid Password",
                                    text: "",
                                    onEditComplete: () {
                                      conPassFocus.unfocus();
                                    },
                                    textInputType: TextInputType.visiblePassword,
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 23.0,
                                        width: 23.0,
                                        child: Checkbox(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                          value: refCheck,
                                          activeColor: Theme.of(context).focusColor,
                                          checkColor: Theme.of(context).primaryColorDark,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              refCheck = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Flexible(child: RichText(
                                        text: TextSpan(
                                          text: 'Do you have Referal Code ',
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                              14.0,
                                              Theme.of(context).disabledColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                          // children: <TextSpan>[
                                          //   TextSpan(text: 'Terms of Use & Privacy Policy', style: CustomWidget(context: context)
                                          //       .CustomSizedTextStyle(
                                          //       14.0,
                                          //       Theme.of(context).disabledColor,
                                          //       FontWeight.w400,
                                          //       'FontRegular')),
                                          // ],
                                        ),
                                      ),),
                                      //Checkbox
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  refCheck ? TextFormFieldCustom(
                                    onEditComplete: () {
                                      referralFocus.unfocus();
                                      // FocusScope.of(context).requestFocus(emailFocus);
                                    },
                                    radius: 8.0,
                                    error: "Enter Referral Code",
                                    textColor: CustomTheme.of(context).focusColor,
                                    borderColor: Colors.transparent,
                                    fillColor: CustomTheme.of(context).canvasColor,
                                    hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                                        16.0, CustomTheme.of(context).dividerColor, FontWeight.w400, 'FontRegular'),
                                    textStyle: CustomWidget(context: context).CustomSizedTextStyle(
                                        16.0,
                                        CustomTheme.of(context).focusColor, FontWeight.w500, 'FontRegular'),
                                    textInputAction: TextInputAction.next,
                                    focusNode: referralFocus,
                                    maxlines: 1,
                                    text: '',
                                    hintText: "Enter referral code",
                                    obscureText: false,
                                    suffix: Container(
                                      width: 0.0,
                                    ),
                                    textChanged: (value) {},
                                    onChanged: () {},
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please Enter Referral Code";
                                      }
                                      return null;
                                    },
                                    enabled: true,
                                    textInputType: TextInputType.number,
                                    controller: referralController,
                                  ) : Container(),
                                  refCheck ?  const SizedBox(
                                    height: 20.0,
                                  ) : SizedBox(),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 23.0,
                                        width: 23.0,
                                        child: Checkbox(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                          value: check,
                                          activeColor: Theme.of(context).focusColor,
                                          checkColor: Theme.of(context).primaryColorDark,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              check = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Flexible(child: RichText(
                                        text: TextSpan(
                                          text: 'Accept ',
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                              14.0,
                                              Theme.of(context).primaryColorDark,
                                              FontWeight.w400,
                                              'FontRegular'),
                                          children: <TextSpan>[
                                            TextSpan(text: 'Terms of Use & Privacy Policy', style: CustomWidget(context: context)
                                                .CustomSizedTextStyle(
                                                14.0,
                                                Theme.of(context).disabledColor,
                                                FontWeight.w400,
                                                'FontRegular')),
                                          ],
                                        ),
                                      ),),
                                      //Checkbox
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 45.0,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          setState(() {
                                            if(regformKey.currentState!.validate() || refCheck)
                                            {
                                              if(check){
                                                loading=true;
                                                registerMail();
                                              } else if(refCheck){
                                                CustomWidget(context: context).showSuccessAlertDialog("Register", "Fill the referral code", "error");
                                              } else{
                                                CustomWidget(context: context).showSuccessAlertDialog("Register", "Accept Terms of Use & Privacy Policy", "error");
                                              }
                                            }
                                          });

                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).disabledColor,
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: Text(
                                            AppLocalizations.instance.text("loc_sign_up"),
                                            style: CustomWidget(context: context)
                                                .CustomSizedTextStyle(
                                                16.0,
                                                CustomTheme.of(context).cardColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                    ],
                                  )



                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(bottom: 25.0, top: 30.0),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => Login_Screen()));
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account?" ,
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        14.0,
                                        CustomTheme.of(context).dividerColor,
                                        FontWeight.w400,
                                        'FontRegular'),
                                  ),
                                  Text(
                                    " Log in!" ,
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        14.0,
                                        CustomTheme.of(context).disabledColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    loading
                        ? CustomWidget(context: context).loadingIndicator(
                      CustomTheme.of(context).disabledColor,
                    )
                        : Container()
                  ],
                )
            ),
          ),
        ),
      ),
    );
  }

registerMail() {
  apiUtils
      .doVerifyRegister(
      nameController.text.toString(),
      emailController.text.toString(),
      PasswordController.text.toString(), referralController.text.toString()
     )
      .then((CommonModel loginData) {
    if (loginData.status!) {
      setState(() {
        loading = false;

        nameController.clear();
        emailController.clear();
        PasswordController.clear();
        conPasswordController.clear();
        CustomWidget(context: context).showSuccessAlertDialog("Register", loginData.message.toString(), "success");
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Login_Screen()));

      });


    } else {
      setState(() {
        loading = false;
        CustomWidget(context: context).showSuccessAlertDialog("Register", loginData.message.toString(), "error");

      });
    }
  }).catchError((Object error) {
    print(error);
    setState(() {
      loading = false;
    });
  });
}
}
