import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/custom_widget.dart';
import '../../common/localization/localizations.dart';
import '../../data/api_utils.dart';
import '../../data/crypt_model/notification.dart';

class Notification_Screen extends StatefulWidget {
  const Notification_Screen({Key? key}) : super(key: key);

  @override
  State<Notification_Screen> createState() => _Notification_ScreenState();
}

class _Notification_ScreenState extends State<Notification_Screen> {


  APIUtils apiUtils = APIUtils();
  bool loading = false;
  ScrollController controller = ScrollController();
  List<Notify> name= [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyDetails();
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
                size: 20.0,
                color: Theme.of(context).focusColor,
              ),
            ),
          ),

          title: Text(
            AppLocalizations.instance.text("loc_noti"),
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
            padding:
            EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                name.length>0 ?  ListView.builder(
                  itemCount:  name.length,
                  shrinkWrap: true,
                  controller: controller,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:  MediaQuery.of(context).size.width *0.25,
                                        child: Text(
                                          // "Congrast!",
                                          name[index].resultFor.toString(),
                                          style: CustomWidget(context: context).CustomSizedTextStyle(
                                              15.0,
                                              Theme.of(context).focusColor,
                                              FontWeight.w600,
                                              'FontRegular'),
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Container(
                                        width:  MediaQuery.of(context).size.width *0.5,
                                        child:  Text(
                                          // "Bitcoin (BTC) is earning +23.35 in the last 4 Hours",
                                          name[index].message.toString(),
                                          style: CustomWidget(context: context).CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context).focusColor.withOpacity(0.6),
                                              FontWeight.w400,
                                              'FontRegular'),
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )
                              ),flex: 4,),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Flexible(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "\$46.625,32",
                                    style: CustomWidget(context: context).CustomSizedTextStyle(
                                        16.0,
                                        Theme.of(context).focusColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                                    textAlign: TextAlign.start,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.arrow_drop_up,
                                        size: 14.0,
                                        color: Theme.of(context).secondaryHeaderColor,
                                      ),
                                      Text(
                                        "23.35",
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            12,
                                            Theme.of(context).secondaryHeaderColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                        textAlign: TextAlign.center,
                                      ),

                                    ],
                                  ),
                                ],
                              ), flex: 2,),
                            ],

                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                      ],
                    );
                  },
                )
                    :Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    ),
                  child: Center(
                    child: Text(
                      " No records Found..!",
                      style: TextStyle(
                        fontFamily: "FontRegular",
                        color: Theme.of(context).focusColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  notifyDetails() {
    apiUtils.getNotiDetils().then((GetNotificationModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          name = loginData.result!;
          // email = loginData.result!.email.toString();
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
