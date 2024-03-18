import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imperial/common/localization/localizations.dart';
import 'package:imperial/common/textformfield_custom.dart';
import 'package:imperial/data/crypt_model/common_model.dart';
import 'package:imperial/data/crypt_model/my_subscription_model.dart';

import '../common/custom_widget.dart';
import '../common/theme/custom_theme.dart';
import '../data/api_utils.dart';
import '../data/crypt_model/allmasters_model.dart';
import 'basic/subscription.dart';
import 'copy_trade_details.dart';

class Copy_Trade extends StatefulWidget {
  const Copy_Trade({Key? key}) : super(key: key);

  @override
  State<Copy_Trade> createState() => _Copy_TradeState();
}

class _Copy_TradeState extends State<Copy_Trade> {

  bool loading = false;
  bool trade= false;
  bool master= false;
  bool subscribe= true;
  APIUtils apiUtils = APIUtils();

  List<FollowerUserId> followerUserId=[];

  List<GetAllMasters> mastersListAll =[];
  List<GetAllMasters> masterAdd =[];
  List<SubscriptionDetails> subscripDetails=[];
  // List<FollowerUserId> followDetails=[];
  ScrollController controller = ScrollController();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  String userID="";
  String masterId="";
  FocusNode amountFocus = new FocusNode();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    trade= true;
    // subscribe= true;
    loading = true;
    getMastersList();
    getWallList();
  }
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              color: Theme.of(context).primaryColor,
              child: loading
                  ? CustomWidget(context: context)
                  .loadingIndicator(Theme.of(context).disabledColor)
                  : Column(
                children: [
                  Expanded(
                    child: favList(),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget favList() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
        child: Stack(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Copy trade",
                    style: CustomWidget(context: context)
                        .CustomSizedTextStyle(
                        20.0,
                        Theme.of(context).focusColor,
                        FontWeight.w600,
                        'FontRegular'),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: (){
                          setState(() {
                            trade = true;
                            master = false;
                          });
                        },
                        child:  Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 8.0),
                          decoration: trade ? BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color: Theme.of(context).canvasColor,
                          ) : BoxDecoration(),
                          child:  Text(
                            "Top Masters Traders",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                14.0,
                                trade ? Theme.of(context).disabledColor: Theme.of(context).dividerColor,
                                trade ? FontWeight.w600 : FontWeight.w400,
                                'FontRegular'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15.0,),
                      // InkWell(
                      //   onTap: (){
                      //     setState(() {
                      //       trade = false;
                      //       master = true;
                      //     });
                      //   },
                      //   child: Container(
                      //     alignment: Alignment.center,
                      //     padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 8.0),
                      //     decoration: master?  BoxDecoration(
                      //       borderRadius: BorderRadius.circular(6.0),
                      //       color: Theme.of(context).canvasColor,
                      //     ): BoxDecoration(),
                      //     child:  Text(
                      //       "All Masters",
                      //       style: CustomWidget(context: context)
                      //           .CustomSizedTextStyle(
                      //           14.0,
                      //           master? Theme.of(context).disabledColor : Theme.of(context).dividerColor,
                      //           master?  FontWeight.w600 : FontWeight.w400,
                      //           'FontRegular'),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                 Row(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Flexible(child:  Container(
                       decoration: BoxDecoration(
                           border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,),
                           borderRadius: BorderRadius.circular(25.0)
                       ),
                       height: 45.0,
                       padding: EdgeInsets.only(left: 10.0, right: 10.0),
                       width: MediaQuery.of(context).size.width,
                       child: TextField(
                         controller: searchController,
                         focusNode: searchFocus,
                         enabled: true,
                         onEditingComplete: () {
                           setState(() {
                             searchFocus.unfocus();

                           });
                         },
                         onChanged: (value) {
                           setState(() {
                             masterAdd = [];
                             for (int m = 0; m < mastersListAll.length; m++) {
                               if (mastersListAll[m].master!.name.toString().toLowerCase().contains(value.toLowerCase()) ||
                                   mastersListAll[m].master!.name.toString().toLowerCase().contains(value.toLowerCase())) {
                                 masterAdd.add(mastersListAll[m]);
                               }
                             }
                           });
                         },
                         decoration: InputDecoration(
                           contentPadding: const EdgeInsets.only(
                               left: 10, right: 0, top: 8, bottom: 8),
                           hintText: "Search",
                           hintStyle: TextStyle(
                               fontFamily: "FontRegular",
                               color: Theme.of(context).highlightColor,
                               fontSize: 14.0,
                               fontWeight: FontWeight.w500),
                           filled: true,
                           fillColor: Colors.transparent,
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.all(Radius.circular(10.0)),
                             borderSide: BorderSide(
                                 color: Colors.transparent,
                                 width: 1.0),
                           ),
                           disabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.all(Radius.circular(10.0)),
                             borderSide: BorderSide(
                                 color: Colors.transparent,
                                 width: 1.0),
                           ),
                           enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.all(Radius.circular(10.0)),
                             borderSide: BorderSide(
                                 color:Colors.transparent,
                                 width: 1.0),
                           ),
                           focusedBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.all(Radius.circular(10.0)),
                             borderSide: BorderSide(
                                 color: Colors.transparent,
                                 width: 1.0),
                           ),
                           errorBorder: const OutlineInputBorder(
                             borderRadius: BorderRadius.all(Radius.circular(5)),
                             borderSide: BorderSide(color: Colors.red, width: 0.0),
                           ),
                         ),
                       ),
                     ), flex: 5,),
                     Flexible(child: InkWell(
                       onTap: (){
                       },
                       child: Container(
                         padding: EdgeInsets.all(8.0),
                         decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,),
                           // color: Theme.of(context).disabledColor,
                         ),
                         child: Icon(Icons.filter_alt_rounded, size: 24.0, color: Theme.of(context).focusColor,),
                       ),
                     ),flex: 1,)
                   ],
                 ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.18),
              child: SingleChildScrollView(
                child: master ?  Container(
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: 15,
                    shrinkWrap: true,
                    controller: controller,
                    itemBuilder: (BuildContext context, int index) {
                      // double data =
                      // double.parse(tradePairList[index].hrExchange.toString());
                      return Column(
                        children: [
                          InkWell(
                            onTap:(){
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => Trade_Details()));
                            },
                            child: Container(
                              padding: EdgeInsets.only(bottom: 10.0),
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
                                              Text(
                                                // name,
                                                "Govahi",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    14.0,
                                                    Theme.of(context)
                                                        .focusColor,
                                                    FontWeight.w500,
                                                    'FontRegular'),
                                                textAlign: TextAlign.start,
                                              ),
                                              const SizedBox(
                                                height: 4.0,
                                              ),
                                              Text(
                                                // tradePairList[index].baseAsset.toString().toUpperCase(),
                                                "\$ 25,055.65",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    16.0,
                                                    Theme.of(context)
                                                        .bottomAppBarColor,
                                                    FontWeight.w900,
                                                    'FontRegular'),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    flex: 3,
                                  ),
                                  Flexible(
                                    child: SvgPicture.asset(
                                      "assets/menu/line.svg",
                                      height: 50.0,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          // data.toStringAsFixed(2) +
                                          "\$46.625,32",
                                          style:
                                          CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                              14.0,
                                              Theme.of(context)
                                                  .focusColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                          textAlign: TextAlign.start,
                                        ),
                                        const SizedBox(
                                          height: 4.0,
                                        ),
                                        // Text(
                                        //   // "\$"+ double.parse(tradePairList[index]
                                        //   //     .currentPrice
                                        //   //     .toString())
                                        //   //     .toStringAsFixed(4),
                                        //   "",
                                        //   style: CustomWidget(context: context).CustomSizedTextStyle(
                                        //       12.0,
                                        //       // double.parse(data.toString()) >= 0
                                        //       //     ? Theme.of(context).indicatorColor
                                        //       //     :
                                        //       Theme.of(context).secondaryHeaderColor,
                                        //       FontWeight.w400,
                                        //       'FontRegular'),
                                        //   textAlign: TextAlign.start,
                                        // )
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
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
                                            Icon(
                                              Icons.arrow_drop_up,
                                              size: 12.0,
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 1.5,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).canvasColor,
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                        ],
                      );
                    },
                  ),
                )
                    : Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      masterAdd.length>0?
                      ListView.builder(
                        itemCount: masterAdd.length,
                        shrinkWrap: true,
                        controller: controller,
                        itemBuilder: (BuildContext context, int index) {
                          bool testData=true;
                          for(int m=0;m<followerUserId.length;m++){
                              if(masterAdd[index].master!.id!.contains(followerUserId[m].followerId.toString()))
                                {
                                  testData=false;
                                }
                          }
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 25.0),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: <Color>[
                                        Theme.of(context).disabledColor.withOpacity(0.2),
                                        Theme.of(context).primaryColor,
                                      ],
                                      tileMode: TileMode.mirror,
                                    ),
                                    border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              // "Bybit signals BTC-ETH-USDT",
                                              masterAdd[index].master!.name.toString().toUpperCase(),
                                              style: CustomWidget(context: context)
                                                  .CustomSizedTextStyle(
                                                  14.0,
                                                  CustomTheme.of(context).focusColor,
                                                  FontWeight.w700,
                                                  'FontRegular'),
                                            ),
                                            const SizedBox(height: 3.0,),
                                            // Text(
                                            //   "(SHORT and LONG)",
                                            //   style: CustomWidget(context: context)
                                            //       .CustomSizedTextStyle(
                                            //       8.0,
                                            //       CustomTheme.of(context).focusColor,
                                            //       FontWeight.w700,
                                            //       'FontRegular'),
                                            // ),
                                          ],
                                        )),
                                        Flexible(child: SvgPicture.asset("assets/menu/bybit.svg", height: 50.0,))
                                      ],
                                    ),
                                    const SizedBox(height: 5.0,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Trade List",
                                                  style: CustomWidget(context: context)
                                                      .CustomSizedTextStyle(
                                                      10.0,
                                                      Theme.of(context).focusColor,
                                                      FontWeight.w600,
                                                      'FontRegular'),
                                                ),
                                                // const SizedBox(width: 5.0,),
                                                // Container(
                                                //   padding: EdgeInsets.all(2.0),
                                                //   decoration: BoxDecoration(
                                                //       border: Border.all(width: 1.0, color: Theme.of(context).focusColor.withOpacity(0.6), ),
                                                //       borderRadius: BorderRadius.circular(2.0)
                                                //   ),
                                                //   child: Text(
                                                //     "7D",
                                                //     style: CustomWidget(context: context)
                                                //         .CustomSizedTextStyle(
                                                //         5.0,
                                                //         Theme.of(context).focusColor.withOpacity(0.6),
                                                //         FontWeight.w700,
                                                //         'FontRegular'),
                                                //   ),
                                                // )
                                              ],
                                            ),
                                            const SizedBox(height: 3.0,),
                                            Text(
                                              // "+ 60.96%",
                                              masterAdd[index].tradeList.toString(),
                                              style: CustomWidget(context: context)
                                                  .CustomSizedTextStyle(
                                                  14.0,
                                                  CustomTheme.of(context).disabledColor,
                                                  FontWeight.w700,
                                                  'FontRegular'),
                                            ),
                                          ],
                                        )),
                                        Flexible(child: SvgPicture.asset("assets/menu/line.svg", height: 50.0,))
                                      ],
                                    ),
                                    const SizedBox(height: 5.0,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Exchange",
                                              style: CustomWidget(context: context)
                                                  .CustomSizedTextStyle(
                                                  8.0,
                                                  CustomTheme.of(context).focusColor,
                                                  FontWeight.w700,
                                                  'FontRegular'),
                                            ),
                                            const SizedBox(height: 3.0,),
                                            // Row(
                                            //   crossAxisAlignment: CrossAxisAlignment.center,
                                            //   mainAxisAlignment: MainAxisAlignment.center,
                                            //   children: [
                                            //     SvgPicture.asset("assets/menu/bybit.svg", height: 10.0,),
                                            //     const SizedBox(width: 2.0,),
                                            //     Text(
                                            //       // "Bybit",
                                            //       masterAdd[index].lastTrade!.tradeIn!.toString().toUpperCase(),
                                            //       style: CustomWidget(context: context)
                                            //           .CustomSizedTextStyle(
                                            //           12.0,
                                            //           Theme.of(context).focusColor,
                                            //           FontWeight.w700,
                                            //           'FontRegular'),
                                            //     ),
                                            //
                                            //   ],
                                            // ),

                                            Text(
                                              //  masterAdd[index].lastTrade!.tradeIn.toString(),
                                              masterAdd[index].lastTrade!.tradeIn.toString()==""|| masterAdd[index].lastTrade!.tradeIn.toString()=="null"
                                                  ? "-" : masterAdd[index].lastTrade!.tradeIn.toString().toUpperCase(),
                                              style: CustomWidget(context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context).focusColor,
                                                  FontWeight.w700,
                                                  'FontRegular'),
                                            ),

                                          ],
                                        ),
                                        const SizedBox(width: 5.0,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Base Coin",
                                              style: CustomWidget(context: context)
                                                  .CustomSizedTextStyle(
                                                  8.0,
                                                  CustomTheme.of(context).focusColor,
                                                  FontWeight.w700,
                                                  'FontRegular'),
                                            ),
                                            const SizedBox(height: 3.0,),
                                            // Row(
                                            //   crossAxisAlignment: CrossAxisAlignment.center,
                                            //   mainAxisAlignment: MainAxisAlignment.center,
                                            //   children: [
                                            //     SvgPicture.asset("assets/menu/bybit.svg", height: 10.0,),
                                            //     const SizedBox(width: 2.0,),
                                            //     Text(
                                            //       "USDT",
                                            //       style: CustomWidget(context: context)
                                            //           .CustomSizedTextStyle(
                                            //           12.0,
                                            //           Theme.of(context).focusColor,
                                            //           FontWeight.w700,
                                            //           'FontRegular'),
                                            //     ),
                                            //
                                            //   ],
                                            // ),
                                            Text(
                                              // "USDT",
                                              masterAdd[index].lastTrade!.symbol.toString()==""|| masterAdd[index].lastTrade!.symbol.toString()=="null"
                                                  ? "-" : masterAdd[index].lastTrade!.symbol.toString().toUpperCase(),
                                              style: CustomWidget(context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context).focusColor,
                                                  FontWeight.w700,
                                                  'FontRegular'),
                                            ),

                                          ],
                                        ),
                                        const SizedBox(width: 8.0,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Rating",
                                              style: CustomWidget(context: context)
                                                  .CustomSizedTextStyle(
                                                  8.0,
                                                  CustomTheme.of(context).focusColor,
                                                  FontWeight.w700,
                                                  'FontRegular'),
                                            ),
                                            const SizedBox(height: 3.0,),
                                            Text(
                                              // "6.4",
                                              masterAdd[index].master!.rating.toString()=="null" || masterAdd[index].master!.rating.toString()==null ||
                                                  masterAdd[index].master!.rating.toString()==""
                                                  ? "0.0" : masterAdd[index].master!.rating.toString(),
                                              style: CustomWidget(context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context).unselectedWidgetColor,
                                                  FontWeight.w700,
                                                  'FontRegular'),
                                            ),

                                          ],
                                        ),
                                        const SizedBox(width: 8.0,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Risk",
                                              style: CustomWidget(context: context)
                                                  .CustomSizedTextStyle(
                                                  8.0,
                                                  CustomTheme.of(context).focusColor,
                                                  FontWeight.w700,
                                                  'FontRegular'),
                                            ),
                                            const SizedBox(height: 3.0,),
                                            Text(
                                              "7.2",
                                              style: CustomWidget(context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context).focusColor,
                                                  FontWeight.w700,
                                                  'FontRegular'),
                                            ),

                                          ],
                                        ),
                                        const SizedBox(width: 8.0,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Type",
                                              style: CustomWidget(context: context)
                                                  .CustomSizedTextStyle(
                                                  8.0,
                                                  CustomTheme.of(context).focusColor,
                                                  FontWeight.w700,
                                                  'FontRegular'),
                                            ),
                                            const SizedBox(height: 3.0,),
                                            Text(
                                              // "USDT",
                                              masterAdd[index].lastTrade!.orderType.toString()=="null" || masterAdd[index].lastTrade!.orderType.toString()==""
                                                  ? "-" :masterAdd[index].lastTrade!.orderType.toString().toUpperCase(),
                                              style: CustomWidget(context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context).focusColor,
                                                  FontWeight.w700,
                                                  'FontRegular'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15.0,),
                                    // InkWell(
                                    //   onTap:(){
                                    //     Navigator.of(context).push(
                                    //         MaterialPageRoute(builder: (context) => Trade_Details(name: masterAdd[index].master!.name.toString(),
                                    //             rating: masterAdd[index].master!.rating.toString())));
                                    //   },
                                    //   child: Container(
                                    //     padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
                                    //     decoration: BoxDecoration(
                                    //         color: Theme.of(context).disabledColor,
                                    //         borderRadius: BorderRadius.circular(20.0)
                                    //     ),
                                    //     child: Row(
                                    //       crossAxisAlignment: CrossAxisAlignment.center,
                                    //       mainAxisAlignment: MainAxisAlignment.center,
                                    //       children: [
                                    //         Icon(
                                    //           Icons.local_fire_department,
                                    //           size: 16.0,
                                    //           color: Theme.of(context).primaryColor,
                                    //         ),
                                    //         const SizedBox(width: 3.0,),
                                    //         Text(
                                    //           "Details",
                                    //           style: CustomWidget(context: context)
                                    //               .CustomSizedTextStyle(
                                    //               12.0,
                                    //               Theme.of(context).focusColor,
                                    //               FontWeight.w600,
                                    //               'FontRegular'),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        testData? Flexible(child: InkWell(
                                          onTap:(){
                                            setState(() {

                                              amountController.clear();
                                            masterId = masterAdd[index].master!.id.toString();
                                              createTicket();
                                            });

                                            // Navigator.of(context).push(
                                            //     MaterialPageRoute(builder: (context) => Subscription_Screen()));
                                            },
                                          child: Container(
                                            padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).disabledColor,
                                                borderRadius: BorderRadius.circular(5.0)
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.local_fire_department,
                                                  size: 16.0,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                                const SizedBox(width: 3.0,),
                                                Text(
                                                  "Subscribe",
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
                                        ), flex: 2,) : Container(),
                                        const SizedBox(width: 20.0,),
                                        Flexible(child: InkWell(
                                          onTap:(){
                                            Navigator.of(context).push(
                                                        MaterialPageRoute(builder: (context) => Trade_Details(name: masterAdd[index].master!.name.toString(),
                                                            rating: masterAdd[index].master!.rating.toString())));
                                        },
                                          child: Container(
                                            padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).disabledColor,
                                                borderRadius: BorderRadius.circular(5.0)
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.local_fire_department,
                                                  size: 16.0,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                                const SizedBox(width: 3.0,),
                                                Text(
                                                  "Details",
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
                                        ), flex: 2,)
                                      ],
                                    )
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
                              color: CustomTheme.of(context).focusColor,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            loading
                ? CustomWidget(context: context).loadingIndicator(
              CustomTheme.of(context).disabledColor,
            )
                : Container()

          ],
        ),
      ),
    );
  }


  createTicket() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext contexts, StateSetter ssetState) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0),
                    ),
                    color: CustomTheme.of(context).disabledColor,
                  ),
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(left: 15.0,right: 15.0,top: 25.0,bottom: 20.0),
                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "Subscribe for Trade",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      CustomTheme.of(context).focusColor,
                                      FontWeight.w700,
                                      'FontRegular'),
                                ),

                                SizedBox(
                                  height: 10.0,
                                ),
                                TextFormFieldCustom(
                                  onEditComplete: () {
                                    amountFocus.unfocus();
                                  },
                                  radius: 8.0,
                                  error: "Enter Amount",
                                  textColor: CustomTheme.of(context).focusColor,
                                  borderColor: Colors.transparent,
                                  fillColor: CustomTheme.of(context).canvasColor,
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      CustomTheme.of(context).dividerColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                                  textStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      CustomTheme.of(context).focusColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                  textInputAction: TextInputAction.next,
                                  focusNode: amountFocus,
                                  maxlines: 1,
                                  text: '',
                                  hintText: "Enter Amount",
                                  obscureText: false,
                                  suffix: Container(
                                    width: 0.0,
                                  ),
                                  textChanged: (value) {},
                                  onChanged: () {},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter Amount";
                                    }
                                    return null;
                                  },
                                  enabled: true,
                                  textInputType: TextInputType.number,
                                  controller: amountController,
                                ),
                                SizedBox(
                                  height: 40.0,
                                ),
                              ],
                            ),
                          ),

                          InkWell(
                            onTap:(){
                              setState(() {
                                if(amountController.text.isEmpty){
                                  CustomWidget(context: context).showSuccessAlertDialog(
                                      "Imperial", "Enter the amount for subscribe", "error");
                                }else {
                                  loading=true;
                                    Navigator.pop(context);
                               getSubscriber();
                                }
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).focusColor,
                                  borderRadius: BorderRadius.circular(8.0)
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.local_fire_department,
                                    size: 16.0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 3.0,),
                                  Text(
                                    "Subscribe",
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        13.0,
                                        Theme.of(context).disabledColor,
                                        FontWeight.w600,
                                        'FontRegular'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                );
              });
        });
  }




  getMastersList() {
    apiUtils.getAllMasters().then((GetAllMastersModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          mastersListAll = loginData.result!;
          masterAdd = loginData.result!;
          // masterId = masterAdd[0].master!.id.toString();

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

  getWallList() {
    apiUtils.getMySubsDetails().then((SubscriptionDetailsModel loginData) {
      if (loginData.success!) {
        setState(() {

          subscripDetails = loginData.result!;
          userID=subscripDetails[0].userId.toString();
          followerUserId=subscripDetails[0].followerUserId!;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print("Mano");
      print(error);
    });
  }

  getSubscriber() {
    apiUtils.addSubscriberInfo( masterId.toString(),amountController.text.toString()).then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          getWallList();
          getMastersList();
          // loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Login", loginData.message.toString(), "success");
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print("Jeeva");
      print(error);
    });
  }

}
