import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imperial/common/custom_widget.dart';
import 'package:imperial/common/theme/custom_theme.dart';
import 'package:imperial/screens/side_menu/chat_screen.dart';

class Support_Menu_Screen extends StatefulWidget {
  const Support_Menu_Screen({super.key});

  @override
  State<Support_Menu_Screen> createState() => _Support_Menu_ScreenState();
}

class _Support_Menu_ScreenState extends State<Support_Menu_Screen> {

  bool loading = false;


  @override
  Widget build(BuildContext context) {
    return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
      backgroundColor: CustomTheme.of(context).cardColor,
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
              Icons.arrow_back,
              size: 25.0,
              color:  CustomTheme.of(context).focusColor,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Support",
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
          color: CustomTheme.of(context).cardColor,
        ),
        child: Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          height: 35.0,
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 20.0,bottom: 20.0, right: 20.0, left: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerLeft,
                      colors: <Color>[
                        Color(0xFF1c7063),
                        Theme.of(context).disabledColor.withOpacity(0.3),
                      ],
                      tileMode: TileMode.mirror,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Email On",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            14.0,
                            Theme.of(context).focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      SvgPicture.asset("assets/sidemenu/mail.svg", height: 50.0, color: Theme.of(context).disabledColor,),
                      const SizedBox(
                        height: 10.0,
                      ),
                     Row(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text(
                           "support@imperialx.exchange",
                           style: CustomWidget(context: context).CustomSizedTextStyle(
                               14.0,
                               Theme.of(context).focusColor,
                               FontWeight.w500,
                               'FontRegular'),
                         ),
                         const SizedBox(
                           width: 10.0,
                         ),
                         Icon(
                           Icons.copy_outlined, size: 15.0,
                           color: Theme.of(context).focusColor,
                         )
                       ],
                     )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(ticket_id: "ticket_id"),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 20.0,bottom: 20.0, right: 20.0, left: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerLeft,
                      colors: <Color>[
                        Color(0xFF1c7063),
                        Theme.of(context).disabledColor.withOpacity(0.3),
                      ],
                      tileMode: TileMode.mirror,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Chat With Us",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            14.0,
                            Theme.of(context).focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      SvgPicture.asset("assets/sidemenu/support.svg", height: 50.0, color: Theme.of(context).disabledColor,),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Click here to chat with us",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            14.0,
                            Theme.of(context).focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 20.0,bottom: 20.0, right: 20.0, left: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerLeft,
                      colors: <Color>[
                        Color(0xFF1c7063),
                        Theme.of(context).disabledColor.withOpacity(0.3),
                      ],
                      tileMode: TileMode.mirror,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Call Us",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            14.0,
                            Theme.of(context).focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Icon(
                        Icons.wifi_calling_3_outlined,
                        size: 50.0,
                        color: Theme.of(context).disabledColor,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "+91 98765 90671",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            14.0,
                            Theme.of(context).focusColor,
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
      ),
    ));
  }

}
