import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../common/custom_widget.dart';
import '../../common/localization/localizations.dart';

class View_Rules extends StatefulWidget {
  const View_Rules({Key? key}) : super(key: key);

  @override
  State<View_Rules> createState() => _View_RulesState();
}

class _View_RulesState extends State<View_Rules> {
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
            AppLocalizations.instance.text("loc_commi"),
            style: CustomWidget(context: context).CustomSizedTextStyle(18.0,
                Theme.of(context).focusColor, FontWeight.w600, 'FontRegular'),
          ),
          centerTitle: true,

        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width *0.6,
                  padding: EdgeInsets.only(top: 25.0, bottom: 25.0, right: 15.0, left: 15.0),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Theme.of(context).disabledColor.withOpacity(0.4),
                          Theme.of(context).primaryColor,
                        ],
                        tileMode: TileMode.mirror,
                      ),
                      border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,),
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GradientText(
                            gradientDirection: GradientDirection.ttb,
                            "20",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                50.0,
                                Theme.of(context).cardColor,
                                FontWeight.w600,
                                'FontRegular'),
                            colors: [
                              Theme.of(context).indicatorColor,
                              Theme.of(context).indicatorColor.withOpacity(0.7),
                              Theme.of(context).disabledColor,
                              Theme.of(context).disabledColor,
                            ],
                            textAlign: TextAlign.center,
                          ),
                          GradientText(
                            gradientDirection: GradientDirection.ttb,
                            "%",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                20.0,
                                Theme.of(context).cardColor,
                                FontWeight.w600,
                                'FontRegular'),
                            colors: [
                              Theme.of(context).indicatorColor,
                              Theme.of(context).indicatorColor.withOpacity(0.7),
                              Theme.of(context).disabledColor,
                              Theme.of(context).disabledColor,
                            ],
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0,),
                      Padding(padding: EdgeInsets.only(left: 35.0, right: 35.0),child: Text(
                        "Invite 0 or more qualified referees",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            10.0,
                            Theme.of(context).focusColor,
                            FontWeight.w400,
                            'FontRegular'),
                        textAlign: TextAlign.center,
                      ),),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0,),
                Container(
                  width: MediaQuery.of(context).size.width *0.6,
                  padding: EdgeInsets.only(top: 25.0, bottom: 25.0, right: 15.0, left: 15.0),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Theme.of(context).disabledColor.withOpacity(0.4),
                          Theme.of(context).primaryColor,
                        ],
                        tileMode: TileMode.mirror,
                      ),
                      border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,),
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GradientText(
                            gradientDirection: GradientDirection.ttb,
                            "25",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                50.0,
                                Theme.of(context).cardColor,
                                FontWeight.w600,
                                'FontRegular'),
                            colors: [
                              Theme.of(context).indicatorColor,
                              Theme.of(context).indicatorColor.withOpacity(0.7),
                              Theme.of(context).disabledColor,
                              Theme.of(context).disabledColor,
                            ],
                            textAlign: TextAlign.center,
                          ),
                          GradientText(
                            gradientDirection: GradientDirection.ttb,
                            "%",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                20.0,
                                Theme.of(context).cardColor,
                                FontWeight.w600,
                                'FontRegular'),
                            colors: [
                              Theme.of(context).indicatorColor,
                              Theme.of(context).indicatorColor.withOpacity(0.7),
                              Theme.of(context).disabledColor,
                              Theme.of(context).disabledColor,
                            ],
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0,),
                      Padding(padding: EdgeInsets.only(left: 35.0, right: 35.0),child: Text(
                        "Invite 5 or more qualified referees",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            10.0,
                            Theme.of(context).focusColor,
                            FontWeight.w400,
                            'FontRegular'),
                        textAlign: TextAlign.center,
                      ),),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0,),
                Container(
                  width: MediaQuery.of(context).size.width *0.6,
                  padding: EdgeInsets.only(top: 25.0, bottom: 25.0, right: 15.0, left: 15.0),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Theme.of(context).disabledColor.withOpacity(0.4),
                          Theme.of(context).primaryColor,
                        ],
                        tileMode: TileMode.mirror,
                      ),
                      border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,),
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GradientText(
                            gradientDirection: GradientDirection.ttb,
                            "30",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                50.0,
                                Theme.of(context).cardColor,
                                FontWeight.w600,
                                'FontRegular'),
                            colors: [
                              Theme.of(context).indicatorColor,
                              Theme.of(context).indicatorColor.withOpacity(0.7),
                              Theme.of(context).disabledColor,
                              Theme.of(context).disabledColor,
                            ],
                            textAlign: TextAlign.center,
                          ),
                          GradientText(
                            gradientDirection: GradientDirection.ttb,
                            "%",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                20.0,
                                Theme.of(context).cardColor,
                                FontWeight.w600,
                                'FontRegular'),
                            colors: [
                              Theme.of(context).indicatorColor,
                              Theme.of(context).indicatorColor.withOpacity(0.7),
                              Theme.of(context).disabledColor,
                              Theme.of(context).disabledColor,
                            ],
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0,),
                      Padding(padding: EdgeInsets.only(left: 10.0, right: 10.0),child: Text(
                        "Invite 100 or more qualified referees, or achieve at least \$15 million in Derivatives trading volume through your referees in a quarter.",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            10.0,
                            Theme.of(context).focusColor,
                            FontWeight.w400,
                            'FontRegular'),
                        textAlign: TextAlign.center,
                      ),),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
