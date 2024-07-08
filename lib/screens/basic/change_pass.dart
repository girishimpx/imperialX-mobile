import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/custom_widget.dart';
import '../../common/localization/localizations.dart';
import '../../common/textformfield_custom.dart';
import '../../data/api_utils.dart';
import '../../data/crypt_model/common_model.dart';

class Change_Password extends StatefulWidget {
  const Change_Password({Key? key}) : super(key: key);

  @override
  State<Change_Password> createState() => _Change_PasswordState();
}

class _Change_PasswordState extends State<Change_Password> {

  bool cPassVisible = false;
  bool conPassVisible = false;
  bool nPassVisible = false;

  FocusNode cPassFocus = FocusNode();
  FocusNode nPassFocus = FocusNode();
  FocusNode conPassFocus = FocusNode();
  TextEditingController cPassController = TextEditingController();
  TextEditingController nPassController = TextEditingController();
  TextEditingController conPassController = TextEditingController();

  APIUtils apiUtils = APIUtils();
  bool loading = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
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
                size: 20.0,
                color: Theme.of(context).focusColor,
              ),
            ),
          ),

          title: Text(
            AppLocalizations.instance.text("loc_change_password"),
            style: CustomWidget(context: context).CustomSizedTextStyle(18.0,
                Theme.of(context).focusColor, FontWeight.w600, 'FontRegular'),
          ),
          centerTitle: true,
        ),

        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).primaryColor,
          child: Stack(
            children: [
              Padding(
                padding:
                EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 10.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Current Password",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).shadowColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            TextFormFieldCustom(
                              obscureText: !cPassVisible,
                              textInputAction: TextInputAction.next,
                              textColor: Theme.of(context).primaryColor,
                              borderColor: Colors.transparent,
                              fillColor: Theme.of(context).canvasColor,
                              hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                                  14.0, Theme.of(context).dividerColor, FontWeight.w400, 'FontRegular'),
                              textStyle: CustomWidget(context: context).CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).focusColor, FontWeight.w500, 'FontRegular'),
                              radius: 8.0,
                              focusNode: cPassFocus,
                              suffix:  IconButton(
                                icon: Icon(
                                  cPassVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  setState(() {
                                    cPassVisible = !cPassVisible;
                                  });
                                },
                              ),
                              controller: cPassController,
                              enabled: true,
                              onChanged: () {},
                              hintText: "Enter your current password",
                              textChanged: (value) {},
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter current password";
                                }

                                return null;
                              },
                              maxlines: 1,
                              error: "Enter valid current password",
                              text: "",
                              onEditComplete: () {
                                cPassFocus.unfocus();
                                FocusScope.of(context).requestFocus(nPassFocus);
                              },
                              textInputType: TextInputType.visiblePassword,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              "New Password",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).shadowColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            TextFormFieldCustom(
                              obscureText: !nPassVisible,
                              textInputAction: TextInputAction.next,
                              textColor: Theme.of(context).primaryColor,
                              borderColor: Colors.transparent,
                              fillColor: Theme.of(context).canvasColor,
                              hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                                  14.0, Theme.of(context).dividerColor, FontWeight.w400, 'FontRegular'),
                              textStyle: CustomWidget(context: context).CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).focusColor, FontWeight.w500, 'FontRegular'),
                              radius: 8.0,
                              focusNode: nPassFocus,
                              suffix: IconButton(
                                icon: Icon(
                                  nPassVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  setState(() {
                                    nPassVisible = !nPassVisible;
                                  });
                                },
                              ),
                              controller: nPassController,
                              enabled: true,
                              onChanged: () {},
                              hintText: "Enter your new password",
                              textChanged: (value) {},
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter new password";
                                }

                                return null;
                              },
                              maxlines: 1,
                              error: "Enter valid new password",
                              text: "",
                              onEditComplete: () {
                                nPassFocus.unfocus();
                              },
                              textInputType: TextInputType.visiblePassword,
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "At least 5 characters with uppercase letters and numbers",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  12.0,
                                  Theme.of(context).primaryColorDark,
                                  FontWeight.w400,
                                  'FontRegular'),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              "Confirm New Password",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).shadowColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            TextFormFieldCustom(
                              obscureText: !conPassVisible,
                              textInputAction: TextInputAction.next,
                              textColor: Theme.of(context).primaryColor,
                              borderColor: Colors.transparent,
                              fillColor: Theme.of(context).canvasColor,
                              hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                                  14.0, Theme.of(context).dividerColor, FontWeight.w400, 'FontRegular'),
                              textStyle: CustomWidget(context: context).CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).focusColor, FontWeight.w500, 'FontRegular'),
                              radius: 8.0,
                              focusNode: conPassFocus,
                              suffix: IconButton(
                                icon: Icon(
                                  conPassVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  setState(() {
                                    conPassVisible = !conPassVisible;
                                  });
                                },
                              ),
                              controller: conPassController,
                              enabled: true,
                              onChanged: () {},
                              hintText: "Repeat your new password",
                              textChanged: (value) {},
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Repeat your new password";
                                }

                                return null;
                              },
                              maxlines: 1,
                              error: "Enter valid password",
                              text: "",
                              onEditComplete: () {
                                conPassFocus.unfocus();
                              },
                              textInputType: TextInputType.visiblePassword,
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                FocusScope.of(context).unfocus();
                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    if(nPassController.text.toString()==conPassController.text.toString())
                                    {
                                      loading=true;
                                      verifyMail();
                                    }
                                    else
                                    {
                                      CustomWidget(context: context).showSuccessAlertDialog("Change Password", "New Password and Confirm Password Mismatched", "error");

                                    }
                                  });
                                }
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                AppLocalizations.instance.text("loc_change_password"),
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context).primaryColorLight,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              loading
                  ? CustomWidget(context: context)
                  .loadingIndicator(Theme.of(context).disabledColor)
                  : Container()
            ],
          ),
        ),

      ),
    );
  }


  verifyMail() {
    apiUtils
        .doChangePassword(cPassController.text.toString(),nPassController.text.toString())
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          cPassController.clear();
          nPassController.clear();
          conPassController.clear();

        });
        CustomWidget(context: context).showSuccessAlertDialog("Change Password", loginData.message.toString(), "success");
        Navigator.pop(context);

      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog("Change Password", loginData.message.toString(), "error");

        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }
}
