import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

import '../../common/custom_widget.dart';
import 'notification.dart';

class Account_Screen extends StatefulWidget {
  const Account_Screen({Key? key}) : super(key: key);

  @override
  State<Account_Screen> createState() => _Account_ScreenState();
}

class _Account_ScreenState extends State<Account_Screen> {
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
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
          title:  Text(
            "Account",
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
          color: Theme.of(context).primaryColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Container(
                        //         child: Row(
                        //           children: [
                        //             InkWell(
                        //               onTap: () {
                        //                 // Navigator.of(context).push(MaterialPageRoute(
                        //                 //     builder: (context) => SideMenu()));
                        //               },
                        //               child: CircleAvatar(
                        //                 maxRadius: 25,
                        //                 minRadius: 25,
                        //                 backgroundImage: AssetImage(
                        //                   "assets/icons/logo.png",
                        //                 ),
                        //               ),
                        //             ),
                        //             const SizedBox(
                        //               width: 10.0,
                        //             ),
                        //             Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 Text(
                        //                   "Welcome Back,",
                        //                   style: CustomWidget(context: context)
                        //                       .CustomSizedTextStyle(
                        //                       12.0,
                        //                       Theme.of(context).disabledColor,
                        //                       FontWeight.w500,
                        //                       'FontRegular'),
                        //                   textAlign: TextAlign.start,
                        //                 ),
                        //                 // const SizedBox(
                        //                 //   height: 10.0,
                        //                 // ),
                        //                 Text(
                        //                   "Carla Pascle",
                        //                   style: CustomWidget(context: context)
                        //                       .CustomSizedTextStyle(
                        //                       18.0,
                        //                       Theme.of(context).focusColor,
                        //                       FontWeight.w500,
                        //                       'FontRegular'),
                        //                   textAlign: TextAlign.start,
                        //                 ),
                        //               ],
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //       Container(
                        //         child: Row(
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           children: [
                        //             InkWell(
                        //                 onTap: () {},
                        //                 child: SvgPicture.asset(
                        //                   "assets/images/search.svg",
                        //                   height: 26.0,
                        //                   fit: BoxFit.fill,
                        //                   color: Theme.of(context).focusColor,
                        //                 )),
                        //             const SizedBox(
                        //               width: 10.0,
                        //             ),
                        //             InkWell(
                        //                 onTap: () {
                        //                   Navigator.of(context).push(MaterialPageRoute(
                        //                       builder: (context) => Notification_Screen()));
                        //                 },
                        //                 child: SvgPicture.asset(
                        //                   "assets/images/bell.svg",
                        //                   height: 26.0,
                        //                   fit: BoxFit.fill,
                        //                   color: Theme.of(context).focusColor,
                        //                 )),
                        //           ],
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 10.0,
                        // ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).disabledColor.withOpacity(0.6),
                            image: DecorationImage(
                                image: AssetImage("assets/images/back.png"),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(1.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/icons/btc.svg",
                                        height: 40.0,
                                        // color: Theme.of(context).disabledColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Username",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              14.0,
                                              Theme.of(context)
                                                  .primaryColor,
                                              FontWeight.w600,
                                              'FontRegular'),
                                          textAlign: TextAlign.start,
                                        ),
                                        Text(
                                          "Ex***@gmail.com",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .primaryColor,
                                              FontWeight.w600,
                                              'FontRegular'),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "UID",
                                        style: CustomWidget(
                                            context: context)
                                            .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context)
                                                .primaryColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "66028542",
                                            style: CustomWidget(
                                                context: context)
                                                .CustomSizedTextStyle(
                                                16.0,
                                                Theme.of(context)
                                                    .primaryColor,
                                                FontWeight.w700,
                                                'FontRegular'),
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          InkWell(
                                            child: Icon(
                                              Icons.copy_outlined,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 18.0,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Security Level",
                                            style: CustomWidget(
                                                context: context)
                                                .CustomSizedTextStyle(
                                                14.0,
                                                Theme.of(context)
                                                    .primaryColor,
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
                                            color: Theme.of(context)
                                                .primaryColor,
                                          ),

                                        ],
                                      ),

                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            size: 20.0,
                                            color: Theme.of(context)
                                                .hoverColor,
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            "Low",
                                            style: CustomWidget(
                                                context: context)
                                                .CustomSizedTextStyle(
                                                16.0,
                                                Theme.of(context)
                                                    .hoverColor,
                                                FontWeight.w700,
                                                'FontRegular'),
                                            textAlign: TextAlign.start,
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Account Info",
                                        style: CustomWidget(
                                            context: context)
                                            .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context)
                                                .primaryColor,
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
                                        color: Theme.of(context)
                                            .primaryColor,
                                      ),

                                    ],
                                  ),

                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "User.Ex***@gmail.com",
                                    style: CustomWidget(
                                        context: context)
                                        .CustomSizedTextStyle(
                                        16.0,
                                        Theme.of(context)
                                            .primaryColor,
                                        FontWeight.w700,
                                        'FontRegular'),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Identity Verification",
                                        style: CustomWidget(
                                            context: context)
                                            .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context)
                                                .primaryColor,
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
                                        color: Theme.of(context)
                                            .primaryColor,
                                      ),

                                    ],
                                  ),

                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "Unverified",
                                    style: CustomWidget(
                                        context: context)
                                        .CustomSizedTextStyle(
                                        16.0,
                                        Theme.of(context)
                                            .primaryColor,
                                        FontWeight.w700,
                                        'FontRegular'),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "30,000 USDT Deposit Blast-Off Rewards",
                                  style: CustomWidget(
                                      context: context)
                                      .CustomSizedTextStyle(
                                      10.0,
                                      Theme.of(context)
                                          .focusColor,
                                      FontWeight.w600,
                                      'FontRegular'),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  width: 2.0,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 2.0, right: 2.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1.0),
                                    color:  Theme.of(context)
                                        .focusColor,
                                  ),
                                  child: Text(
                                    "13",
                                    style: CustomWidget(
                                        context: context)
                                        .CustomSizedTextStyle(
                                        10.0,
                                        Theme.of(context)
                                            .primaryColor,
                                        FontWeight.w600,
                                        'FontRegular'),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                const SizedBox(
                                  width: 2.0,
                                ),
                                Text(
                                  "D",
                                  style: CustomWidget(
                                      context: context)
                                      .CustomSizedTextStyle(
                                      10.0,
                                      Theme.of(context)
                                          .focusColor,
                                      FontWeight.w600,
                                      'FontRegular'),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  width: 2.0,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 2.0, right: 2.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1.0),
                                    color:  Theme.of(context)
                                        .focusColor,
                                  ),
                                  child: Text(
                                    "20",
                                    style: CustomWidget(
                                        context: context)
                                        .CustomSizedTextStyle(
                                        10.0,
                                        Theme.of(context)
                                            .primaryColor,
                                        FontWeight.w600,
                                        'FontRegular'),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                const SizedBox(
                                  width: 2.0,
                                ),
                                Text(
                                  "H",
                                  style: CustomWidget(
                                      context: context)
                                      .CustomSizedTextStyle(
                                      10.0,
                                      Theme.of(context)
                                          .focusColor,
                                      FontWeight.w600,
                                      'FontRegular'),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Rewards Hub",
                                  style: CustomWidget(
                                      context: context)
                                      .CustomSizedTextStyle(
                                      10.0,
                                      Theme.of(context)
                                          .disabledColor,
                                      FontWeight.w600,
                                      'FontRegular'),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  width: 6.0,
                                ),
                                RotationTransition(
                                    turns: AlwaysStoppedAnimation(
                                        -180 / 360),
                                    //it will rotate 20 degree, remove (-) to rotate -20 degree
                                    child: SvgPicture.asset(
                                      "assets/menu/back.svg",
                                      height: 8.0,
                                      color: Theme.of(context)
                                          .disabledColor,
                                    )),
                              ],
                            ),

                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Stack(alignment: Alignment.topRight,children: [
                        Container(width: size.width,decoration:BoxDecoration(borderRadius: BorderRadius.circular(8),border: Border.all(color: Theme.of(context).disabledColor,width: 1)),
                          child:Padding(padding: EdgeInsets.all(10),child:
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                          Image.asset("assets/images/div.png",fit: BoxFit.cover,height: size.height*0.08,width:size.height*0.08),
                          //Container(height: size.height*0.08,width:size.height*0.08 ,child: ,),
                          Container(child:Row(children: [
                            Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                            Container(child: RichText(text: TextSpan(children: [
                              TextSpan(text: "0",style:CustomWidget(
                                  context: context)
                                  .CustomSizedTextStyle(
                                  26.0,
                                  Theme.of(context)
                                      .focusColor,
                                  FontWeight.bold,
                                  'FontRegular'),
                                ),
                              TextSpan(text: "/30000 USDT",style:CustomWidget(
                                  context: context)
                                  .CustomSizedTextStyle(
                                  12.0,
                                  Theme.of(context)
                                      .focusColor,
                                  FontWeight.w600,
                                  'FontRegular'),
                              ),
                            ]),),),
                            Text("Rewards Unlocked",style:CustomWidget(
                                context: context)
                                .CustomSizedTextStyle(
                                12.0,
                                Theme.of(context)
                                    .dividerColor,
                                FontWeight.bold,
                                'FontRegular'),),
                            const SizedBox(height: 10.0,),

                            Row(children: [
                              Container(height: 15,width: 15,decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),color: Theme.of(context).disabledColor),),
                              Container(child: Stack(alignment: Alignment.centerRight,children: [

                                Container(width: size.width*0.60,child:LinearProgressBar(
                                maxSteps: 6,
                                progressType: LinearProgressBar.progressTypeLinear,
                                currentStep: 1,
                                progressColor: Theme.of(context).disabledColor,
                                backgroundColor: Theme.of(context).focusColor,
                                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).disabledColor),
                                semanticsLabel: "Label",
                                semanticsValue: "Value",
                                minHeight: 4,
                                borderRadius: BorderRadius.circular(10), //  NEW
                              ),),
                                Container(width: size.width*0.50,child:
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                                  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Theme.of(context).focusColor,border: Border.all(color: Theme.of(context).disabledColor)),
                                    child:Padding(padding: EdgeInsets.all(4),child:Text("10 USDT",style:CustomWidget(
                                        context: context)
                                        .CustomSizedTextStyle(
                                        8.0,
                                        Theme.of(context)
                                            .disabledColor,
                                        FontWeight.bold,
                                        'FontRegular'),textAlign: TextAlign.center,),),),
                                  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Theme.of(context).focusColor,border: Border.all(color: Theme.of(context).primaryColor)),
                                    child: Padding(padding: EdgeInsets.all(4),child:Text("20 USDT",style:CustomWidget(
                                        context: context)
                                        .CustomSizedTextStyle(
                                        8.0,
                                        Theme.of(context)
                                            .disabledColor,
                                        FontWeight.bold,
                                        'FontRegular'),textAlign: TextAlign.center,),))
                                  ,Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Theme.of(context).focusColor,border: Border.all(color: Theme.of(context).primaryColor)),
                                    child:Padding(padding: EdgeInsets.all(4),child: Text("30 USDT",style:CustomWidget(
                                        context: context)
                                        .CustomSizedTextStyle(
                                        8.0,
                                        Theme.of(context)
                                            .disabledColor,
                                        FontWeight.bold,
                                        'FontRegular'),textAlign: TextAlign.center,),))
                                ],),),

                                ],),
                              ),



                            ],),
                            

                          ],),),
                          ],),),

                        ],),),),
                          Positioned(top: 10,right: 10,child:RotationTransition(
                              turns: AlwaysStoppedAnimation(
                                  -180 / 360),
                              //it will rotate 20 degree, remove (-) to rotate -20 degree
                              child: SvgPicture.asset(
                                "assets/menu/back.svg",
                                height: 15.0,
                                color: Theme.of(context)
                                    .disabledColor,
                              )),
                          ),
                        ],),
                        const SizedBox(
                          height: 20.0,
                        ),

                        Text(
                          "Recommended",
                          style: CustomWidget(
                              context: context)
                              .CustomSizedTextStyle(
                              18.0,
                              Theme.of(context)
                                  .focusColor,
                              FontWeight.w600,
                              'FontRegular'),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(width: 1.0, color: Theme.of(context)
                                .focusColor,),

                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0)
                                    ),
                                    color: Theme.of(context)
                                        .disabledColor,
                                  ),
                                  child: Text(
                                    "Limited",
                                    style: CustomWidget(
                                        context: context)
                                        .CustomSizedTextStyle(
                                        12.0,
                                        Theme.of(context)
                                            .focusColor,
                                        FontWeight.w600,
                                        'FontRegular'),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/images/mining.png",height: 32.0,),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          "SUI Liquidity Mining",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              18.0,
                                              Theme.of(context)
                                                  .focusColor,
                                              FontWeight.w600,
                                              'FontRegular'),
                                          textAlign: TextAlign.start,
                                        ),

                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "24h APR: 159.5 % - 478.5 %",
                                      style: CustomWidget(
                                          context: context)
                                          .CustomSizedTextStyle(
                                          12.0,
                                          Theme.of(context)
                                              .focusColor.withOpacity(0.6),
                                          FontWeight.w400,
                                          'FontRegular'),
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(width: 1.0, color: Theme.of(context)
                                .focusColor,),

                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0)
                                    ),
                                    color: Theme.of(context)
                                        .disabledColor,
                                  ),
                                  child: Text(
                                    "New",
                                    style: CustomWidget(
                                        context: context)
                                        .CustomSizedTextStyle(
                                        12.0,
                                        Theme.of(context)
                                            .focusColor,
                                        FontWeight.w600,
                                        'FontRegular'),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/images/discovery.png",height: 32.0,),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          "Tools Discovery",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              18.0,
                                              Theme.of(context)
                                                  .focusColor,
                                              FontWeight.w600,
                                              'FontRegular'),
                                          textAlign: TextAlign.start,
                                        ),

                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "Discover Tools Tailored to Your Trading Style",
                                      style: CustomWidget(
                                          context: context)
                                          .CustomSizedTextStyle(
                                          12.0,
                                          Theme.of(context)
                                              .focusColor.withOpacity(0.6),
                                          FontWeight.w400,
                                          'FontRegular'),
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.center,
                                end: Alignment.centerRight,
                                colors: <Color>[
                                  Theme.of(context).disabledColor.withOpacity(0.3),
                                  Theme.of(context).primaryColor,
                                ],
                                tileMode: TileMode.mirror,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(width: 1.0, color: Theme.of(context)
                                  .disabledColor,),
                            ),
                            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Invite friends and Earn 25 USDT Cashback and 10,000 USDT Lucky Draw",
                                  style: CustomWidget(
                                      context: context)
                                      .CustomSizedTextStyle(
                                      9.0,
                                      Theme.of(context)
                                          .focusColor,
                                      FontWeight.w600,
                                      'FontRegular'),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    Text(
                                      "Invite now",
                                      style: CustomWidget(
                                          context: context)
                                          .CustomSizedTextStyle(
                                          8.0,
                                          Theme.of(context)
                                              .disabledColor,
                                          FontWeight.w600,
                                          'FontRegular'),
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(
                                      width: 3.0,
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Theme.of(context)
                                          .disabledColor,
                                      size: 10.0,
                                    ),

                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 15.0, left: 15.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .canvasColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Complete the following tasks to grab more rewards.",
                                style: CustomWidget(
                                    context: context)
                                    .CustomSizedTextStyle(
                                    10.0,
                                    Theme.of(context)
                                        .focusColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.center,
                                    end: Alignment.centerRight,
                                    colors: <Color>[
                                      Theme.of(context).disabledColor.withOpacity(0.3),
                                      Theme.of(context).primaryColor,
                                    ],
                                    tileMode: TileMode.mirror,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(width: 1.0, color: Theme.of(context)
                                      .disabledColor,),
                                ),
                                padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Deposit ≥ \$100",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              10.0,
                                              Theme.of(context)
                                                  .focusColor,
                                              FontWeight.w600,
                                              'FontRegular'),
                                          textAlign: TextAlign.start,
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 50.0,
                                              height: 5.0,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0),
                                                color: Theme.of(context)
                                                    .focusColor.withOpacity(0.3),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              "0/100 USDT",
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  8.0,
                                                  Theme.of(context)
                                                      .focusColor. withOpacity(0.6),
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                              textAlign: TextAlign.start,
                                            )
                                          ],
                                        ),
                                      ],
                                    ), flex: 4,),
                                    Flexible(child: InkWell(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.0),
                                          color: Theme.of(context)
                                              .disabledColor,
                                        ),
                                        child: Text(
                                          "Deposit Now",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              10.0,
                                              Theme.of(context)
                                                  .focusColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ), flex: 2,),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .disabledColor,
                                      shape: BoxShape.circle
                                  ),
                                  child: Text(
                                    "And",
                                    style: CustomWidget(
                                        context: context)
                                        .CustomSizedTextStyle(
                                        8.0,
                                        Theme.of(context)
                                            .primaryColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.center,
                                    end: Alignment.centerRight,
                                    colors: <Color>[
                                      Theme.of(context).disabledColor.withOpacity(0.3),
                                      Theme.of(context).primaryColor,
                                    ],
                                    tileMode: TileMode.mirror,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(width: 1.0, color: Theme.of(context)
                                      .disabledColor,),
                                ),
                                padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Deposit ≥ \$500",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              10.0,
                                              Theme.of(context)
                                                  .focusColor,
                                              FontWeight.w600,
                                              'FontRegular'),
                                          textAlign: TextAlign.start,
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 50.0,
                                              height: 5.0,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0),
                                                color: Theme.of(context)
                                                    .focusColor.withOpacity(0.3),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              "0/500 USDT",
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  8.0,
                                                  Theme.of(context)
                                                      .focusColor. withOpacity(0.6),
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                              textAlign: TextAlign.start,
                                            )
                                          ],
                                        ),
                                      ],
                                    ), flex: 4,),
                                    Flexible(child: InkWell(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.0),
                                          color: Theme.of(context)
                                              .disabledColor,
                                        ),
                                        child: Text(
                                          "Trade Now",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              10.0,
                                              Theme.of(context)
                                                  .focusColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ), flex: 2,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "My Assets",
                          style: CustomWidget(
                              context: context)
                              .CustomSizedTextStyle(
                              18.0,
                              Theme.of(context)
                                  .focusColor,
                              FontWeight.w600,
                              'FontRegular'),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 25.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).disabledColor.withOpacity(0.6),
                            // gradient: LinearGradient(
                            //   begin: Alignment.center,
                            //   end: Alignment.bottomRight,
                            //   colors: <Color>[
                            //     Theme.of(context).disabledColor.withOpacity(0.8),
                            //     Theme.of(context).primaryColor,
                            //
                            //   ],
                            //   tileMode: TileMode.mirror,
                            // ),
                            image: DecorationImage(
                                image: AssetImage("assets/images/back.png"),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total Assets ",
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        14.0,
                                        Theme.of(context).primaryColor,
                                        FontWeight.w400,
                                        'FontRegular'),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "18,3 USD",
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        32.0,
                                        Theme.of(context).focusColor,
                                        FontWeight.w600,
                                        'FontRegular'),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "≈ 0.00000000 BTC",
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        14.0,
                                        Theme.of(context).primaryColor,
                                        FontWeight.w400,
                                        'FontRegular'),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ), flex: 4,),

                              Flexible(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: Theme.of(context)
                                            .disabledColor,
                                      ),
                                      child: Text(
                                        "Deposit",
                                        style: CustomWidget(
                                            context: context)
                                            .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context)
                                                .focusColor,
                                            FontWeight.w600,
                                            'FontRegular'),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  InkWell(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        border: Border.all(width: 1.0, color: Theme.of(context)
                                            .focusColor,)
                                      ),
                                      child: Text(
                                        "Buy Crypto",
                                        style: CustomWidget(
                                            context: context)
                                            .CustomSizedTextStyle(
                                            11.0,
                                            Theme.of(context)
                                                .focusColor,
                                            FontWeight.w600,
                                            'FontRegular'),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                ],
                              ),flex: 2,)
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 25.0,
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
