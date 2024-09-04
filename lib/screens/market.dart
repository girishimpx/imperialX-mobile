import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imperial/screens/side_menu/trade_details.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:web_socket_channel/io.dart';

import '../common/custom_widget.dart';
import '../common/theme/custom_theme.dart';
import '../data/api_utils.dart';
import '../data/crypt_model/coin_list_model.dart';
import '../data/crypt_model/new_socket_model.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen>
    with SingleTickerProviderStateMixin {
  bool loading = false;
  int selectedtimeIndex=0;
  var array_dta;

  APIUtils apiUtils = APIUtils();
  ScrollController controller = ScrollController();
  List<Map<String,dynamic>> fav_list=[
    {"icon":"assets/icons/btc.svg","amount":"\$46.625,32","unit":"BTC","percentage":"+24,55%","name":"Bitcoin","image":"assets/images/chartgreen.png"},
    {"icon":"assets/icons/Dodge.svg","amount":"\$1,868","unit":"XRP","percentage":"-24,55%","name":"XRP","image":"assets/images/chartred.png"},
    {"icon":"assets/icons/Xcurrency.svg","amount":"\$0,2811","unit":"DOGE","percentage":"+24,55%","name":"Dogecoin","image":"assets/images/chartgreen.png"},

  ];
  List<String> times=[
    "1hr",
    "24",
    "7d",
  ];

  List<CoinList> tradePairListAll = [];
  List<CoinList> tradePairFutureAll = [];
  String changes = "";
  List arrData = [];
  List arrFutureData = [];
  // String high24h = "";
  Timer? timer,timerS;

  List<String> marketAseetList = ["All Assets"];
  List<String> aseetsList = ["All Assets","Spot", "Futures", "Favorites", "Top Gainers"];
  List<String> marketAssetList = ["USDT","USDC","EUR","BTC","ETH","DAI","BRZ"];
  String selectedmarketAseet = "";
  String selectedMarketAsset = "";
  IOWebSocketChannel? channelOpenOrder,channelFutureOpenOrder;
  bool spot = false;
  bool margin = false;
  bool future = false;
  List<MarketDetailsList> marketList = [];
  List<MarketDetailsList> marketFutureList = [];
  List<MarketDetailsList> coinList = [];
  List<MarketDetailsList> coinFutureList = [];
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  int indexVal = 0;
  int count = 10;
  int countN = 0;
  int futureCount = 10;
  int futureCountN = 0;
  @override
  void dispose() {
    // TODO: implement dispose
    timerS?.cancel();
    timer?.cancel();
    channelOpenOrder?.sink.close();
    channelFutureOpenOrder?.sink.close();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loading=true;
    getCoinList();
    getFutureCoinList();
    channelOpenOrder = IOWebSocketChannel.connect(Uri.parse("wss://stream.bybit.com/v5/public/spot"),);
    channelFutureOpenOrder = IOWebSocketChannel.connect(Uri.parse("wss://stream.bybit.com/v5/public/linear"),);
    if (mounted) {
      timerS = Timer.periodic(Duration(seconds: 2), (Timer t) => socketClose());
      timer = Timer.periodic(
          Duration(seconds: 2), (Timer t) => socketFutureClose());
    }
    spot = true;
  }

  socketClose(){
    if(count<marketList.length)
    {
      countN=count;
      count=count+10;

    }
    else{
      count=0;
      timerS!.cancel();
    }


    // print(count.toString()+"textM"+countN.toString());
    arrData.clear();
    arrData=[];
    for(int m=countN;m<count;m++)
    {
      arrData.add("tickers."+tradePairListAll[m].data!.instId.toString());
    }

    //channelOpenOrder!.sink.close();
    channelOpenOrder = IOWebSocketChannel.connect(Uri.parse("wss://stream.bybit.com/v5/public/spot"),);

    loading = false;
    var messageJSON = {
      "op": "subscribe",
      "args": arrData,
    };
    channelOpenOrder!.sink.add(json.encode(messageJSON));

    socketData();
  }

  socketFutureClose(){
    if(futureCount<marketFutureList.length)
    {
      futureCountN=futureCount;
      futureCount=futureCount+10;

    }
    else{
      futureCount=0;
      timer!.cancel();
    }


    // print(count.toString()+"textM"+countN.toString());
    arrFutureData.clear();
    arrFutureData=[];
    for(int m=futureCountN;m<futureCount;m++)
    {
      arrFutureData.add("tickers."+tradePairFutureAll[m].data!.instId.toString());
    }

    //channelOpenOrder!.sink.close();
    channelFutureOpenOrder = IOWebSocketChannel.connect(Uri.parse("wss://stream.bybit.com/v5/public/linear"),);

    loading = false;
    var futuremessageJSON = {
      "op": "subscribe",
      "args": arrFutureData,
    };
    channelFutureOpenOrder!.sink.add(json.encode(futuremessageJSON));

    socketFutureData();
  }


  socketData() {
    channelOpenOrder!.stream.listen(
      (data) {
        if (data != null || data != "null") {
          var decode = jsonDecode(data);
          // print(decode);
          if (mounted) {
            setState(() {
              String last = decode["data"]['lastPrice'].toString();
              String high24h = decode["data"]['highPrice24h'].toString();
              String low24h = decode["data"]['lowPrice24h'].toString();
              String askPrice = decode["data"]['turnover24h'].toString();
              String bitPrice = decode["data"]['volume24h'].toString();
              double val = double.parse(last) - double.parse(high24h);
              double lastChangge = (val / double.parse(high24h)) * 100;
              for (int m = 0; m < marketList.length; m++) {
                if (marketList[m].name.toString().toLowerCase() ==
                    decode["data"]['symbol'].toString().toLowerCase()) {
                  marketList[m].last = last;
                  marketList[m].change = lastChangge;
                  marketList[m].high = high24h;
                  marketList[m].low = low24h;
                  marketList[m].askP = askPrice;
                  marketList[m].bitP = bitPrice;
                }
              }
            });
          }

          // print("Mano");
        }
      },
      onDone: () async {
        await Future.delayed(Duration(seconds: 10));
        var messageJSON = {
          "op": "subscribe",
          "args": arrData,
        };


        channelOpenOrder = IOWebSocketChannel.connect(Uri.parse("wss://stream.bybit.com/v5/public/spot"),);

        channelOpenOrder!.sink.add(json.encode(messageJSON));
        socketData();
      },
      onError: (error) => print("Err" + error),
    );
  }

  socketFutureData() {
    channelFutureOpenOrder!.stream.listen(
          (data) {
        if (data != null || data != "null") {
          var decode = jsonDecode(data);
          // print(decode);
          if (mounted) {
            setState(() {
              String last = decode["data"]['lastPrice'].toString();
              String high24h = decode["data"]['highPrice24h'].toString();
              String low24h = decode["data"]['lowPrice24h'].toString();
              String askPrice = decode["data"]['turnover24h'].toString();
              String bitPrice = decode["data"]['volume24h'].toString();
              double val = double.parse(last) - double.parse(high24h);
              double lastChangge = (val / double.parse(high24h)) * 100;
              for (int m = 0; m < marketFutureList.length; m++) {
                if (marketFutureList[m].name.toString().toLowerCase() ==
                    decode["data"]['symbol'].toString().toLowerCase()) {
                  marketFutureList[m].last = last;
                  marketFutureList[m].change = lastChangge;
                  marketFutureList[m].high = high24h;
                  marketFutureList[m].low = low24h;
                  marketFutureList[m].askP = askPrice;
                  marketFutureList[m].bitP = bitPrice;
                }
              }
            });
          }

          // print("Mano");
        }
      },
      onDone: () async {
        await Future.delayed(Duration(seconds: 10));
        var futuremessageJSON = {
          "op": "subscribe",
          "args": arrFutureData,
        };


        channelFutureOpenOrder = IOWebSocketChannel.connect(Uri.parse("wss://stream.bybit.com/v5/public/linear"),);

        channelFutureOpenOrder!.sink.add(json.encode(futuremessageJSON));
        socketFutureData();
      },
      onError: (error) => print("Err" + error),
    );
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
        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 2),
        child: Stack(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Markets",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        20.0,
                        CustomTheme.of(context).focusColor,
                        FontWeight.w600,
                        'FontRegular'),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     InkWell(
                  //       onTap: () {
                  //         setState(() {
                  //           spot = true;
                  //           margin = false;
                  //           future = false;
                  //         });
                  //       },
                  //       child: Container(
                  //         alignment: Alignment.center,
                  //         padding: EdgeInsets.only(
                  //             left: 12.0, right: 12.0, top: 6.0, bottom: 8.0),
                  //         decoration: spot
                  //             ? BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(6.0),
                  //                 color: Theme.of(context).canvasColor,
                  //               )
                  //             : BoxDecoration(),
                  //         child: Text(
                  //           "All Assets",
                  //           style: CustomWidget(context: context)
                  //               .CustomSizedTextStyle(
                  //                   14.0,
                  //                   spot
                  //                       ? Theme.of(context).disabledColor
                  //                       : Theme.of(context).dividerColor,
                  //                   spot ? FontWeight.w600 : FontWeight.w400,
                  //                   'FontRegular'),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(
                  //       width: 15.0,
                  //     ),
                  //     InkWell(
                  //       onTap: () {
                  //         setState(() {
                  //           spot = false;
                  //           margin = true;
                  //           future = false;
                  //         });
                  //       },
                  //       child: Container(
                  //         alignment: Alignment.center,
                  //         padding: EdgeInsets.only(
                  //             left: 12.0, right: 12.0, top: 6.0, bottom: 8.0),
                  //         decoration: margin
                  //             ? BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(6.0),
                  //                 color: Theme.of(context).canvasColor,
                  //               )
                  //             : BoxDecoration(),
                  //         child: Text(
                  //           "Favorites",
                  //           style: CustomWidget(context: context)
                  //               .CustomSizedTextStyle(
                  //                   14.0,
                  //                   margin
                  //                       ? Theme.of(context).disabledColor
                  //                       : Theme.of(context).dividerColor,
                  //                   margin ? FontWeight.w600 : FontWeight.w400,
                  //                   'FontRegular'),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(
                  //       width: 15.0,
                  //     ),
                  //     InkWell(
                  //       onTap: () {
                  //         setState(() {
                  //           spot = false;
                  //           margin = false;
                  //           future = true;
                  //         });
                  //       },
                  //       child: Container(
                  //         alignment: Alignment.center,
                  //         padding: EdgeInsets.only(
                  //             left: 12.0, right: 12.0, top: 6.0, bottom: 8.0),
                  //         decoration: future
                  //             ? BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(6.0),
                  //                 color: Theme.of(context).canvasColor,
                  //               )
                  //             : BoxDecoration(),
                  //         child: Text(
                  //           "Top Gainers",
                  //           style: CustomWidget(context: context)
                  //               .CustomSizedTextStyle(
                  //                   14.0,
                  //                   future
                  //                       ? Theme.of(context).disabledColor
                  //                       : Theme.of(context).dividerColor,
                  //                   future ? FontWeight.w600 : FontWeight.w400,
                  //                   'FontRegular'),
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  Container(
                    margin: EdgeInsets.only(left: 0.00),
                    child: ListView.builder(
                      itemCount: aseetsList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  indexVal = index;
                                  selectedmarketAseet = aseetsList[index];
                                  searchController.clear();

                                  if(indexVal == 0){
                                    loading = true;
                                    getCoinList();
                                  } else if(indexVal == 1){
                                    loading = true;
                                    getCoinList();
                                  }
                                  else if(indexVal == 2){
                                    loading = true;
                                    getFutureCoinList();
                                  }

                                  // tradePairList.clear();
                                  // tradePairList = [];

                                  // for (int m = 0; m < tradePairListAll.length; m++) {
                                  //   if (tradePairListAll[m].marketAsset.toString().toLowerCase() ==
                                  //       selectedmarketAseet.toLowerCase()) {
                                  //     tradePairList.add(tradePairListAll[m]);
                                  //   }
                                  // }

                                });
                              },
                              child:
                              Container(
                                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                                  decoration: indexVal == index ?  BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.0),
                                    color: Theme.of(context).canvasColor,
                                    ) : BoxDecoration(
                                  ),
                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(5.0),
                                  //   color: CustomTheme.of(context).disabledColor : CustomTheme.of(context).focusColor,
                                  // ),
                                  child: Center(
                                    child: Text(
                                      aseetsList[index].toString(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          12.0,
                                          indexVal == index
                                              ? Theme.of(context).disabledColor
                                              : Theme.of(context).focusColor.withOpacity(0.6),
                                          FontWeight.w500,
                                          'FontRegular'),
                                    ),
                                  )),
                            ),
                            const SizedBox(
                              width: 10.0,
                            )
                          ],
                        );
                      },
                    ),
                    height: 30.0,
                  ),
                  const SizedBox(
                    height: 0.0,
                  ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Flexible(child:  Container(
                  //       decoration: BoxDecoration(
                  //           border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,),
                  //           borderRadius: BorderRadius.circular(25.0)
                  //       ),
                  //       height: 45.0,
                  //       padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  //       width: MediaQuery.of(context).size.width,
                  //       child: TextField(
                  //         controller: searchController,
                  //         focusNode: searchFocus,
                  //         enabled: true,
                  //         onEditingComplete: () {
                  //           setState(() {
                  //             searchFocus.unfocus();
                  //
                  //           });
                  //         },
                  //         onChanged: (value) {
                  //           setState(() {
                  //             coinList = [];
                  //             coinFutureList = [];
                  //             if(indexVal ==2){
                  //               for (int m = 0; m < marketFutureList.length; m++) {
                  //                 if (marketFutureList[m].name.toString()
                  //                     .toLowerCase()
                  //                     .contains(value.toLowerCase()) ||
                  //                     marketFutureList[m].name.toString()
                  //                         .toLowerCase()
                  //                         .contains(value.toLowerCase())) {
                  //                   coinFutureList.add(marketFutureList[m]);
                  //                 }
                  //               }
                  //             }else {
                  //               for (int m = 0; m < marketList.length; m++) {
                  //                 if (marketList[m].name.toString()
                  //                     .toLowerCase()
                  //                     .contains(value.toLowerCase()) ||
                  //                     marketList[m].name.toString()
                  //                         .toLowerCase()
                  //                         .contains(value.toLowerCase())) {
                  //                   coinList.add(marketList[m]);
                  //                 }
                  //               }
                  //             }
                  //           });
                  //         },
                  //         decoration: InputDecoration(
                  //           contentPadding: const EdgeInsets.only(
                  //               left: 10, right: 0, top: 8, bottom: 8),
                  //           hintText: "Search",
                  //           hintStyle: TextStyle(
                  //               fontFamily: "FontRegular",
                  //               color: Theme.of(context).highlightColor,
                  //               fontSize: 14.0,
                  //               fontWeight: FontWeight.w500),
                  //           filled: true,
                  //           fillColor: Colors.transparent,
                  //           border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //             borderSide: BorderSide(
                  //                 color: Colors.transparent,
                  //                 width: 1.0),
                  //           ),
                  //           disabledBorder: OutlineInputBorder(
                  //             borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //             borderSide: BorderSide(
                  //                 color: Colors.transparent,
                  //                 width: 1.0),
                  //           ),
                  //           enabledBorder: OutlineInputBorder(
                  //             borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //             borderSide: BorderSide(
                  //                 color:Colors.transparent,
                  //                 width: 1.0),
                  //           ),
                  //           focusedBorder: OutlineInputBorder(
                  //             borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //             borderSide: BorderSide(
                  //                 color: Colors.transparent,
                  //                 width: 1.0),
                  //           ),
                  //           errorBorder: const OutlineInputBorder(
                  //             borderRadius: BorderRadius.all(Radius.circular(5)),
                  //             borderSide: BorderSide(color: Colors.red, width: 0.0),
                  //           ),
                  //         ),
                  //       ),
                  //     ), flex: 5,),
                  //     Flexible(child: InkWell(
                  //       onTap: (){
                  //       },
                  //       child: Container(
                  //         padding: EdgeInsets.all(8.0),
                  //         decoration: BoxDecoration(
                  //           shape: BoxShape.circle,
                  //           border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,),
                  //           // color: Theme.of(context).disabledColor,
                  //         ),
                  //         child: Icon(Icons.filter_alt_rounded, size: 24.0, color: Theme.of(context).focusColor,),
                  //       ),
                  //     ),flex: 1,)
                  //   ],
                  // ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10.0),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                // Container(
                                //   padding: EdgeInsets.all(1.0),
                                //   decoration: BoxDecoration(
                                //     shape: BoxShape.circle,
                                //   ),
                                //   child: Image.network(
                                //     marketList[index].image.toString(),
                                //     // "assets/icons/btc.svg",
                                //     height: 35.0,
                                //     // color: Theme.of(context).disabledColor,
                                //   ),
                                // ),
                                // const SizedBox(
                                //   width: 10.0,
                                // ),
                                Text(
                                  // name,
                                  // "Bitcoin",
                                  "Name",
                                  style: CustomWidget(
                                      context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context)
                                          .dividerColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                  textAlign: TextAlign.start,
                                  overflow:
                                  TextOverflow.ellipsis,
                                ),
                                const SizedBox(width: 2.0,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      child: SvgPicture.asset('assets/icons/arrow.svg',color:      Theme.of(context)
                                          .dividerColor,height: 10.0,),
                                    ),
                                    InkWell(
                                      child: SvgPicture.asset('assets/icons/down.svg',color:      Theme.of(context)
                                          .dividerColor,height: 10.0,),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          flex: 3,
                        ),
                        Flexible(

                          child: Container(
                              child: Row(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Last Price",
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).dividerColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            child: SvgPicture.asset('assets/icons/arrow.svg',color:      Theme.of(context)
                                                .dividerColor,height: 10.0,),
                                          ),
                                          InkWell(
                                            child: SvgPicture.asset('assets/icons/down.svg',color:      Theme.of(context)
                                                .dividerColor,height: 10.0,),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "24hr Change",
                                        style:
                                        CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            12,
                                            Theme.of(context)
                                                .dividerColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                        textAlign: TextAlign.center,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            child: SvgPicture.asset('assets/icons/arrow.svg',color:      Theme.of(context)
                                                .dividerColor,height: 10.0,),
                                          ),
                                          InkWell(
                                            child: SvgPicture.asset('assets/icons/down.svg',color:      Theme.of(context)
                                                .dividerColor,height: 10.0,),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              )
                          ),
                          flex: 4,
                        ),



                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(left: 0.00),
                  //   child: ListView.builder(
                  //     itemCount: marketAssetList.length,
                  //     scrollDirection: Axis.horizontal,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return Row(
                  //         children: [
                  //           InkWell(
                  //             onTap: () {
                  //               setState(() {
                  //                 indexVal = index;
                  //                 selectedMarketAsset = marketAssetList[index];
                  //                 // tradePairList.clear();
                  //                 // tradePairList = [];
                  //
                  //                 // for (int m = 0; m < tradePairListAll.length; m++) {
                  //                 //   if (tradePairListAll[m].marketAsset.toString().toLowerCase() ==
                  //                 //       selectedmarketAseet.toLowerCase()) {
                  //                 //     tradePairList.add(tradePairListAll[m]);
                  //                 //   }
                  //                 // }
                  //
                  //               });
                  //             },
                  //             child: Container(
                  //                 padding:
                  //                 EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  //                 decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(5.0),
                  //
                  //                   // gradient: indexVal == index
                  //                   //     ? LinearGradient(
                  //                   //   begin: Alignment.bottomLeft,
                  //                   //   end: Alignment.topRight,
                  //                   //   colors: <Color>[
                  //                   //     CustomTheme.of(context).bottomAppBarColor,
                  //                   //     CustomTheme.of(context).backgroundColor,
                  //                   //
                  //                   //   ],
                  //                   //   tileMode: TileMode.mirror,
                  //                   // )
                  //                   //     : LinearGradient(
                  //                   //   begin: Alignment.topLeft,
                  //                   //   end: Alignment.bottomRight,
                  //                   //   colors: <Color>[
                  //                   //     CustomTheme.of(context).focusColor,
                  //                   //     CustomTheme.of(context).focusColor,
                  //                   //   ],
                  //                   //   tileMode: TileMode.mirror,
                  //                   // ),
                  //                   color: indexVal == index ? CustomTheme.of(context).disabledColor : CustomTheme.of(context).focusColor,
                  //                 ),
                  //                 child: Center(
                  //                   child: Text(
                  //                     marketAssetList[index].toString(),
                  //                     style: CustomWidget(context: context)
                  //                         .CustomSizedTextStyle(
                  //                         10.0,
                  //                         indexVal == index
                  //                             ? Theme.of(context).focusColor
                  //                             : Theme.of(context).cardColor.withOpacity(0.6),
                  //                         FontWeight.w500,
                  //                         'FontRegular'),
                  //                   ),
                  //                 )),
                  //           ),
                  //           const SizedBox(
                  //             width: 10.0,
                  //           )
                  //         ],
                  //       );
                  //     },
                  //   ),
                  //   height: 30.0,
                  // ),
                ],
              ),
            ),
           indexVal==2 ?
           Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.14),
              child: coinFutureList.length > 0 ? ListView.builder(
                itemCount: coinFutureList.length,
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
                            MaterialPageRoute(
                              builder: (context) => MarketTrade_Details(
                                  coinName: coinFutureList[index].name.toString(), coinPrice:coinFutureList[index].last.toString(),
                                  coinDiference: coinFutureList[index].change.toString(), coinhigh24h: coinFutureList[index].high.toString(),
                                  coinlow24l: coinFutureList[index].low.toString(), coinAskP: coinFutureList[index].askP.toString(), coinBitP: coinFutureList[index].bitP.toString()
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                      // Container(
                                      //   padding: EdgeInsets.all(1.0),
                                      //   decoration: BoxDecoration(
                                      //     shape: BoxShape.circle,
                                      //   ),
                                      //   child: Image.network(
                                      //     marketList[index].image.toString(),
                                      //     // "assets/icons/btc.svg",
                                      //     height: 35.0,
                                      //     // color: Theme.of(context).disabledColor,
                                      //   ),
                                      // ),
                                      // const SizedBox(
                                      //   width: 10.0,
                                      // ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.24,
                                            child: Text(
                                              // name,
                                              // "Bitcoin",
                                              coinFutureList[index]
                                                  .name
                                                  .toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  14.0,
                                                  Theme.of(context)
                                                      .focusColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                              textAlign: TextAlign.start,
                                              overflow:
                                              TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4.0,
                                          ),
                                          // Text(
                                          //   // tradePairList[index].baseAsset.toString().toUpperCase(),
                                          //   // "BTC",
                                          //   tradePairListAll[index].data!.instId.toString(),
                                          //   style: CustomWidget(
                                          //       context: context)
                                          //       .CustomSizedTextStyle(
                                          //       12.0,
                                          //       Theme.of(context)
                                          //           .bottomAppBarColor,
                                          //       FontWeight.w400,
                                          //       'FontRegular'),
                                          //   textAlign: TextAlign.start,
                                          // ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                flex: 2,
                              ),
                              Flexible(

                                child: Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          "\$" +coinFutureList[index].last.toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                              14.0,
                                              Theme.of(context).focusColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                          textAlign: TextAlign.start,
                                        ),
                                        Container(
                                          width: 70,

                                          child: Center(
                                            child: Text(
                                              double.parse(coinFutureList[index]
                                                  .change
                                                  .toString())
                                                  .toStringAsFixed(2) +
                                                  " %",
                                              style:
                                              CustomWidget(context: context)
                                                  .CustomSizedTextStyle(
                                                  12,
                                                  Theme.of(context)
                                                      .focusColor,
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(5.0),
                                            color: double.parse(
                                                coinFutureList[index]
                                                    .change
                                                    .toString()) >=
                                                0
                                                ? Theme.of(context)
                                                .indicatorColor
                                                : Theme.of(context).hoverColor,
                                          ),
                                          padding: EdgeInsets.only(top: 7.0,bottom: 7.0),
                                        )
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    )
                                ),
                                flex: 3,
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
              ) :
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: CustomTheme.of(context).primaryColor,
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
            ) :

            // indexVal==3?
            // Container(
            //   margin: EdgeInsets.only(
            //       top: MediaQuery.of(context).size.height * 0.14),
            //   child: fav_list.length > 0 ?
            //       Container(child: Column(children: [
            //         ListView.builder(
            //           itemCount: fav_list.length,
            //           shrinkWrap: true,
            //           controller: controller,
            //           itemBuilder: (BuildContext context, int index) {
            //             // double data =
            //             // double.parse(tradePairList[index].hrExchange.toString());
            //             return Column(
            //               children: [
            //                 InkWell(
            //                   onTap:(){
            //                     showFavbottom(context);
            //                   },
            //                   child: Container(
            //                     padding: EdgeInsets.only(bottom: 10.0),
            //                     child: Row(
            //                       crossAxisAlignment: CrossAxisAlignment.center,
            //                       mainAxisAlignment:
            //                       MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Flexible(
            //                           child: Container(
            //                             child: Row(
            //                               crossAxisAlignment:
            //                               CrossAxisAlignment.center,
            //                               children: [
            //
            //                                 Container(
            //                                   padding: EdgeInsets.all(1.0),
            //                                   decoration: BoxDecoration(
            //                                     shape: BoxShape.circle,
            //                                   ),
            //                                   child: SvgPicture.asset("${fav_list[index]["icon"]}",
            //                                     // "assets/icons/btc.svg",
            //                                     height: 35.0,
            //                                     // color: Theme.of(context).disabledColor,
            //                                   ),
            //                                 ),
            //                                 const SizedBox(
            //                                   width: 10.0,
            //                                 ),
            //                                 Column(
            //                                   crossAxisAlignment:
            //                                   CrossAxisAlignment.start,
            //                                   children: [
            //                                     Container(
            //                                       width: MediaQuery.of(context)
            //                                           .size
            //                                           .width *
            //                                           0.24,
            //                                       child: Text(
            //                                         // name,
            //                                         // "Bitcoin",
            //                                         "${fav_list[index]["name"]}",
            //                                         style: CustomWidget(
            //                                             context: context)
            //                                             .CustomSizedTextStyle(
            //                                             14.0,
            //                                             Theme.of(context)
            //                                                 .focusColor,
            //                                             FontWeight.w500,
            //                                             'FontRegular'),
            //                                         textAlign: TextAlign.start,
            //                                         overflow:
            //                                         TextOverflow.ellipsis,
            //                                       ),
            //                                     ),
            //                                     const SizedBox(
            //                                       height: 4.0,
            //                                     ),
            //                                     Text(
            //                                       // tradePairList[index].baseAsset.toString().toUpperCase(),
            //                                       // "BTC",
            //                                       "${fav_list[index]["unit"]}",
            //                                       style: CustomWidget(
            //                                           context: context)
            //                                           .CustomSizedTextStyle(
            //                                           12.0,
            //                                           Theme.of(context)
            //                                               .focusColor.withOpacity(0.5),
            //                                           FontWeight.w400,
            //                                           'FontRegular'),
            //                                       textAlign: TextAlign.start,
            //                                     ),
            //                                   ],
            //                                 )
            //                               ],
            //                             ),
            //                           ),
            //                           flex: 3,
            //                         ),
            //                         Flexible(
            //
            //                           child: Container(
            //                               child: Row(crossAxisAlignment: CrossAxisAlignment.start,
            //                                 children: [
            //                                   Flexible(flex: 1,child:
            //                                   Container(child: Image.asset("${fav_list[index]["image"]}",),),),
            //
            //                                   Column(children: [
            //                                     Text(
            //                                       "${fav_list[index]["amount"]}",
            //                                       style: CustomWidget(context: context)
            //                                           .CustomSizedTextStyle(
            //                                           14.0,
            //                                           Theme.of(context).focusColor,
            //                                           FontWeight.w400,
            //                                           'FontRegular'),
            //                                       textAlign: TextAlign.start,
            //                                     ),
            //                                     Container(
            //                                       //width: 70,
            //
            //                                       child:Row(children:[
            //                                         Center(
            //                                           child: Text(
            //                                             "${fav_list[index]["percentage"]}",
            //                                             style:
            //                                             CustomWidget(context: context)
            //                                                 .CustomSizedTextStyle(
            //                                                 12,
            //                                                 index%2==0
            //                                                     ? Theme.of(context)
            //                                                     .indicatorColor
            //                                                     : Theme.of(context).hoverColor,
            //                                                 FontWeight.w400,
            //                                                 'FontRegular'),
            //                                             textAlign: TextAlign.center,
            //                                           ),
            //                                         ),
            //                                         Icon( index%2==0 ?Icons.arrow_drop_up:Icons.arrow_drop_down,size: 15,color:index%2==0
            //                                             ? Theme.of(context)
            //                                             .indicatorColor
            //                                             : Theme.of(context).hoverColor ,)
            //                                       ]),
            //
            //
            //                                     ),
            //                                   ],)
            //                                 ],
            //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                               )
            //                           ),
            //                           flex: 3,
            //                         ),
            //
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //                 Container(
            //                   height: 1.5,
            //                   width: MediaQuery.of(context).size.width,
            //                   color: Theme.of(context).canvasColor,
            //                 ),
            //
            //
            //               ],
            //             );
            //           },
            //         ),
            //         SizedBox(
            //           height:MediaQuery.of(context).size.height*0.20,
            //         ),
            //         Container(width: MediaQuery.of(context).size.width*0.80,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Theme.of(context).disabledColor),
            //             child:Padding(padding:EdgeInsets.all(10),child:Text("Add Favorites",style:CustomWidget(context: context)
            //                 .CustomSizedTextStyle(
            //                 16,
            //                 Theme.of(context).primaryColor,
            //                 FontWeight.w600,
            //                 'FontRegular'),
            //               textAlign: TextAlign.center,),)),
            //       ],),):Container()
            //   ):
            // indexVal==4?
            // Container( margin: EdgeInsets.only(
            //     top: MediaQuery.of(context).size.height * 0.14),
            //     child: fav_list.length > 0 ?
            //     Container(child: Column(children: [
            //       const SizedBox(height: 20,),
            //       Align(alignment: Alignment.centerRight,child:Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Theme.of(context).dividerColor),child:Padding(padding: EdgeInsets.all(8),child:
            //       Container(height: 20,width: MediaQuery.of(context).size.width *0.32,child: ListView.builder(scrollDirection: Axis.horizontal,itemCount: times.length,
            //         itemBuilder: (context, index) {
            //           return GestureDetector(child: Container(decoration: BoxDecoration(color: selectedtimeIndex==index?Theme.of(context).disabledColor:Theme.of(context).dividerColor,
            //               borderRadius: BorderRadius.circular(6)),width: MediaQuery.of(context).size.width *0.10,height: 12,child:Center(child:
            //           Text("${times[index]}",style: CustomWidget(context: context)
            //               .CustomSizedTextStyle(
            //               14,
            //               selectedtimeIndex==index?Theme.of(context).primaryColor:Theme.of(context)
            //                   .focusColor.withOpacity(0.6),
            //               FontWeight.w600,
            //               'FontRegular'),
            //             textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,),),),onTap: () {
            //             setState(() {
            //               selectedtimeIndex=index;
            //             });
            //
            //           },);
            //         },),),),),
            //       ),
            //       const SizedBox(height: 20,),
            //       ListView.builder(
            //         itemCount: fav_list.length,
            //         shrinkWrap: true,
            //         controller: controller,
            //         itemBuilder: (BuildContext context, int index) {
            //           // double data =
            //           // double.parse(tradePairList[index].hrExchange.toString());
            //           return Column(
            //             children: [
            //               InkWell(
            //                 onTap:(){
            //                   showFavbottom(context);
            //                 },
            //                 child: Container(
            //                   padding: EdgeInsets.only(bottom: 10.0),
            //                   child: Row(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     mainAxisAlignment:
            //                     MainAxisAlignment.spaceBetween,
            //                     children: [
            //                       Flexible(
            //                         child: Container(
            //                           child: Row(
            //                             crossAxisAlignment:
            //                             CrossAxisAlignment.center,
            //                             children: [
            //
            //                               Container(
            //                                 padding: EdgeInsets.all(1.0),
            //                                 decoration: BoxDecoration(
            //                                   shape: BoxShape.circle,
            //                                 ),
            //                                 child: SvgPicture.asset("${fav_list[index]["icon"]}",
            //                                   // "assets/icons/btc.svg",
            //                                   height: 35.0,
            //                                   // color: Theme.of(context).disabledColor,
            //                                 ),
            //                               ),
            //                               const SizedBox(
            //                                 width: 10.0,
            //                               ),
            //                               Column(
            //                                 crossAxisAlignment:
            //                                 CrossAxisAlignment.start,
            //                                 children: [
            //                                   Container(
            //                                     width: MediaQuery.of(context)
            //                                         .size
            //                                         .width *
            //                                         0.24,
            //                                     child: Text(
            //                                       // name,
            //                                       // "Bitcoin",
            //                                       "${fav_list[index]["name"]}",
            //                                       style: CustomWidget(
            //                                           context: context)
            //                                           .CustomSizedTextStyle(
            //                                           14.0,
            //                                           Theme.of(context)
            //                                               .focusColor,
            //                                           FontWeight.w500,
            //                                           'FontRegular'),
            //                                       textAlign: TextAlign.start,
            //                                       overflow:
            //                                       TextOverflow.ellipsis,
            //                                     ),
            //                                   ),
            //                                   const SizedBox(
            //                                     height: 4.0,
            //                                   ),
            //                                   Text(
            //                                     // tradePairList[index].baseAsset.toString().toUpperCase(),
            //                                     // "BTC",
            //                                     "${fav_list[index]["unit"]}",
            //                                     style: CustomWidget(
            //                                         context: context)
            //                                         .CustomSizedTextStyle(
            //                                         12.0,
            //                                         Theme.of(context)
            //                                             .focusColor.withOpacity(0.5),
            //                                         FontWeight.w400,
            //                                         'FontRegular'),
            //                                     textAlign: TextAlign.start,
            //                                   ),
            //                                 ],
            //                               )
            //                             ],
            //                           ),
            //                         ),
            //                         flex: 3,
            //                       ),
            //                       Flexible(
            //
            //                         child: Container(
            //                             child: Row(crossAxisAlignment: CrossAxisAlignment.start,
            //                               children: [
            //
            //                                 Container(
            //                                   //width: 70,
            //
            //                                   child:Row(children:[
            //                                     Center(
            //                                       child: Text(
            //                                         "${fav_list[index]["percentage"]}",
            //                                         style:
            //                                         CustomWidget(context: context)
            //                                             .CustomSizedTextStyle(
            //                                             12,
            //                                             index%2==0
            //                                                 ? Theme.of(context)
            //                                                 .indicatorColor
            //                                                 : Theme.of(context).hoverColor,
            //                                             FontWeight.w400,
            //                                             'FontRegular'),
            //                                         textAlign: TextAlign.center,
            //                                       ),
            //                                     ),
            //                                     Icon( index%2==0 ?Icons.arrow_drop_up:Icons.arrow_drop_down,size: 15,color:index%2==0
            //                                         ? Theme.of(context)
            //                                         .indicatorColor
            //                                         : Theme.of(context).hoverColor ,)
            //                                   ]),
            //
            //
            //                                 ),
            //
            //                                   Text(
            //                                     "${fav_list[index]["amount"]}",
            //                                     style: CustomWidget(context: context)
            //                                         .CustomSizedTextStyle(
            //                                         14.0,
            //                                         Theme.of(context).focusColor,
            //                                         FontWeight.w400,
            //                                         'FontRegular'),
            //                                     textAlign: TextAlign.start,
            //                                   ),
            //
            //
            //                                 ],   mainAxisAlignment: MainAxisAlignment.spaceBetween,)
            //                         ),
            //                         flex: 3,
            //                       ),
            //
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //               Container(
            //                 height: 1.5,
            //                 width: MediaQuery.of(context).size.width,
            //                 color: Theme.of(context).canvasColor,
            //               ),
            //
            //
            //             ],
            //           );
            //         },
            //       ),
            //
            //
            //     ],),):Container()
            // ):
            Container(
               margin: EdgeInsets.only(
                   top: MediaQuery.of(context).size.height * 0.14),
               child: coinList.length > 0
                   ? ListView.builder(
                       itemCount: coinList.length,
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
                                   MaterialPageRoute(
                                     builder: (context) => MarketTrade_Details(
                                         coinName: coinList[index].name.toString(), coinPrice:coinList[index].last.toString(),
                                         coinDiference: coinList[index].change.toString(), coinhigh24h: coinList[index].high.toString(),
                                       coinlow24l: coinList[index].low.toString(), coinAskP: coinList[index].askP.toString(), coinBitP: coinList[index].bitP.toString()
                                     ),
                                   ),
                                 );
                                 },
                               child: Container(
                                 padding: EdgeInsets.only(bottom: 10.0),
                                 child: Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
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
                                             // Container(
                                             //   padding: EdgeInsets.all(1.0),
                                             //   decoration: BoxDecoration(
                                             //     shape: BoxShape.circle,
                                             //   ),
                                             //   child: Image.network(
                                             //     marketList[index].image.toString(),
                                             //     // "assets/icons/btc.svg",
                                             //     height: 35.0,
                                             //     // color: Theme.of(context).disabledColor,
                                             //   ),
                                             // ),
                                             // const SizedBox(
                                             //   width: 10.0,
                                             // ),
                         //                     Container(child: Image.asset("assets/images/Currency.png",width: 35,height: 35,),),
                         // const SizedBox(
                         //   width: 10.0,
                         // ),
                                             Column(
                                               crossAxisAlignment:
                                               CrossAxisAlignment.start,
                                               children: [
                                                 Container(
                                                   width: MediaQuery.of(context)
                                                       .size
                                                       .width *
                                                       0.24,
                                                   child: Text(
                                                     // name,
                                                     // "Bitcoin",
                                                     coinList[index]
                                                         .name
                                                         .toString(),
                                                     style: CustomWidget(
                                                         context: context)
                                                         .CustomSizedTextStyle(
                                                         14.0,
                                                         Theme.of(context)
                                                             .focusColor,
                                                         FontWeight.w500,
                                                         'FontRegular'),
                                                     textAlign: TextAlign.start,
                                                     overflow:
                                                     TextOverflow.ellipsis,
                                                   ),
                                                 ),
                                                 const SizedBox(
                                                   height: 4.0,
                                                 ),
                                                 Text(
                                                   // tradePairList[index].baseAsset.toString().toUpperCase(),
                                                   // "BTC",
                                                   tradePairListAll[index].data!.instId.toString(),
                                                   style: CustomWidget(
                                                       context: context)
                                                       .CustomSizedTextStyle(
                                                       12.0,
                                                       Theme.of(context)
                                                           .focusColor.withOpacity(0.5),
                                                       FontWeight.w400,
                                                       'FontRegular'),
                                                   textAlign: TextAlign.start,
                                                 ),
                                               ],
                                             )
                                           ],
                                         ),
                                       ),
                                       flex: 2,
                                     ),
                                     Flexible(flex: 1,child:Container(child: double.parse(
                         coinList[index]
                             .change
                             .toString()) >=
                         0
                         ?Image.asset("assets/images/chartgreen.png", ):Image.asset("assets/images/chartred.png", ) ),),
                                     Flexible(

                                       child:Container(

                                                 width:80,
                                                 child:Column(children:[
                                                   Text(
                                                     "\$" +
                                                         double.parse(coinList[index]
                                                             .last
                                                             .toString())
                                                             .toStringAsFixed(4),
                                                     style: CustomWidget(context: context)
                                                         .CustomSizedTextStyle(
                                                         16.0,
                                                         Theme.of(context).focusColor,
                                                         FontWeight.w400,
                                                         'FontRegular'),
                                                     textAlign: TextAlign.start,
                                                     maxLines: 1,
                                                     overflow: TextOverflow.ellipsis,
                                                   ),
                                                   Center(
                                                   child: Text(
                                                     double.parse(coinList[index]
                                                         .change
                                                         .toString())
                                                         .toStringAsFixed(2) +
                                                         " %",
                                                     style:
                                                     CustomWidget(context: context)
                                                         .CustomSizedTextStyle(
                                                         14,
                                                         double.parse(
                                                             coinList[index]
                                                                 .change
                                                                 .toString()) >=
                                                             0
                                                             ? Theme.of(context)
                                                             .indicatorColor
                                                             : Theme.of(context).hoverColor,
                                                         FontWeight.w400,
                                                         'FontRegular'),
                                                     textAlign: TextAlign.center,
                                                     maxLines: 1,
                                                     overflow: TextOverflow.ellipsis,
                                                   ),
                                                 ),
                                                   ]),
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
                     ) :
               Container(
                       height: MediaQuery.of(context).size.height * 0.5,
                       decoration: BoxDecoration(
                         color: CustomTheme.of(context).primaryColor,
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

showFavbottom(BuildContext context){
    return showDialog(useSafeArea: true,context: context, builder: (context) {
      return AlertDialog(contentPadding: EdgeInsets.all(4),elevation: 1,alignment: Alignment.center,content:
      SizedBox(height: MediaQuery.of(context).size.height*0.12,width: MediaQuery.of(context).size.width*0.40,child: Column(children: [
        Padding(padding: EdgeInsets.all(10),child:Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
          Text(
            // name,
            // "Bitcoin",
            "Remove Favorite",
            style: CustomWidget(
                context: context)
                .CustomSizedTextStyle(
                14.0,
                Theme.of(context)
                    .focusColor,
                FontWeight.w500,
                'FontRegular'),
            textAlign: TextAlign.start,
            overflow:
            TextOverflow.ellipsis,
          ),
          Icon(Icons.star_outline_sharp,size: 22,color: Theme.of(context).focusColor.withOpacity(0.5),),
        ],),),
        SizedBox(width: MediaQuery.of(context).size.width,child: Divider(thickness: 2,color: Theme.of(context).focusColor.withOpacity(0.2),indent: 0,endIndent: 0,),),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
          Text(
            // name,
            // "Bitcoin",
            "Set Price Alerts",
            style: CustomWidget(
                context: context)
                .CustomSizedTextStyle(
                14.0,
                Theme.of(context)
                    .focusColor,
                FontWeight.w500,
                'FontRegular'),
            textAlign: TextAlign.start,
            overflow:
            TextOverflow.ellipsis,
          ),
          Icon(Icons.info_outline,size: 22,color: Theme.of(context).disabledColor),
        ],)
      ],),),);
    },);
}

  getCoinList() {
    apiUtils.allCoinList("SPOT" ).then((CoinListModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          tradePairListAll = [];
          tradePairListAll = loginData.result!;
          for (int m = 0; m < tradePairListAll.length; m++) {
            marketList.add(MarketDetailsList(
              name: tradePairListAll[m].data!.instId.toString(),
              last: tradePairListAll[m].data!.last.toString(),
              change: "0.0",
              image: tradePairListAll[m].data!.image.toString(),
            ));
            coinList = marketList;


          }


          for(int m=0;m<10;m++)
            {
              arrData.add("tickers."+tradePairListAll[m].data!.instId.toString());
            }




          loading = false;
          var messageJSON = {
            "op": "subscribe",
            "args": arrData,
          };


          print(messageJSON);
          channelOpenOrder = IOWebSocketChannel.connect(Uri.parse("wss://stream.bybit.com/v5/public/spot"),);
          channelOpenOrder!.sink.add(json.encode(messageJSON));

          socketData();
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

  getFutureCoinList() {
    apiUtils.allCoinList("FUTURES").then((CoinListModel loginData) {
      if (loginData.success!) {
        setState(() {
          tradePairFutureAll = [];
          loading = false;
          tradePairFutureAll = [];
          tradePairFutureAll = loginData.result!;
          for (int m = 0; m < tradePairFutureAll.length; m++) {
            marketFutureList.add(MarketDetailsList(
              name: tradePairFutureAll[m].data!.instId.toString(),
              last: "0.0",
              change: "0.0",
              image: tradePairFutureAll[m].data!.image.toString(),
            ));


          }

          coinFutureList=marketFutureList;

          for(int m=0;m<10;m++)
          {
            arrFutureData.add("tickers."+tradePairFutureAll[m].data!.instId.toString());
          }

          loading = false;
          var futuremessageJSON = {
            "op": "subscribe",
            "args": arrFutureData,
          };


          print(futuremessageJSON);
          channelFutureOpenOrder = IOWebSocketChannel.connect(Uri.parse("wss://stream.bybit.com/v5/public/linear"),);
          channelFutureOpenOrder!.sink.add(json.encode(futuremessageJSON));

          socketFutureData();
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
}

class MarketDetailsList {
  MarketDetailsList({
    this.name,
    this.last,
    this.change,
    this.image,
    this.high,
    this.low,
    this.bitP,
    this.askP,
  });

  dynamic name;
  dynamic last;
  dynamic change;
  dynamic image;
  dynamic high;
  dynamic low;
  dynamic bitP;
  dynamic askP;
}
