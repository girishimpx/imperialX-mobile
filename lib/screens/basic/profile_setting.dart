//profile
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:imperial/screens/basic/change_pass.dart';

import '../../common/custom_widget.dart';
import '../../common/localization/localizations.dart';
import '../../data/api_utils.dart';
import '../../data/crypt_model/profile_model.dart';
import 'change_pass.dart';

class Profile_Settings extends StatefulWidget {
  const Profile_Settings({Key? key}) : super(key: key);

  @override
  State<Profile_Settings> createState() => _Profile_SettingsState();
}

class _Profile_SettingsState extends State<Profile_Settings> {

  APIUtils apiUtils = APIUtils();
  bool loading = false;
  // GetProfileResult? details;
  String name= "";
  String email= "";



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileDetails();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
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
            AppLocalizations.instance.text("loc_prof_set"),
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
                padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Name",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context).focusColor,
                                      FontWeight.w600,
                                      'FontRegular'),
                                  textAlign: TextAlign.start,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *0.4,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        // "Johny Kim",
                                        // details!.name.toString()==null || details!.name.toString()=="null"?"-":details!.name.toString(),
                                        name,
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            12.0,
                                            Theme.of(context).bottomAppBarColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14.0,
                                      color: Theme.of(context).bottomAppBarColor,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 1.5,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).canvasColor,
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => Change_Password()));
                            },
                            child: Container(
                              padding: EdgeInsets.only(bottom: 15.0, top: 15.0),
                              child:  Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Change Password",
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        14.0,
                                        Theme.of(context).focusColor,
                                        FontWeight.w600,
                                        'FontRegular'),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14.0,
                                    color: Theme.of(context).bottomAppBarColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 1.5,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).canvasColor,
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 15.0, top: 15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(child:  Text(
                                  "Email",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context).focusColor,
                                      FontWeight.w600,
                                      'FontRegular'),
                                  textAlign: TextAlign.start,
                                ), flex: 2,),
                                Flexible(child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      // "johny@gmail.com",
                                      // details!.email.toString()== "null" || details!.email.toString()== null ?"-":details!.email.toString(),
                                      email,
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          12.0,
                                          Theme.of(context).bottomAppBarColor,
                                          FontWeight.w400,
                                          'FontRegular'),
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14.0,
                                      color: Theme.of(context).bottomAppBarColor,
                                    )
                                  ],
                                ), flex: 3,)
                              ],
                            ),
                          ),
                          Container(
                            height: 1.5,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).canvasColor,
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 15.0, top: 15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Language",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context).focusColor,
                                      FontWeight.w600,
                                      'FontRegular'),
                                  textAlign: TextAlign.start,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "English",
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          12.0,
                                          Theme.of(context).bottomAppBarColor,
                                          FontWeight.w400,
                                          'FontRegular'),
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14.0,
                                      color: Theme.of(context).bottomAppBarColor,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 1.5,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).canvasColor,
                          ),

                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),

                  ],
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


  profileDetails() {
    apiUtils.getProfileDetils().then((GetProfileModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          name = loginData.result!.name.toString();
          email = loginData.result!.email.toString();
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
