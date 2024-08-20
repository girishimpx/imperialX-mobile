import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:imperial/screens/basic/signup.dart';
import 'package:imperial/screens/basic/welcome.dart';

import '../../common/custom_widget.dart';
import '../../common/localization/localizations.dart';
import '../../common/theme/custom_theme.dart';
import 'login.dart';

class WelcomeInfo extends StatefulWidget {
  const WelcomeInfo({super.key});

  @override
  State<WelcomeInfo> createState() => _WelcomeInfoState();
}

class _WelcomeInfoState extends State<WelcomeInfo> {
  CarouselController controller=CarouselController();
  int currentimdex=0;
  List<Map<String,dynamic>> info_list=[
    {
    "image":"assets/images/wel1.png",
    "title":"Welcome to\nImperial",
    "endtext":"X"
  },
    {
      "image":"assets/images/wel2.png",
      "title":"Transaction\nSecurity ",
      "endtext":""
    },
    {
      "image":"assets/images/wel3.png",
      "title":"Fast and reliable\nMarket updated",
      "endtext":""
    },
  ];
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(backgroundColor: CustomTheme.of(context).primaryColor,body: SafeArea(child:Padding(padding: EdgeInsets.all(10),child:
    // OnBoardingSlider(
    //
    //   indicatorPosition: 25.0,
    //
    //   onFinish: () {
    //     Navigator.pushReplacement(
    //       context,
    //       CupertinoPageRoute(
    //         builder: (context) => Welcome_Screen(),
    //       ),
    //     );
    //   },
    //   // finishButtonText: "Go",
    //   // finishButtonStyle: FinishButtonStyle(
    //   //   shape: OutlineInputBorder(borderRadius: BorderRadius.circular(60)),
    //   //   backgroundColor: Theme.of(context).disabledColor,
    //   // ),
    //
    //   finishButtonText: '',
    //   finishButtonStyle:FinishButtonStyle(backgroundColor: Colors.transparent,shape: OutlineInputBorder(borderRadius: BorderRadius.circular(60))),
    //
    //   skipTextButton: InkWell(
    //     onTap: (){
    //
    //       Navigator.pushReplacement(
    //         context,
    //         CupertinoPageRoute(
    //           builder: (context) => Welcome_Screen(),
    //         ),
    //       );
    //
    //     },
    //     child: Container(
    //       // padding: EdgeInsets.only(left: 20.0, right: 20.0),
    //       // decoration: BoxDecoration(
    //       //   borderRadius: BorderRadius.circular(25.0),
    //       //   color: Theme.of(context).primaryColorLight,
    //       // ),
    //       child: Text(
    //        "skip",
    //         style: TextStyle(
    //           fontSize: 16,
    //           color: Theme.of(context).disabledColor,
    //           fontWeight: FontWeight.w600,
    //         ),
    //       ),
    //     ),
    //   ),
    //
    //
    //   controllerColor: Theme.of(context).disabledColor,
    //   indicatorAbove: true,
    //
    //   totalPage: 4,
    //   headerBackgroundColor: Theme.of(context).primaryColor,
    //   pageBackgroundColor: Theme.of(context).primaryColor,
    //   background: [
    //     Container(
    //       margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.15),
    //       width: MediaQuery.of(context).size.width,
    //       child:  Padding(padding: EdgeInsets.only(left: 15.0, right: 15.0),
    //         child: Image.asset(
    //           'assets/images/wel1.png',
    //           height: size.height*0.40,
    //           width: size.height*0.40,
    //           fit: BoxFit.contain,
    //         ),),
    //     ),
    //     Container(
    //       margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.15),
    //       width: MediaQuery.of(context).size.width,
    //       child:  Padding(padding: EdgeInsets.only(left: 15.0, right: 15.0),
    //         child: Image.asset(
    //           'assets/images/wel2.png',
    //           height: size.height*0.40,
    //           width: size.height*0.40,
    //           fit: BoxFit.contain,
    //         ),),
    //     ),
    //     Container(
    //       margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.15),
    //       width: MediaQuery.of(context).size.width,
    //       child:  Padding(padding: EdgeInsets.only(left: 15.0, right: 15.0),
    //         child: Image.asset(
    //           'assets/images/wel3.png',
    //           height: size.height*0.40,
    //           width: size.height*0.40,
    //           fit: BoxFit.contain,
    //         ),),
    //     ),
    //     Container(
    //       margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.15),
    //       width: MediaQuery.of(context).size.width,
    //       child:  Padding(padding: EdgeInsets.only(left: 15.0, right: 15.0),
    //         child: Image.asset(
    //           'assets/images/welcome.png',
    //           height: size.height*0.40,
    //           width: size.height*0.40,
    //           fit: BoxFit.contain,
    //         ),),
    //     ),
    //
    //   ],
    //   speed: 1.8,
    //   pageBodies: [
    //     Container(
    //       alignment: Alignment.bottomLeft,
    //       margin: EdgeInsets.only(bottom: size.height*0.10),
    //       width: MediaQuery.of(context).size.width*0.60,
    //       padding: const EdgeInsets.symmetric(horizontal: 20),
    //       child: Text("Welcome to imperialX",
    //         style: CustomWidget(context: context)
    //             .CustomSizedTextStyle(
    //             32.0,
    //             Theme.of(context).focusColor,
    //             FontWeight.w600,
    //             'FontRegular'),
    //         textAlign: TextAlign.start,),
    //
    //     ),
    //     Container(
    //       alignment: Alignment.bottomLeft,
    //       margin: EdgeInsets.only(bottom: size.height*0.15),
    //       width: MediaQuery.of(context).size.width*0.60,
    //       padding: const EdgeInsets.symmetric(horizontal: 20),
    //       child: Text("Transaction Security ",
    //           style: CustomWidget(context: context)
    //               .CustomSizedTextStyle(
    //               32.0,
    //               Theme.of(context).focusColor,
    //               FontWeight.w600,
    //               'FontRegular'),
    //           textAlign: TextAlign.start,),
    //
    //     ),
    //     Container(
    //       alignment: Alignment.bottomLeft,
    //       margin: EdgeInsets.only(bottom: size.height*0.15),
    //       width: MediaQuery.of(context).size.width*0.60,
    //       padding: const EdgeInsets.symmetric(horizontal: 20),
    //       child: Text("Fast and reliable Market updated",
    //         style: CustomWidget(context: context)
    //             .CustomSizedTextStyle(
    //             32.0,
    //             Theme.of(context).focusColor,
    //             FontWeight.w600,
    //             'FontRegular'),
    //         textAlign: TextAlign.start,),
    //
    //     ),
    //     Container(
    //       alignment: Alignment.bottomLeft,
    //       margin: EdgeInsets.only(bottom: size.height*0.10),
    //       width: MediaQuery.of(context).size.width*0.60,
    //       padding: const EdgeInsets.symmetric(horizontal: 20),
    //       child:Column(mainAxisAlignment: MainAxisAlignment.end,children: [
    //         Text("Fast and Flexible Trading",
    //         style: CustomWidget(context: context)
    //             .CustomSizedTextStyle(
    //             32.0,
    //             Theme.of(context).focusColor,
    //             FontWeight.w600,
    //             'FontRegular'),
    //         textAlign: TextAlign.start,),
    //         SizedBox(height: 30,),
    //         Container(
    //           child: Row(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Flexible(child: InkWell(
    //                 onTap: (){
    //                   Navigator.of(context).push(
    //                       MaterialPageRoute(builder: (context) => Signup_Screen()));
    //                 },
    //                 child: Container(
    //                   alignment: Alignment.center,
    //                   width: MediaQuery.of(context).size.width,
    //                   padding: EdgeInsets.only(top: 8.0, bottom: 10.0),
    //                   decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(10.0),
    //                       color: Theme.of(context).primaryColor,
    //                       border: Border.all(width: 2.0, color: Theme.of(context).disabledColor,)
    //                   ),
    //                   child: Text(
    //                     AppLocalizations.instance.text("loc_sign_up"),
    //                     style: CustomWidget(context: context)
    //                         .CustomSizedTextStyle(
    //                         16.0,
    //                         Theme.of(context).disabledColor,
    //                         FontWeight.w500,
    //                         'FontRegular'),
    //                     textAlign: TextAlign.start,
    //                   ),
    //                 ),
    //               ), flex: 2,),
    //               const SizedBox(width: 20.0,),
    //               Flexible(child: InkWell(
    //                 onTap: (){
    //                   Navigator.of(context).push(
    //                       MaterialPageRoute(builder: (context) => Login_Screen()));
    //                 },
    //                 child: Container(
    //                   alignment: Alignment.center,
    //                   width: MediaQuery.of(context).size.width,
    //                   padding: EdgeInsets.only( top: 10.0, bottom: 12.0),
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(10.0),
    //                     color: Theme.of(context).disabledColor,
    //                   ),
    //                   child: Text(
    //                     AppLocalizations.instance.text("loc_login"),
    //                     style: CustomWidget(context: context)
    //                         .CustomSizedTextStyle(
    //                         16.0,
    //                         Theme.of(context).primaryColorLight,
    //                         FontWeight.w500,
    //                         'FontRegular'),
    //                     textAlign: TextAlign.start,
    //                   ),
    //                 ),
    //               ), flex: 2,)
    //             ],
    //           ),
    //         ),
    //       ]),
    //
    //     ),
    //
    //
    //   ],
    // ),
      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment:CrossAxisAlignment.start,children: [
        SizedBox(height: size.height*0.01,),
        GestureDetector(onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Welcome_Screen(),));
        },child:Align(alignment: Alignment.centerRight,child:Container(width: size.width*0.10,child:Text("Skip",style: TextStyle(fontSize: 14,color: Theme.of(context).disabledColor,fontWeight: FontWeight.bold),textAlign: TextAlign.end,),),),),
        SizedBox(height: size.height*0.02,),

        Container(width: size.width,height:size.height*0.40,child:CarouselSlider.builder(carouselController:controller,itemCount: info_list.length,
    options: CarouselOptions(scrollDirection: Axis.horizontal,autoPlay: false,viewportFraction: 1,
    aspectRatio: 1/20,
    enlargeCenterPage: true,
    onPageChanged: (index, reason) {
      setState(() {
        currentimdex = index;
      });
    }
    ),
            itemBuilder: (context, index, realIndex) {
          return Container(child: Image.asset("${info_list[index]["image"]}",fit: BoxFit.cover,),);

      })),
        SizedBox(height: size.height*0.10,),

          Container(width: size.width*0.70,child:
          RichText(text: TextSpan(children: [
            TextSpan(text:"${info_list[currentimdex]["title"]}",style: TextStyle(fontSize: 30,color: Theme.of(context).focusColor,fontWeight: FontWeight.bold,),),
            TextSpan(text:"${info_list[currentimdex]["endtext"]}",style: TextStyle(fontSize: 30,color: Theme.of(context).disabledColor,fontWeight: FontWeight.bold),),
          ]),),),


        SizedBox(height: size.height*0.02,),
        Flexible(child:
        Container(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
        Container(height:26,width: size.width*0.40,child: ListView.builder(scrollDirection: Axis.horizontal,itemCount: info_list.length,physics: NeverScrollableScrollPhysics(),itemBuilder: (context, index) {
          return Padding(padding: EdgeInsets.only(right: 8),child:
          Container(
            width: currentimdex == index?24.0:8.0,
            height: 10.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: currentimdex == index?Theme.of(context).disabledColor:Theme.of(context).dividerColor,
            ),
          ));
        },),),
          GestureDetector(onTap: () {
            print(currentimdex);
            if(currentimdex==2){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Welcome_Screen(),));
            }
            if(currentimdex<2) {
              setState(() {
                currentimdex++;
                controller.animateToPage(currentimdex);
              });
            }

          },child:
          Container(child:Padding(padding: EdgeInsets.all(10),child: Icon(Icons.arrow_forward_ios_rounded,size: 20,color: Theme.of(context).primaryColor,),),
            decoration:BoxDecoration(borderRadius: BorderRadius.circular(100),color: Theme.of(context).disabledColor) ,),),
        ],),),fit: FlexFit.loose,),
        SizedBox(height: size.height*0.01,),
    ],)
    ),));
  }
}
