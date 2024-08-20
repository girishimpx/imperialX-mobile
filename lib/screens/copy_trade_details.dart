import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../common/custom_widget.dart';

class Trade_Details extends StatefulWidget {
  final name;
  final rating;
  const Trade_Details({Key? key, this.name, this.rating}) : super(key: key);

  @override
  State<Trade_Details> createState() => _Trade_DetailsState();
}

class _Trade_DetailsState extends State<Trade_Details> {

  bool history= false;
  bool perform= false;
  bool ongo= false;

  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    perform = true;
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
            // "Govahi",
            widget.name.toString().toUpperCase(),
            style: CustomWidget(context: context).CustomSizedTextStyle(18.0,
                Theme.of(context).focusColor, FontWeight.w600, 'FontRegular'),
          ),
          centerTitle: true,
          actions: [
            Container(
              padding: EdgeInsets.only(right: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    child: Icon(
                      Icons.star_border_outlined,
                      size: 20.0,
                      color: Theme.of(context).focusColor,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  InkWell(
                    child: Icon(
                      Icons.info_outline,
                      size: 20.0,
                      color: Theme.of(context).focusColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).primaryColor,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Theme.of(context).canvasColor,
                        ),
                        padding: EdgeInsets.only(bottom: 10.0, right: 10.0, left: 10.0, top: 10.0),
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    // SvgPicture.network(image, height: 35.0,),
                                    Container(
                                      padding: EdgeInsets.all(1.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                        "assets/images/prof.png",
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
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width *0.15,
                                              child: Text(
                                                widget.name.toString(),
                                                // "Govahi",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    14.0,
                                                    Theme.of(context)
                                                        .focusColor,
                                                    FontWeight.w600,
                                                    'FontRegular'),
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 6.0,
                                            ),
                                            Text(
                                              "Joined 22d ago",
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .focusColor.withOpacity(0.6),
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                              textAlign: TextAlign.start,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4.0,
                                        ),
                                        Container(

                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context).size.width *0.15,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      widget.rating.toString() +"/",
                                                      style: CustomWidget(
                                                          context: context)
                                                          .CustomSizedTextStyle(
                                                          14.0,
                                                          Theme.of(context)
                                                              .focusColor,
                                                          FontWeight.w600,
                                                          'FontRegular'),
                                                      textAlign: TextAlign.start,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      "5.0",
                                                      style: CustomWidget(
                                                          context: context)
                                                          .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .focusColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                      textAlign: TextAlign.start,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 6.0,
                                              ),
                                              Text(
                                                "Followers : 2k",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    10.0,
                                                    Theme.of(context)
                                                        .focusColor.withOpacity(0.6),
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                                textAlign: TextAlign.start,
                                              )

                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              flex: 4,
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // decoration: BoxDecoration(
                                    //   image: DecorationImage(
                                    //     image: AssetImage("assets/menu/graph.png",),fit:BoxFit.cover,
                                    //   ),
                                    // ),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.arrow_drop_up,
                                          size: 14.0,
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                        ),
                                        Text(
                                          "+1.31%",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12,
                                              Theme.of(context)
                                                  .secondaryHeaderColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                          textAlign: TextAlign.center,
                                        ),

                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4.0,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 3.0, bottom: 3.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Theme.of(context)
                                          .disabledColor.withOpacity(0.5),
                                    ),
                                    child: Text(
                                      "Follow",
                                      style:
                                      CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          8.0,
                                          Theme.of(context)
                                              .disabledColor,
                                          FontWeight.w400,
                                          'FontRegular'),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                              flex: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                perform = true;
                                ongo = false;
                                history = false;
                              });
                            },
                            child:  Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 8.0),
                              decoration: perform ? BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                color: Theme.of(context).canvasColor,
                              ) : BoxDecoration(),
                              child:  Text(
                                "Performance",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    14.0,
                                    perform ? Theme.of(context).disabledColor: Theme.of(context).dividerColor,
                                    perform ? FontWeight.w600 : FontWeight.w400,
                                    'FontRegular'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15.0,),
                          InkWell(
                            onTap: (){
                              setState(() {
                                perform = false;
                                ongo = true;
                                history = false;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 8.0),
                              decoration: ongo?  BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                color: Theme.of(context).canvasColor,
                              ): BoxDecoration(),
                              child:  Text(
                                "Ongoing",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    14.0,
                                    ongo? Theme.of(context).disabledColor : Theme.of(context).dividerColor,
                                    ongo?  FontWeight.w600 : FontWeight.w400,
                                    'FontRegular'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15.0,),
                          InkWell(
                            onTap: (){
                              setState(() {
                                perform = false;
                                ongo = false;
                                history = true;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 8.0),
                              decoration: history?  BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                color: Theme.of(context).canvasColor,
                              ): BoxDecoration(),
                              child:  Text(
                                "History",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    14.0,
                                    history? Theme.of(context).disabledColor : Theme.of(context).dividerColor,
                                    history?  FontWeight.w600 : FontWeight.w400,
                                    'FontRegular'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0,),
                      perform ? Container(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           Container(
                             height: 320.0,
                             width: MediaQuery.of(context).size.width,
                             child: Image.asset("assets/menu/chart.png",fit: BoxFit.fill,),
                           ),
                           const SizedBox(height: 20.0,),
                           Container(
                             child: Row(
                               children: [
                                 Flexible(child: Container(
                                   width: MediaQuery.of(context).size.width,
                                   height: MediaQuery.of(context).size.height *0.18,
                                   padding: EdgeInsets.only(top: 20.0, bottom: 20.0, right: 10.0, left: 10.0),
                                   alignment: Alignment.center,
                                   decoration: BoxDecoration(
                                       gradient: LinearGradient(
                                         begin: Alignment.centerLeft,
                                         end: Alignment.centerRight,
                                         colors: <Color>[
                                           Theme.of(context).primaryColor,
                                           Theme.of(context).disabledColor.withOpacity(0.2),
                                           // Theme.of(context).primaryColor,
                                         ],
                                         tileMode: TileMode.mirror,
                                       ),
                                       border: Border.all(width: 1.0, color: Theme.of(context)
                                           .disabledColor,),
                                       borderRadius: BorderRadius.circular(12.0)
                                   ),
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                       Row(
                                         crossAxisAlignment:
                                         CrossAxisAlignment.center,
                                         mainAxisAlignment:
                                         MainAxisAlignment.center,
                                         children: [
                                           Text(
                                             "Rating",
                                             style: CustomWidget(
                                                 context: context)
                                                 .CustomSizedTextStyle(
                                                 9,
                                                 Theme.of(context)
                                                     .focusColor,
                                                 FontWeight.w700,
                                                 'FontRegular'),
                                             textAlign: TextAlign.center,
                                           ),
                                           const SizedBox(width: 2.0,),
                                           Container(
                                             padding: EdgeInsets.all(1.0),
                                             decoration: BoxDecoration(
                                                 shape: BoxShape.circle,
                                                 border: Border.all(width: 1.0, color: Theme.of(context)
                                                     .disabledColor,)
                                             ),
                                             child:  Icon(
                                               Icons.question_mark_outlined,
                                               size: 4.0,
                                               color: Theme.of(context)
                                                   .disabledColor,
                                             ),
                                           ),


                                         ],
                                       ),
                                       const SizedBox(height: 10.0,),
                                       Stack(
                                         children: [
                                           Align(
                                             alignment: Alignment.center,
                                             child: Icon(Icons.star_border, color: Theme.of(context)
                                                 .disabledColor,size: 80.0,),
                                           ),
                                           Align(
                                             alignment: Alignment.center,
                                             child:  Container(
                                               margin: EdgeInsets.only(top: MediaQuery.of(context).size.height *0.045),
                                               alignment: Alignment.center,
                                               child: Text(
                                                 "6.4",
                                                 style: CustomWidget(
                                                     context: context)
                                                     .CustomSizedTextStyle(
                                                     9,
                                                     Theme.of(context)
                                                         .focusColor,
                                                     FontWeight.w700,
                                                     'FontRegular'),
                                                 textAlign: TextAlign.center,
                                               ),
                                             ),
                                           )
                                         ],
                                       )
                                     ],
                                   ),
                                 ), flex: 1,),
                                 const SizedBox(
                                   width: 10.0,
                                 ),
                                 Flexible(child: Container(
                                   width: MediaQuery.of(context).size.width,
                                   height: MediaQuery.of(context).size.height *0.18,
                                   padding: EdgeInsets.only(top: 20.0, bottom: 20.0, right: 10.0, left: 10.0),
                                   alignment: Alignment.center,
                                   decoration: BoxDecoration(
                                       gradient: LinearGradient(
                                         begin: Alignment.centerLeft,
                                         end: Alignment.centerRight,
                                         colors: <Color>[
                                           Theme.of(context).primaryColor,
                                           Theme.of(context).disabledColor.withOpacity(0.2),
                                           // Theme.of(context).primaryColor,
                                         ],
                                         tileMode: TileMode.mirror,
                                       ),
                                       border: Border.all(width: 1.0, color: Theme.of(context)
                                           .disabledColor,),
                                       borderRadius: BorderRadius.circular(12.0)
                                   ),
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                       Row(
                                         crossAxisAlignment:
                                         CrossAxisAlignment.center,
                                         mainAxisAlignment:
                                         MainAxisAlignment.center,
                                         children: [
                                           Text(
                                             "Profit",
                                             style: CustomWidget(
                                                 context: context)
                                                 .CustomSizedTextStyle(
                                                 9,
                                                 Theme.of(context)
                                                     .focusColor,
                                                 FontWeight.w700,
                                                 'FontRegular'),
                                             textAlign: TextAlign.center,
                                           ),
                                           const SizedBox(width: 2.0,),
                                           Container(
                                             padding: EdgeInsets.all(1.0),
                                             decoration: BoxDecoration(
                                                 shape: BoxShape.circle,
                                                 border: Border.all(width: 1.0, color: Theme.of(context)
                                                     .disabledColor,)
                                             ),
                                             child:  Icon(
                                               Icons.question_mark_outlined,
                                               size: 4.0,
                                               color: Theme.of(context)
                                                   .disabledColor,
                                             ),
                                           ),


                                         ],
                                       ),
                                       const SizedBox(height: 15.0,),
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.center,
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           SvgPicture.asset("assets/icons/line.svg", height: 50.0, fit: BoxFit.cover,),
                                           Text(
                                             "+60.96%",
                                             style: CustomWidget(
                                                 context: context)
                                                 .CustomSizedTextStyle(
                                                 9,
                                                 Theme.of(context)
                                                     .focusColor,
                                                 FontWeight.w700,
                                                 'FontRegular'),
                                             textAlign: TextAlign.center,
                                           ),
                                         ],
                                       ),
                                     ],
                                   ),
                                 ), flex: 1,),
                                 const SizedBox(
                                   width: 10.0,
                                 ),
                                 Flexible(child: Container(
                                   width: MediaQuery.of(context).size.width,
                                   height: MediaQuery.of(context).size.height *0.18,
                                   padding: EdgeInsets.only(top: 20.0, bottom: 20.0, right: 10.0, left: 10.0),
                                   alignment: Alignment.center,
                                   decoration: BoxDecoration(
                                       gradient: LinearGradient(
                                         begin: Alignment.centerLeft,
                                         end: Alignment.centerRight,
                                         colors: <Color>[
                                           Theme.of(context).primaryColor,
                                           Theme.of(context).disabledColor.withOpacity(0.2),
                                           // Theme.of(context).primaryColor,
                                         ],
                                         tileMode: TileMode.mirror,
                                       ),
                                       border: Border.all(width: 1.0, color: Theme.of(context)
                                           .disabledColor,),
                                       borderRadius: BorderRadius.circular(12.0)
                                   ),
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       Row(
                                         crossAxisAlignment:
                                         CrossAxisAlignment.center,
                                         mainAxisAlignment:
                                         MainAxisAlignment.center,
                                         children: [
                                           Text(
                                             "Risk",
                                             style: CustomWidget(
                                                 context: context)
                                                 .CustomSizedTextStyle(
                                                 9,
                                                 Theme.of(context)
                                                     .focusColor,
                                                 FontWeight.w700,
                                                 'FontRegular'),
                                             textAlign: TextAlign.center,
                                           ),
                                           const SizedBox(width: 2.0,),
                                           Container(
                                             padding: EdgeInsets.all(1.0),
                                             decoration: BoxDecoration(
                                                 shape: BoxShape.circle,
                                                 border: Border.all(width: 1.0, color: Theme.of(context)
                                                     .disabledColor,)
                                             ),
                                             child:  Icon(
                                               Icons.question_mark_outlined,
                                               size: 4.0,
                                               color: Theme.of(context)
                                                   .disabledColor,
                                             ),
                                           ),
                                         ],
                                       ),
                                       const SizedBox(height: 10.0,),
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.center,
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           Container(
                                             height: 60.0,
                                             padding: EdgeInsets.all(10.0),
                                             decoration: BoxDecoration(
                                                 shape: BoxShape.circle,
                                                 border: Border.all(width: 2.0, color: Theme.of(context)
                                                     .hoverColor.withOpacity(0.5),)
                                             ),
                                             child: Column(
                                               crossAxisAlignment: CrossAxisAlignment.center,
                                               mainAxisAlignment: MainAxisAlignment.center,
                                               children: [
                                                 Text(
                                                   "40.99%",
                                                   style: CustomWidget(
                                                       context: context)
                                                       .CustomSizedTextStyle(
                                                       7,
                                                       Theme.of(context)
                                                           .focusColor,
                                                       FontWeight.w700,
                                                       'FontRegular'),
                                                   textAlign: TextAlign.center,
                                                 ),
                                                 const SizedBox(height: 2.0,),
                                                 Text(
                                                   "1'090 trades",
                                                   style: CustomWidget(
                                                       context: context)
                                                       .CustomSizedTextStyle(
                                                       7,
                                                       Theme.of(context)
                                                           .focusColor,
                                                       FontWeight.w700,
                                                       'FontRegular'),
                                                   textAlign: TextAlign.center,
                                                 ),
                                               ],
                                             ),
                                           ),
                                           const SizedBox(height: 10.0,),
                                           Text(
                                             "7.2 Of 10",
                                             style: CustomWidget(
                                                 context: context)
                                                 .CustomSizedTextStyle(
                                                 9,
                                                 Theme.of(context)
                                                     .focusColor,
                                                 FontWeight.w700,
                                                 'FontRegular'),
                                             textAlign: TextAlign.center,
                                           ),
                                         ],
                                       ),
                                     ],
                                   ),
                                 ), flex: 1,),
                               ],
                             ),
                           ),
                           const SizedBox(height: 20.0,),
                           Container(
                             padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(12.0),
                               border: Border.all(width: 1.0, color: Theme.of(context)
                                   .disabledColor,),
                             ),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(
                                       "+62.65%",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           14.0,
                                           Theme.of(context)
                                               .indicatorColor,
                                           FontWeight.w600,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),
                                     Text(
                                       "+1,096.49",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           14.0,
                                           Theme.of(context)
                                               .indicatorColor,
                                           FontWeight.w600,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),

                                   ],
                                 ),
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(
                                       "30D ROI",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           11.0,
                                           Theme.of(context)
                                               .focusColor.withOpacity(0.5),
                                           FontWeight.w400,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),
                                     Text(
                                       "Master's PnL",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           11.0,
                                           Theme.of(context)
                                               .focusColor.withOpacity(0.5),
                                           FontWeight.w600,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),

                                   ],
                                 ),
                                 const SizedBox(height: 15.0,),
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(
                                       "Account  Assets",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           11.0,
                                           Theme.of(context)
                                               .focusColor.withOpacity(0.5),
                                           FontWeight.w400,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),
                                     Text(
                                       "5,905.2",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           12.0,
                                           Theme.of(context)
                                               .focusColor,
                                           FontWeight.w600,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),

                                   ],
                                 ),
                                 const SizedBox(height: 15.0,),
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(
                                       "Copier Profit",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           11.0,
                                           Theme.of(context)
                                               .focusColor.withOpacity(0.5),
                                           FontWeight.w400,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),
                                     Text(
                                       "+6,5333.25",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           12.0,
                                           Theme.of(context)
                                               .indicatorColor,
                                           FontWeight.w600,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),

                                   ],
                                 ),
                                 const SizedBox(height: 15.0,),
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(
                                       "Copiers",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           11.0,
                                           Theme.of(context)
                                               .focusColor.withOpacity(0.5),
                                           FontWeight.w400,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),
                                     Text(
                                       "368",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           12.0,
                                           Theme.of(context)
                                               .focusColor,
                                           FontWeight.w600,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),

                                   ],
                                 ),
                                 const SizedBox(height: 15.0,),
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(
                                       "Risk",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           11.0,
                                           Theme.of(context)
                                               .focusColor.withOpacity(0.5),
                                           FontWeight.w400,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),
                                     Container(
                                       padding: EdgeInsets.only(top: 2.0,bottom: 2.0, left: 4.0, right: 4.0),
                                       decoration: BoxDecoration(
                                         color: Theme.of(context)
                                             .indicatorColor,
                                       ),
                                       child: Text(
                                         "3",
                                         style:
                                         CustomWidget(context: context)
                                             .CustomSizedTextStyle(
                                             11.0,
                                             Theme.of(context)
                                                 .focusColor,
                                             FontWeight.w600,
                                             'FontRegular'),
                                         textAlign: TextAlign.start,
                                       ),
                                     ),

                                   ],
                                 ),
                                 const SizedBox(height: 15.0,),
                                 Container(
                                   width: MediaQuery.of(context).size.width,
                                   height: 1.0,
                                   color: Theme.of(context)
                                       .focusColor.withOpacity(0.4),
                                 ),
                                 const SizedBox(height: 15.0,),
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(
                                       "Cumulative Copiers",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           11.0,
                                           Theme.of(context)
                                               .focusColor.withOpacity(0.5),
                                           FontWeight.w400,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),
                                     Text(
                                       "1259",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           12.0,
                                           Theme.of(context)
                                               .focusColor,
                                           FontWeight.w600,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),

                                   ],
                                 ),
                                 const SizedBox(height: 15.0,),
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(
                                       "Win Ratio",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           11.0,
                                           Theme.of(context)
                                               .focusColor.withOpacity(0.5),
                                           FontWeight.w400,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),
                                     Text(
                                       "100%",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           12.0,
                                           Theme.of(context)
                                               .focusColor,
                                           FontWeight.w600,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),

                                   ],
                                 ),
                                 const SizedBox(height: 15.0,),
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(
                                       "Total Transactions",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           11.0,
                                           Theme.of(context)
                                               .focusColor.withOpacity(0.5),
                                           FontWeight.w400,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),
                                     Text(
                                       "530",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           12.0,
                                           Theme.of(context)
                                               .focusColor,
                                           FontWeight.w600,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),

                                   ],
                                 ),
                                 const SizedBox(height: 15.0,),
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(
                                       "No. of Winning Trades",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           11.0,
                                           Theme.of(context)
                                               .focusColor.withOpacity(0.5),
                                           FontWeight.w400,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),
                                     Text(
                                       "530",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           12.0,
                                           Theme.of(context)
                                               .focusColor,
                                           FontWeight.w600,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),

                                   ],
                                 ),
                                 const SizedBox(height: 15.0,),
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(
                                       "No. of Losing Trades ",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           11.0,
                                           Theme.of(context)
                                               .focusColor.withOpacity(0.5),
                                           FontWeight.w400,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),
                                     Text(
                                       "--",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           12.0,
                                           Theme.of(context)
                                               .focusColor,
                                           FontWeight.w600,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),

                                   ],
                                 ),
                                 const SizedBox(height: 15.0,),
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(
                                       "Average profit ",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           11.0,
                                           Theme.of(context)
                                               .focusColor.withOpacity(0.5),
                                           FontWeight.w400,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),
                                     Text(
                                       "4.4 (21.9%)",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           12.0,
                                           Theme.of(context)
                                               .focusColor,
                                           FontWeight.w600,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),

                                   ],
                                 ),
                                 const SizedBox(height: 15.0,),
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(
                                       "Average losses",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           11.0,
                                           Theme.of(context)
                                               .focusColor.withOpacity(0.5),
                                           FontWeight.w400,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),
                                     Text(
                                       "0.00 (0.00%)",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           12.0,
                                           Theme.of(context)
                                               .focusColor,
                                           FontWeight.w600,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),

                                   ],
                                 ),
                                 const SizedBox(height: 15.0,),
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(
                                       "PnL Ratio",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           11.0,
                                           Theme.of(context)
                                               .focusColor.withOpacity(0.5),
                                           FontWeight.w400,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),
                                     Text(
                                       "--",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           12.0,
                                           Theme.of(context)
                                               .focusColor,
                                           FontWeight.w600,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),

                                   ],
                                 ),
                                 const SizedBox(height: 15.0,),
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(
                                       "Average Holding time",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           11.0,
                                           Theme.of(context)
                                               .focusColor.withOpacity(0.5),
                                           FontWeight.w400,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),
                                     Text(
                                       "7.55H",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           12.0,
                                           Theme.of(context)
                                               .focusColor,
                                           FontWeight.w600,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),

                                   ],
                                 ),
                                 const SizedBox(height: 15.0,),
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(
                                       "Trading Frequency (Weekly)",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           11.0,
                                           Theme.of(context)
                                               .focusColor.withOpacity(0.5),
                                           FontWeight.w400,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),
                                     Text(
                                       "58.8 times",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           12.0,
                                           Theme.of(context)
                                               .focusColor,
                                           FontWeight.w600,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),

                                   ],
                                 ),
                                 const SizedBox(height: 15.0,),
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(
                                       "Trade Days",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           11.0,
                                           Theme.of(context)
                                               .focusColor.withOpacity(0.5),
                                           FontWeight.w400,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),
                                     Text(
                                       "60D",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           12.0,
                                           Theme.of(context)
                                               .focusColor,
                                           FontWeight.w600,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),

                                   ],
                                 ),
                                 const SizedBox(height: 15.0,),
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(
                                       "Last Trading Time",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           11.0,
                                           Theme.of(context)
                                               .focusColor.withOpacity(0.5),
                                           FontWeight.w400,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),
                                     Text(
                                       "2023-05-12 08:05",
                                       style:
                                       CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           12.0,
                                           Theme.of(context)
                                               .focusColor,
                                           FontWeight.w600,
                                           'FontRegular'),
                                       textAlign: TextAlign.start,
                                     ),

                                   ],
                                 ),
                                 const SizedBox(height: 15.0,),

                                 Padding(padding: EdgeInsets.only(left: 15.0),
                                   child: Text(
                                     "Current Unit : USDT",
                                     style:
                                     CustomWidget(context: context)
                                         .CustomSizedTextStyle(
                                         11.0,
                                         Theme.of(context)
                                             .focusColor.withOpacity(0.5),
                                         FontWeight.w400,
                                         'FontRegular'),
                                     textAlign: TextAlign.start,
                                   ),),
                                 const SizedBox(height: 15.0,),

                               ],
                             ),
                           ),
                           const SizedBox(height: 20.0,),
                           Container(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               children: [
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     InkWell(
                                       onTap: (){

                                       },
                                       child:  Row(
                                         children: [
                                           Icon(
                                             Icons.share,
                                             size: 15.0,
                                             color:  Theme.of(context)
                                                 .focusColor,
                                           ),
                                           const SizedBox(width: 5.0,),
                                           Text(
                                             "Share",
                                             style:
                                             CustomWidget(context: context)
                                                 .CustomSizedTextStyle(
                                                 13.0,
                                                 Theme.of(context)
                                                     .focusColor,
                                                 FontWeight.w400,
                                                 'FontRegular'),
                                             textAlign: TextAlign.start,
                                           )
                                         ],
                                       ),
                                     ),
                                     const SizedBox(width: 25.0,),
                                     Container(
                                       height: 15.0,
                                       width: 1.0,
                                       color: Theme.of(context)
                                           .focusColor.withOpacity(0.5),
                                     ),
                                     const SizedBox(width: 25.0,),
                                     InkWell(
                                       onTap: (){

                                       },
                                       child: Row(
                                         children: [
                                           Icon(
                                             Icons.star_border,
                                             size: 15.0,
                                             color:  Theme.of(context)
                                                 .focusColor,
                                           ),
                                           const SizedBox(width: 5.0,),
                                           Text(
                                             "Subscribe",
                                             style:
                                             CustomWidget(context: context)
                                                 .CustomSizedTextStyle(
                                                 13.0,
                                                 Theme.of(context)
                                                     .focusColor,
                                                 FontWeight.w400,
                                                 'FontRegular'),
                                             textAlign: TextAlign.start,
                                           )
                                         ],
                                       ),
                                     ),

                                   ],
                                 ),
                                 const SizedBox(height: 30.0,),
                                 InkWell(
                                   child: Container(
                                     width: MediaQuery.of(context).size.width*0.80,
                                     padding: EdgeInsets.only(top: 14.0, bottom: 14.0),
                                     decoration: BoxDecoration(
                                         color: Theme.of(context).disabledColor,
                                         borderRadius: BorderRadius.circular(12.0)
                                     ),
                                     child: Row(
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         Icon(
                                           Icons.local_fire_department,
                                           size: 18.0,
                                           color: Theme.of(context).primaryColor,
                                         ),
                                         const SizedBox(width: 3.0,),
                                         Text(
                                           "Copy Trade",
                                           style: CustomWidget(context: context)
                                               .CustomSizedTextStyle(
                                               12.0,
                                               Theme.of(context).focusColor,
                                               FontWeight.w600,
                                               'FontRegular'),
                                         ),
                                       ],
                                     ),
                                   ),
                                 )
                               ],
                             ),
                           ),
                           const SizedBox(height: 25.0,),
                           // const SizedBox(height: 25.0,),
                         ],
                       ),
                     ) : Container(
                       height: MediaQuery
                           .of(context)
                           .size
                           .height * 0.5,
                       decoration: BoxDecoration(
                         color: Theme
                             .of(context)
                             .primaryColor,
                       ),
                       child: Center(
                         child: Text(
                           " No records Found..!",
                           style: TextStyle(
                             fontFamily: "FontRegular",
                             color: Theme
                                 .of(context)
                                 .focusColor,
                           ),
                         ),
                       ),
                     )

                    ],
                  ),
                ),
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: InkWell(
              //     child: Container(
              //       width: MediaQuery.of(context).size.width,
              //       margin: EdgeInsets.only(bottom: 15.0, right: 15.0, left: 15.0),
              //       padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
              //       decoration: BoxDecoration(
              //           color: Theme.of(context).disabledColor,
              //           borderRadius: BorderRadius.circular(25.0)
              //       ),
              //       child: Row(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Icon(
              //             Icons.local_fire_department,
              //             size: 18.0,
              //             color: Theme.of(context).primaryColor,
              //           ),
              //           const SizedBox(width: 3.0,),
              //           Text(
              //             "Copy now",
              //             style: CustomWidget(context: context)
              //                 .CustomSizedTextStyle(
              //                 12.0,
              //                 Theme.of(context).focusColor,
              //                 FontWeight.w600,
              //                 'FontRegular'),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
