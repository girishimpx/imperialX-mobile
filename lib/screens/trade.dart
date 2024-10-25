import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imperial/data/crypt_model/all_wallet_pairs.dart';
import 'package:imperial/data/crypt_model/common_model.dart';
import 'package:imperial/data/crypt_model/future_trade_pair_model.dart';
import 'package:imperial/data/crypt_model/get_pair_details.dart';
import 'package:imperial/data/crypt_model/position_trade_model.dart';
import 'package:imperial/data/crypt_model/trade_his_list_model.dart';
import 'package:imperial/data/crypt_model/trade_pairs_list_model.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

import '../../../common/localization/localizations.dart';
import '../../../common/theme/custom_theme.dart';
import '../common/custom_widget.dart';
import '../data/api_utils.dart';
import '../data/crypt_model/coin_list_model.dart';
import '../data/crypt_model/getfavourites_model.dart' as favmodel;
import '../data/crypt_model/open_order_history_model.dart';
import '../data/crypt_model/trade_balance_model.dart';

class TradeScreen extends StatefulWidget {
   final String selectedcoin;
   final String fromtype;
   TradeScreen({required this.selectedcoin,required this.fromtype,super.key});

  @override
  State<TradeScreen> createState() => _SellTradeScreenState();
}

class _SellTradeScreenState extends State<TradeScreen>
    with TickerProviderStateMixin {
  // String selectedcoin;
  //_SellTradeScreenState(this.selectedcoin);

  List<String> chartTime = ["Limit", "Market",];
  List<String> chartFutureTime = ["Limit", "Market", "Stop-Limit"];
  List<favmodel.Result> favourite_sort=[];
  List<String> tradeType = ["Cross", "Isolated"];
  String selectedTime = "";
  String selectedSymbol = "";
  String selectedFutureTime = "";
  String selectfuturetab="Open Orders";
  int countN=0;

  List<TradePairsSpot> tradePair = [];
  List<TradePairsSpot> tradePairs = [];
  List<TradePairsSpot> searchPair = [];
  TradePairsSpot? selectPair;
  final _formKey = GlobalKey<FormState>();
  List<openOrderList> openOrders = [];
  List<TradeHistoryList> completedOrders = [];
  List<TradeHistoryList> AllopenOrders = [];
  List<MarketDetailsList> marketList = [];
  List<PositionTrade> positionList = [];
  int decimal_val=0;
  int quote_pre=0;
  bool buySell = true;
  String traderType = "";



  late TabController _tabController, tradeTabController,spottabController;
  bool spotOption = true;
  bool selectedfav=false;
  bool marginOption = false;

  bool futureOption = false;
  TextEditingController priceController = TextEditingController();
  TextEditingController tppriceController = TextEditingController();
  TextEditingController slpriceController = TextEditingController();
  TextEditingController stopPriceController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  APIUtils apiUtils = APIUtils();
  bool buyOption = true;
  bool sellOption = true;
  final List<String> _decimal = ["0.00000001", "0.0001", "0.01"];
  int decimalIndex = 8;

  ScrollController controller = ScrollController();
  bool loading = false;
  String pair = "ADAUSDT";

  InAppWebViewController? webViewController;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  TextEditingController searchFutureController = TextEditingController();
  FocusNode searchFutureFocus = FocusNode();
  bool visiblespot=false;
  bool visiblemargin=false;
  bool visiblefuture=false;
  bool enableTrade = false;
  bool enableStopLimit = false;
  bool enableLoan = true;
  bool leverageLoan = true;
  String balance = "0.00";
  String tbalance = "0.00";
  String escrow = "0.00";
  String totalBalance = "0.00";
  String totalAmount = "0.00";
  String price = "0.00";
  String stopPrice = "0.00";
  String tradeAmount = "0.00";
  String takerFee = "0.00";
  String takerFeeValue = "0.00";
  double _currentSliderValue = 0;

  //search function
  List<String> marketAssetList = [
    "USDT",
    "USDC",
    "EUR",
    "BTC",
    "ETH",
    "DAI",
    "BRZ"
  ];
  String selectedMarketAsset = "";
  int selectedmarketindex=-1;
  int indexVal = 0;

  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey();
  int _tLevSliderValue = 0;

  bool favValue = false;

  String tleverageVal = "0";
  IOWebSocketChannel? channelOpenOrder, channelFutureOpenOrder;


  List<BuySellData> buyData = [];
  List<BuySellData> sellData = [];

  String firstCoin = "";
  String FuturefirstCoin = "";
  String secondCoin = "";
  String FuturesecondCoin = "";
  String changePercentage = "0.00";

  String livePrice = "0.00";
  String dlivePrice = "";
  bool tpslCheck = false;
  bool socketLoader = false;
  String selectedDecimal = "";
  String selectedHistoryTradeType = "Cross";
  String futureselectedHistoryTradeType = "Cross";
  List arrData = [];
  List arrData1 = [];
  List arrChangeData = [];
  List arrFutureData = [];
  List arrPriceData = [];
  List arrFuturePriceData = [];

  List<FutureTradePair> futuretradePair = [];
  List<FutureTradePair> futuresearchPair = [];
  FutureTradePair? futureselectPair;
  int count = 0;
  String currentSymbol = "ADAUSDT";
  Timer? timer, timerS;
  bool futurelong = true;

  String minimumbuy="";

  //late final WebViewController webcontroller;
  void _loadWebViewUrl() {
    final urls = "https://app.imperialx.exchange/chart/" +
        (selectPair?.symbol?.toString() ?? "");
    webViewController?.loadUrl(urlRequest: URLRequest(url: Uri.parse(urls)));
  }

  @override
  void dispose() {
    // TODO: implement dispose

    channelOpenOrder!.sink.close();
    channelFutureOpenOrder!.sink.close();
    webViewController!.clearCache();
    timer?.cancel();
    timerS?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spotOption =widget.fromtype=="future"?false:true;
    selectedTime = chartTime.first;
    selectedFutureTime = chartFutureTime.first;
    selectedHistoryTradeType = tradeType.first;
    tradeTabController = TabController(vsync: this, length: 3);
    _tabController = TabController(vsync: this, length: 3);
    spottabController=TabController(length: 2, vsync: this);
    selectedDecimal = _decimal.first;
    loading = true;
    getDetails();
    getFavList();
    loading = true;
    getCoinList(widget.fromtype=="spot"?widget.selectedcoin:"");
    loading = true;
    getFutureCoinList(widget.fromtype=="future"?widget.selectedcoin:"");
    Future.delayed(Duration(seconds: 1));
    getTradePositionHistory();

    channelOpenOrder = IOWebSocketChannel.connect(
      Uri.parse("wss://stream.bybit.com/v5/public/spot"),);
    // channelFutureOpenOrder = IOWebSocketChannel.connect(Uri.parse("wss://stream.bybit.com/v5/public/linear"),);

    selectedMarketAsset = marketAssetList.first;

  }


  socketData() {
    channelOpenOrder!.stream.listen(
          (data) {
        if (data != null || data != "null") {
          var decode = jsonDecode(data);
         print("hihhi $decode");
          if (mounted) {
            setState(() {

              if (decode['type'].toString() == "snapshot") {
                if (spotOption || marginOption) {
                  if (decode["data"][0]["s"].toString() ==
                      selectPair!.symbol.toString()) {
                    livePrice = decode['data'][0]['p'].toString();
                    if(livePrice.isNotEmpty){
                      priceController.text=livePrice;
                    }

                    print("livePrice");
                    print(selectPair!.symbol.toString());
                    print(livePrice);
                  }
                }
                else if (decode["data"][0]["s"].toString() ==
                    futureselectPair!.symbol.toString()) {
                  livePrice = decode['data'][0]['p'].toString();
                  if(livePrice.isNotEmpty){
                    priceController.text=livePrice;
                  }
                  print("Future livePrice");
                  print(futureselectPair!.symbol.toString());
                  print(livePrice);
                }
              } else {
                if (spotOption || marginOption) {
                  if (decode["data"]["s"].toString() ==
                      selectPair!.symbol.toString()) {
                    if (buyData.length > 30) {
                      buyData.removeRange(1, 15);
                      sellData.removeRange(1, 15);
                      // buyData.clear();
                      // sellData.clear();
                      // buyData = [];
                      // sellData = [];
                    }
                    //
                    var list1 = List<dynamic>.from(decode['data']['b']);
                    var list2 = List<dynamic>.from(decode['data']['a']);
                    for (int m = 0; m < list1.length; m++) {
                      if (double.parse(list1[m][1].toString()) > 0) {
                        buyData.add(BuySellData(
                          list1[m][0].toString(),
                          list1[m][1].toString(),
                        ));
                      }
                    }
                    for (int m = 0; m < list2.length; m++) {
                      if (list2[m].toString() != null ||
                          list2[m].toString() != "null") {
                        if (double.parse(list2[m][1].toString()) > 0) {
                          sellData.add(BuySellData(
                            list2[m][0].toString(),
                            list2[m][1].toString(),
                          ));
                        }
                      }
                    }
                  }
                }
                else if (decode["data"]["s"].toString() ==
                    futureselectPair!.symbol.toString()) {
                  if (buyData.length > 30) {
                    buyData.removeRange(1, 15);
                    sellData.removeRange(1, 15);
                    // buyData.clear();
                    // sellData.clear();
                    // buyData = [];
                    // sellData = [];
                  }
                  //
                  var list1 = List<dynamic>.from(decode['data']['b']);
                  var list2 = List<dynamic>.from(decode['data']['a']);
                  for (int m = 0; m < list1.length; m++) {
                    if (double.parse(list1[m][1].toString()) > 0) {
                      buyData.add(BuySellData(
                        list1[m][0].toString(),
                        list1[m][1].toString(),
                      ));
                    }
                  }
                  for (int m = 0; m < list2.length; m++) {
                    if (list2[m].toString() != null ||
                        list2[m].toString() != "null") {
                      if (double.parse(list2[m][1].toString()) > 0) {
                        sellData.add(BuySellData(
                          list2[m][0].toString(),
                          list2[m][1].toString(),
                        ));
                      }
                    }
                  }
                }
              }


            });
          }

          // print("Mano");
        }
      },
      onDone: () async {
        await Future.delayed(Duration(seconds: 10));
        var messageJSON;
        messageJSON = {
          "op": "subscribe",
          "args": arrData
        };
        channelOpenOrder = IOWebSocketChannel.connect(
          Uri.parse("wss://stream.bybit.com/v5/public/spot"),);

        channelOpenOrder!.sink.add(json.encode(messageJSON));
        socketData();
       // socketLivePriceData();
      },
      onError: (error) => print("Err" + error),
    );
  }
  // socketClose(){
  //   if(count<marketList.length)
  //   {
  //     countN=count;
  //     count=count+10;
  //
  //   }
  //   else{
  //     count=0;
  //     timerS!.cancel();
  //   }
  //
  //
  //   // print(count.toString()+"textM"+countN.toString());
  //   arrData1.clear();
  //   arrData1=[];
  //   for(int m=countN;m<count;m++)
  //   {
  //     arrData1.add("tickers."+tradePairs[m].symbol!.toString());
  //   }
  //
  //   //channelOpenOrder!.sink.close();
  //   channelOpenOrder = IOWebSocketChannel.connect(Uri.parse("wss://stream.bybit.com/v5/public/spot"),);
  //
  //   loading = false;
  //   var messageJSON = {
  //     "op": "subscribe",
  //     "args": arrData1,
  //   };
  //   channelsearchOrder!.sink.add(json.encode(messageJSON));
  //
  //   socketLivePriceData();
  // }
  //
  socketLivePriceData() {
    channelOpenOrder!.stream.listen(
          (data) {
        if (data != null || data != "null") {
          var decode = jsonDecode(data);
          print("helolo $decode");

          if (mounted) {
            print("aaale");
            setState(() {
              String last = decode["data"]['lastPrice'].toString();
              if(last.isNotEmpty && last!="") {
                livePrice = last;
              }
              String high24h = decode["data"]['highPrice24h'].toString();
              String low24h = decode["data"]['lowPrice24h'].toString();
              String askPrice = decode["data"]['turnover24h'].toString();
              String bitPrice = decode["data"]['volume24h'].toString();
              double val = double.parse(last.toString().isNotEmpty? last.toString():"0.0") - double.parse(high24h.toString().isNotEmpty? high24h.toString():"0.0");
              double lastChangge = (val / double.parse(high24h.toString().isNotEmpty? high24h.toString(): "0.0")) * 100;
              // if(spotOption||marginOption) {
              //   for (int m = 0; m < searchPair.length; m++) {
              //     if (searchPair[m].symbol.toString().toLowerCase() ==
              //         decode["data"]['symbol'].toString().toLowerCase()) {
              //       print("aaale");
              //       searchPair[m].lastPrice = last;
              //       searchPair[m].lowPrice24H = lastChangge.toString();
              //       //changePercentage = marketList[m].change.toString();
              //     }
              //   }
              // }
              // else{
              //   for (int m = 0; m < futuretradePair.length; m++) {
              //     if (futuretradePair[m].symbol.toString().toLowerCase() ==
              //         decode["data"]['symbol'].toString().toLowerCase()) {
              //       futuretradePair[m].lastPrice = last;
              //       futuretradePair[m].lowPrice24H = lastChangge.toString();
              //       //changePercentage = marketList[m].change.toString();
              //     }
              //   }
              // }
            });
          }
        }
      },
      onDone: () async {
        await Future.delayed(const Duration(seconds: 10));
        var messageChangeJSON = {
          "op": "subscribe",
          "args": arrChangeData,
        };

        channelOpenOrder = IOWebSocketChannel.connect(
          Uri.parse("wss://stream.bybit.com/v5/public/spot"),);

        channelOpenOrder!.sink.add(json.encode(messageChangeJSON));
        socketLivePriceData();
      },
      onError: (error) =>
      {
      },
    );
  }

  // socketFutureData() {
  //   channelFutureOpenOrder!.stream.listen(
  //         (data) {
  //           if (data != null || data != "null") {
  //             var decode = jsonDecode(data);
  //             // print(decode);
  //             if (mounted) {
  //               setState(() {
  //                 if(decode['type'].toString()=="snapshot")
  //                 {
  //                   if (decode["data"][0]["s"].toString() == futureselectPair!.symbol.toString()) {
  //                     livePrice= decode['data'][0]['p'].toString();
  //                     print("livePrice");
  //                     print(futureselectPair!.symbol.toString());
  //                     print(livePrice);
  //                   }
  //
  //                 }else{
  //                   if (decode["data"]["s"].toString() == futureselectPair!.symbol.toString()) {
  //                     if(buyData.length>30)
  //                     {
  //                       buyData.removeRange(1, 15);
  //                       sellData.removeRange(1, 15);
  //                       // buyData.clear();
  //                       // sellData.clear();
  //                       // buyData = [];
  //                       // sellData = [];
  //                     }
  //                     //
  //                     var list1 = List<dynamic>.from(decode['data']['b']);
  //                     var list2 = List<dynamic>.from(decode['data']['a']);
  //                     for (int m = 0; m < list1.length; m++) {
  //                       if (double.parse(list1[m][1].toString()) > 0) {
  //                         buyData.add(BuySellData(
  //                           list1[m][0].toString(),
  //                           list1[m][1].toString(),
  //                         ));
  //
  //                       }
  //                     }
  //                     for (int m = 0; m < list2.length; m++) {
  //                       if (list2[m].toString() != null ||
  //                           list2[m].toString() != "null") {
  //                         if (double.parse(list2[m][1].toString()) > 0) {
  //                           sellData.add(BuySellData(
  //                             list2[m][0].toString(),
  //                             list2[m][1].toString(),
  //                           ));
  //
  //                         }
  //                       }
  //                     }
  //
  //                   }
  //                 }
  //
  //               });
  //             }
  //
  //             // print("Mano");
  //           }
  //     },
  //     onDone: () async {
  //       await Future.delayed(Duration(seconds: 10));
  //       var messageFutureJSON = {
  //         "op": "subscribe",
  //         "args": arrFutureData,
  //       };
  //
  //
  //       channelFutureOpenOrder = IOWebSocketChannel.connect(Uri.parse("wss://stream.bybit.com/v5/public/linear"),);
  //
  //       channelFutureOpenOrder!.sink.add(json.encode(messageFutureJSON));
  //       socketFutureData();
  //     },
  //     onError: (error) => print("Err" + error),
  //   );
  // }


  Widget comingsoon() {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Center(
        child: Text(
          "Coming Soon..!",
          style: CustomWidget(context: context).CustomSizedTextStyle(16.0,
              Theme
                  .of(context)
                  .focusColor, FontWeight.w400, 'FontRegular'),
        ),
      ),
    );
  }
  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _loadWebViewUrl();
      balance="0.0000";
      tbalance="0.000";
      getDetails();
      getFavList();
      if(spotOption || marginOption){
        print("heloooooo");
        getCoinList(selectPair?.symbol?.toString() ?? "");
        getOpenOrderHistory(selectPair!.symbol.toString(), spotOption||marginOption?"spot":"linear");
        getPairDetail(selectPair!.symbol.toString());
        if(buySell){
          getBalance(firstCoin);
          print(firstCoin);
        }
        else{
          getBalance(secondCoin);
          print(secondCoin);
        }
      }
      else{
        getFutureCoinList(futureselectPair?.symbol?.toString() ?? "");
        getBalance("USDT");
        getOpenOrderHistory(futureselectPair!.symbol.toString(), spotOption||marginOption?"spot":"linear");
        getPairDetail(futureselectPair!.symbol.toString());
      }
      Future.delayed(Duration(seconds: 1));
      getTradePositionHistory();


    });
  }
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: CustomTheme
              .of(context)
              .primaryColor,
          appBar:widget.selectedcoin.isNotEmpty?AppBar(backgroundColor: Theme.of(context).cardColor,automaticallyImplyLeading: false,leading:InkWell(child: Icon(Icons.arrow_back_outlined),onTap: () {
            Navigator.pop(context);
          },) ,):AppBar(toolbarHeight: 0,),
          body: RefreshIndicator(onRefresh:_refreshData,child:
    Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            padding: EdgeInsets.all(10.0),
            color: CustomTheme
                .of(context)
                .primaryColor,
            child: Stack(
              children: [
                Container(
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: CustomTheme
                                  .of(context)
                                  .primaryColor,
                            ),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          tpslCheck = false;
                                          spotOption = true;
                                          marginOption = false;
                                          enableStopLimit = false;

                                          futureOption = false;
                                          enableTrade = false;


                                         // livePrice = "0.000";
                                          loading=true;
                                          getCoinList("");
                                        });
                                        setState(() {
                                          buySell = true;
                                          selectPair = tradePair[0];
                                          _currentSliderValue = 0;
                                          totalAmount = "0.0";
                                          openOrders = [];
                                          searchPair=[];

                                          spotOption = true;
                                          marginOption = false;
                                          enableStopLimit = false;

                                          amountController.clear();
                                          stopPriceController.clear();
                                          completedOrders=[];
                                          getTradeHistory(
                                              selectPair!.symbol.toString());
                                          getOpenOrderHistory(selectPair!.symbol.toString(), spotOption||marginOption?"spot":"linear");


                                          futureOption = false;
                                          getBalance(firstCoin);
                                          enableTrade = false;
                                          selectfuturetab="Open Orders";
                                          balance = "0.00";
                                          tbalance="0.00";
                                          //selectedfav=false;
                                          selectedTime = chartTime.first;
                                         // livePrice = "0.000";
                                          getCoinList("");
                                          getPairDetail(selectPair!.symbol.toString());

                                          priceController.text=livePrice;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: spotOption
                                                ? CustomTheme
                                                .of(context)
                                                .canvasColor
                                                : CustomTheme
                                                .of(context)
                                                .primaryColor,
                                            borderRadius:
                                            BorderRadius.circular(8.0)),
                                        child: Center(
                                            child: Padding(
                                              padding: spotOption
                                                  ? EdgeInsets.only(
                                                  top: 10.0, bottom: 10.0)
                                                  : EdgeInsets.only(
                                                  top: 11.0, bottom: 11.0),
                                              child: Text(
                                                AppLocalizations.instance
                                                    .text(
                                                    "loc_sell_trade_txt1"),
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    13.0,
                                                    spotOption
                                                        ? CustomTheme
                                                        .of(context)
                                                        .disabledColor
                                                        : CustomTheme
                                                        .of(context)
                                                        .focusColor
                                                        .withOpacity(0.5),
                                                    FontWeight.w500,
                                                    'FontRegular'),
                                              ),
                                            )),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          tpslCheck = false;
                                          spotOption = false;
                                          marginOption = true;
                                          enableStopLimit = false;

                                          futureOption = false;
                                          enableTrade = false;
                                          selectPair = tradePair[0];
                                          // coinName =
                                          //     selectPair!.coinname1.toString();
                                          // coinTwoName =
                                          //     selectPair!.coinname2.toString();
                                          //
                                         // livePrice = "0.000";
                                          getCoinList("");
                                          //
                                          // firstCoin =
                                          //     selectPair!.coinname1.toString();
                                          // secondCoin =
                                          //     selectPair!.coinname2.toString();
                                        });
                                        setState(() {
                                          buySell = true;
                                          selectPair = tradePair[0];
                                          openOrders = [];
                                          _currentSliderValue = 0;
                                          tleverageVal = "1";
                                          totalAmount = "0.0";
                                          spotOption = false;
                                          marginOption = true;
                                          enableStopLimit = false;
                                          balance = "0.00";
                                          tbalance="0.00";
                                          searchPair=[];
                                          Future.delayed(Duration(seconds: 0));
                                          completedOrders=[];
                                          getTradeHistory(
                                              selectPair!.symbol.toString());
                                          getOpenOrderHistory(selectPair!.symbol.toString(), spotOption||marginOption?"spot":"linear");

                                          futureOption = false;
                                         // priceController.clear();
                                          amountController.clear();
                                          stopPriceController.clear();

                                          enableTrade = false;
                                          selectedTime = chartTime.first;
                                          selectfuturetab="Open Orders";
                                          getBalance(firstCoin);
                                          //livePrice = "0.000";
                                          loading=true;
                                          selectedfav=false;
                                          getCoinList("");
                                          priceController.text=livePrice;
                                          getPairDetail(selectPair!.symbol.toString());
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: marginOption
                                                ? CustomTheme
                                                .of(context)
                                                .canvasColor
                                                : CustomTheme
                                                .of(context)
                                                .primaryColor,
                                            borderRadius:
                                            BorderRadius.circular(8.0)),
                                        child: Center(
                                            child: Padding(
                                              padding: marginOption
                                                  ? EdgeInsets.only(
                                                  top: 10.0, bottom: 10.0)
                                                  : EdgeInsets.only(
                                                  top: 11.0, bottom: 11.0),
                                              child: Text(
                                                AppLocalizations.instance
                                                    .text(
                                                    "loc_sell_trade_txt2"),
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    13.0,
                                                    marginOption
                                                        ? CustomTheme
                                                        .of(context)
                                                        .disabledColor
                                                        : CustomTheme
                                                        .of(context)
                                                        .focusColor
                                                        .withOpacity(0.5),
                                                    FontWeight.w500,
                                                    'FontRegular'),
                                              ),
                                            )),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          tpslCheck = false;
                                          buyData = [];
                                          sellData = [];
                                          buySell = true;
                                          spotOption = false;
                                          marginOption = false;
                                          futureOption = true;
                                          //livePrice = "0.000";
                                          loading=true;
                                          getFutureCoinList("");
                                          enableStopLimit = false;
                                          futureselectPair = futuretradePair[0];


                                          FuturefirstCoin =
                                              futureselectPair!.symbol
                                                  .toString();
                                          FuturesecondCoin =
                                              futureselectPair!.symbol
                                                  .toString();
                                        });
                                        setState(() {
                                          buySell = true;
                                          futureselectPair = futuretradePair[0];
                                          _currentSliderValue = 0;
                                          openOrders = [];
                                          tleverageVal = "1";
                                          spotOption = false;
                                          marginOption = false;
                                          enableStopLimit = false;
                                          priceController.clear();
                                          amountController.clear();
                                          stopPriceController.clear();
                                          completedOrders=[];

                                          getTradeHistory(
                                              futureselectPair!.symbol
                                                  .toString());
                                          getOpenOrderHistory(futureselectPair!.symbol.toString(), spotOption||marginOption?"spot":"linear");
                                          futureOption = true;
                                          selectedfav=false;

                                          //livePrice = "0.000";
                                          getFutureCoinList("");
                                          // getFutureOpenOrder();
                                          enableTrade = false;
                                          selectedFutureTime =
                                              chartFutureTime.first;
                                          totalAmount = "0.0";
                                          loading=true;
                                          selectfuturetab="Open Orders";
                                          getBalance("USDT");
                                          getPairDetail(futureselectPair!.symbol.toString());
                                          priceController.text=livePrice;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: futureOption
                                                ? CustomTheme
                                                .of(context)
                                                .canvasColor
                                                : CustomTheme
                                                .of(context)
                                                .primaryColor,
                                            borderRadius:
                                            BorderRadius.circular(8.0)),
                                        child: Center(
                                            child: Padding(
                                              padding: futureOption
                                                  ? const EdgeInsets.only(
                                                  top: 10.0, bottom: 10.0)
                                                  : const EdgeInsets.only(
                                                  top: 11.0, bottom: 11.0),
                                              child: Text(
                                                AppLocalizations.instance
                                                    .text(
                                                    "loc_sell_trade_txt3"),
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    13.0,
                                                    futureOption
                                                        ? CustomTheme
                                                        .of(context)
                                                        .disabledColor
                                                        : CustomTheme
                                                        .of(context)
                                                        .focusColor
                                                        .withOpacity(0.5),
                                                    FontWeight.w500,
                                                    'FontRegular'),
                                              ),
                                            )),
                                      ),
                                    ),
                                  ),
                                ]),
                          ),

                          const SizedBox(
                            height: 10.0,
                          ),
                          // Container(
                          //     width: MediaQuery.of(context).size.width,
                          //     height: MediaQuery.of(context).size.height * 0.4,
                          //     child: InAppWebView(
                          //       initialUrlRequest: URLRequest(
                          //           url: Uri.parse(
                          //               "https://app.imperialx.exchange/chart/"+pair)),
                          //       onWebViewCreated: (controller){
                          //         webViewController = controller;
                          //       },
                          //       onReceivedServerTrustAuthRequest: (controller, challenge) async {
                          //         print(challenge);
                          //         return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
                          //       },
                          //     )
                          //     // child: WebViewWidget(controller: webcontroller),
                          //     ),
                          // const SizedBox(
                          //   height: 10.0,
                          // ),
                          spotOption
                              ? spotUI()
                              : marginOption
                              ? spotUI()
                              : futureOption
                              ? futureUI()
                              : comingsoon(),

                          //orderWidget()
                        ],
                      ),
                    )),
                loading
                    ? CustomWidget(context: context)
                    .loadingIndicator(CustomTheme
                    .of(context)
                    .disabledColor)
                    : SizedBox(height: 0, width: 0)
              ],
            ),
          ),
        )));
  }

  Widget spotUI() {
    return SingleChildScrollView(
      child: Column(
        children: [
          //const SizedBox(height: 10.0),
          // TextField(readOnly: true,
          //   controller: searchController,
          //   focusNode: searchFocus,
          //   enabled: true,
          //   textInputAction: TextInputAction.none,
          //   onTap: () {
          //     setState(() {
          //       showSheeet();
          //
          //     });
          //   },
          //   onEditingComplete: () {
          //     // setState(() {
          //     //   //searchPair=[];
          //     //   searchFocus.unfocus();
          //     // });
          //   },
          //   onChanged: (value) {
          //   },
          //   decoration: InputDecoration(
          //     contentPadding: const EdgeInsets.only(
          //         left: 12, right: 0, top: 8, bottom: 8),
          //     hintText: "Search",
          //     hintStyle: TextStyle(
          //         fontFamily: "FontRegular",
          //         color: Theme
          //             .of(context)
          //             .focusColor,
          //         fontSize: 14.0,
          //         fontWeight: FontWeight.w400),
          //     filled: true,
          //     fillColor: CustomTheme
          //         .of(context)
          //         .primaryColorLight
          //         .withOpacity(0.5),
          //     border: OutlineInputBorder(
          //       borderRadius:
          //       BorderRadius.all(Radius.circular(5.0)),
          //       borderSide: BorderSide(
          //           color: CustomTheme
          //               .of(context)
          //               .focusColor
          //               .withOpacity(0.5),
          //           width: 1.0),
          //     ),
          //     disabledBorder: OutlineInputBorder(
          //       borderRadius:
          //       BorderRadius.all(Radius.circular(5.0)),
          //       borderSide: BorderSide(
          //           color: CustomTheme
          //               .of(context)
          //               .focusColor
          //               .withOpacity(0.5),
          //           width: 1.0),
          //     ),
          //     enabledBorder: OutlineInputBorder(
          //       borderRadius:
          //       BorderRadius.all(Radius.circular(5.0)),
          //       borderSide: BorderSide(
          //           color: CustomTheme
          //               .of(context)
          //               .focusColor
          //               .withOpacity(0.5),
          //           width: 1.0),
          //     ),
          //     focusedBorder: OutlineInputBorder(
          //       borderRadius:
          //       BorderRadius.all(Radius.circular(5.0)),
          //       borderSide: BorderSide(
          //           color: CustomTheme
          //               .of(context)
          //               .focusColor
          //               .withOpacity(0.5),
          //           width: 1.0),
          //     ),
          //     errorBorder: const OutlineInputBorder(
          //       borderRadius:
          //       BorderRadius.all(Radius.circular(5)),
          //       borderSide:
          //       BorderSide(color: Colors.red, width: 0.0),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 10.0),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     InkWell(
          //       onTap: () {
          //         setState(() {
          //          // searchPair=[];
          //         });
          //         showSheeet();
          //       },
          //       child: Row(
          //         children: [
          //           Container(
          //             margin: const EdgeInsets.only(right: 5.0),
          //             child: Icon(
          //               Icons.menu_rounded,
          //               size: 25.0,
          //               color: Theme
          //                   .of(context)
          //                   .focusColor,
          //             ),
          //           ),
          //           tradePair.isNotEmpty
          //               ? Text(
          //             selectPair?.symbol ?? "BTCUSTD",
          //             style: CustomWidget(context: context)
          //                 .CustomSizedTextStyle(
          //               14.0,
          //               Theme
          //                   .of(context)
          //                   .focusColor,
          //               FontWeight.w500,
          //               'FontRegular',
          //             ),
          //           )
          //               : Container(),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 10.0),

          SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: GestureDetector(
              onTap: () {
    setState(() {
    // searchPair=[];
    //showSheeet();
      if(spotOption){
        visiblespot=!visiblespot;
      }
      else if(marginOption){
        visiblemargin=!visiblemargin;
      }
      else{
        visiblespot=false;
        visiblemargin=false;
      }
    });
    }, child:Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                GestureDetector(child:Icon(Icons.menu,size: 30,),onTap: () {
                  setState(() {
                    showSheeet();
                  });
                },),
                const SizedBox(width: 5.0),
                Flexible(flex: 2,child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          selectPair?.symbol ?? "BTCUSTD",
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                            16.0,
                            Theme
                                .of(context)
                                .focusColor,
                            FontWeight.w500,
                            'FontRegular',
                          ),
                        ),

                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          livePrice,
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                            16.0,
                            Theme
                                .of(context)
                                .focusColor,
                            FontWeight.w500,
                            'FontRegular',
                          ),
                        ),

                      ],
                    ),
                  ],
                ),),
                Flexible(flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        "assets/menu/graph.png",

                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.10,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.28,
                      ),
                      Container(child: spotOption?visiblespot?uparrow():downarrow():marginOption?visiblemargin?uparrow():downarrow():downarrow(),),
                    ],
                  ),
                ),
              ],
            ),),
          ),
          //const SizedBox(height: 10.0),
        // GestureDetector(onTap: () {
        //   setState(() {
        //     loading=true;
        //     addFavourite("true",selectedSymbol);
        //   });
        // },child:Align(alignment: Alignment.centerRight,child: Container(padding: EdgeInsets.all(8),child: Text("Add to Favourites",
        //     style: CustomWidget(context: context)
        //         .CustomSizedTextStyle(
        //       8.0,
        //       Theme
        //           .of(context)
        //           .focusColor,
        //       FontWeight.w500,
        //       'FontRegular',),),
        //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: Theme.of(context).indicatorColor),),),),
        //   const SizedBox(height: 10.0),
          //const SizedBox(height: 10.0),
          Visibility(visible: spotOption?visiblespot:marginOption?visiblemargin:false,child:Column(children: [
            Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.4,
            child: InAppWebView(

              initialUrlRequest: URLRequest(
                url: Uri.parse(
                  "https://app.imperialx.exchange/chart/${selectPair?.symbol.toString()??"BTCUSTD"}",
                ),
              ),
              // initialOptions: InAppWebViewGroupOptions(
              //   crossPlatform: InAppWebViewOptions(
              //     javaScriptEnabled: true,
              //     useOnDownloadStart: true,
              //     mediaPlaybackRequiresUserGesture: false,  // Allows automatic media playback
              //   ),),
              //   onWebViewCreated: (controller){
              //     webViewController = controller;
              //   },
              //   onReceivedServerTrustAuthRequest: (controller, challenge) async {
              //     print(challenge);
              //     return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
              //   },
              onWebViewCreated: (controller) {
                print("hihihi${"https://app.imperialx.exchange/chart/${selectPair?.symbol.toString()??"BTCUSTD"}"}");
                webViewController = controller;
              },
              onReceivedServerTrustAuthRequest: (controller, challenge) async {
                print(challenge);
                return ServerTrustAuthResponse(
                    action: ServerTrustAuthResponseAction.PROCEED);
              },
            ),
          ),
      const SizedBox(height: 10.0),
    ],)),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: OrderWidget(),
                flex: 1,
              ),
              const SizedBox(width: 10.0),
              Flexible(
                child: marketWidget(),
                flex: 1,
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Container(child:Row(children: [
            GestureDetector(child:Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
              Text(
                "Open Orders ( " + (openOrders.length.toString()) + " )",
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    13.0,
                    selectfuturetab=="Open Orders"?Theme.of(context).indicatorColor:Theme
                        .of(context)
                        .focusColor
                        .withOpacity(0.5),
                    FontWeight.w400,
                    'FontRegular'),
                textAlign: TextAlign.center,
              ),
              SizedBox(width: MediaQuery.of(context).size.width*0.30,child:Divider(height: 8,color:
              selectfuturetab=="Open Orders"?Theme.of(context).indicatorColor:Theme
                  .of(context)
                  .focusColor
                  .withOpacity(0.2)
                ,thickness: 4,indent: 0,endIndent: 1,),),
            ],),onTap: () {
              setState(() {
                selectfuturetab="Open Orders";
                loading=true;
                getTradeHistory(spotOption || marginOption
                    ? selectPair!.symbol.toString()
                    : futureselectPair!.symbol.toString(),);
                getOpenOrderHistory(spotOption || marginOption
                    ? selectPair!.symbol.toString()
                    : futureselectPair!.symbol.toString(), spotOption||marginOption?"spot":"linear");

                Future.delayed(Duration(seconds: 1));
                spottabController.animateTo(0);
                showOrders();
                selectfuturetab="Open Orders";
              });
            },),
            const SizedBox(width: 10,),
            GestureDetector(child:Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
              Text(
                "Open History",
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    13.0,
                    selectfuturetab=="Open History"?Theme.of(context).indicatorColor:Theme
                        .of(context)
                        .focusColor
                        .withOpacity(0.5),
                    FontWeight.w400,
                    'FontRegular'),
                textAlign: TextAlign.center,
              ),
              SizedBox(width: MediaQuery.of(context).size.width*0.30,child:Divider(height: 8,color:
              selectfuturetab=="Open History"?Theme.of(context).indicatorColor:Theme
                  .of(context)
                  .focusColor
                  .withOpacity(0.2)
                ,thickness: 4,indent: 0,endIndent: 1,),),
            ],),onTap: () {
              setState(() {
                selectfuturetab="Open History";
                loading=true;
                getTradeHistory(spotOption || marginOption
                    ? selectPair!.symbol.toString()
                    : futureselectPair!.symbol.toString(),);
                getOpenOrderHistory(spotOption || marginOption
                    ? selectPair!.symbol.toString()
                    : futureselectPair!.symbol.toString(), spotOption||marginOption?"spot":"linear");
                Future.delayed(Duration(seconds: 1));
                spottabController.animateTo(1);
                showOrders();
                selectfuturetab="Open Orders";
              });
            },),
          ],) ,),
          // InkWell(
          //   onTap: () {
          //     print("ello");
          //     setState(() {
          //
          //       // completedOrders=[];
          //       loading=true;
          //       getTradeHistory(spotOption || marginOption
          //           ? selectPair!.symbol.toString()
          //           : futureselectPair!.symbol.toString(),);
          //       Future.delayed(Duration(seconds: 1));
          //       showOrders();
          //     });
          //
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 0.0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           "Open Orders (${openOrders.length})",
          //           style: CustomWidget(context: context).CustomTextStyle(
          //             Theme
          //                 .of(context)
          //                 .focusColor
          //                 .withOpacity(0.5),
          //             FontWeight.w400,
          //             'FontRegular',
          //           ),
          //           textAlign: TextAlign.center,
          //         ),
          //         Row(
          //           children: [
          //             Text(
          //               "Show all",
          //               style: CustomWidget(context: context)
          //                   .CustomSizedTextStyle(
          //                 12.0,
          //                 Theme
          //                     .of(context)
          //                     .focusColor
          //                     .withOpacity(0.5),
          //                 FontWeight.w500,
          //                 'FontRegular',
          //               ),
          //               textAlign: TextAlign.center,
          //             ),
          //             Icon(
          //               Icons.arrow_forward_ios_outlined,
          //               color: Theme
          //                   .of(context)
          //                   .focusColor
          //                   .withOpacity(0.5),
          //               size: 10.0,
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          const SizedBox(height: 10.0),
          openOrdersUIS(),
        ],
      ),
    );
  }
  getFavList() {
    apiUtils.getFavouriteslist().then((favmodel.GetFavouritesModel loginData) {
      if (loginData.success==true) {
        setState(() {
          //loading = false;
          // if (loginData.result != null) {
          favourite_sort=[];
          //var result=loginData.result!;
          favourite_sort = loginData.result!;
          print("hihi${favourite_sort.length}");
          //}
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

  Widget uparrow(){
    return Icon(Icons.keyboard_arrow_up_rounded,
    size: 30,
    color: Theme
        .of(context)
    .focusColor);
  }
  Widget downarrow(){
    return Icon(Icons.keyboard_arrow_down_rounded,
        size: 30,
        color: Theme
            .of(context)
            .focusColor);
  }


  Widget futureUI() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // const SizedBox(
          //   height: 10.0,
          // ),
          // TextField(
          //   readOnly: true,
          //   controller:searchFutureController,
          //   focusNode: searchFutureFocus,
          //   enabled: true,
          //   textInputAction: TextInputAction.none,
          //   onTap: () {
          //     setState(() {
          //       showFutureSheeet();
          //     });
          //   },
          //   onEditingComplete: () {
          //     // setState(() {
          //     //   //searchPair=[];
          //     //   searchFocus.unfocus();
          //     // });
          //   },
          //   onChanged: (value) {
          //   },
          //   decoration: InputDecoration(
          //     contentPadding: const EdgeInsets.only(
          //         left: 12, right: 0, top: 8, bottom: 8),
          //     hintText: "Search",
          //     hintStyle: TextStyle(
          //         fontFamily: "FontRegular",
          //         color: Theme
          //             .of(context)
          //             .focusColor,
          //         fontSize: 14.0,
          //         fontWeight: FontWeight.w400),
          //     filled: true,
          //     fillColor: CustomTheme
          //         .of(context)
          //         .primaryColorLight
          //         .withOpacity(0.5),
          //     border: OutlineInputBorder(
          //       borderRadius:
          //       BorderRadius.all(Radius.circular(5.0)),
          //       borderSide: BorderSide(
          //           color: CustomTheme
          //               .of(context)
          //               .focusColor
          //               .withOpacity(0.5),
          //           width: 1.0),
          //     ),
          //     disabledBorder: OutlineInputBorder(
          //       borderRadius:
          //       BorderRadius.all(Radius.circular(5.0)),
          //       borderSide: BorderSide(
          //           color: CustomTheme
          //               .of(context)
          //               .focusColor
          //               .withOpacity(0.5),
          //           width: 1.0),
          //     ),
          //     enabledBorder: OutlineInputBorder(
          //       borderRadius:
          //       BorderRadius.all(Radius.circular(5.0)),
          //       borderSide: BorderSide(
          //           color: CustomTheme
          //               .of(context)
          //               .focusColor
          //               .withOpacity(0.5),
          //           width: 1.0),
          //     ),
          //     focusedBorder: OutlineInputBorder(
          //       borderRadius:
          //       BorderRadius.all(Radius.circular(5.0)),
          //       borderSide: BorderSide(
          //           color: CustomTheme
          //               .of(context)
          //               .focusColor
          //               .withOpacity(0.5),
          //           width: 1.0),
          //     ),
          //     errorBorder: const OutlineInputBorder(
          //       borderRadius:
          //       BorderRadius.all(Radius.circular(5)),
          //       borderSide:
          //       BorderSide(color: Colors.red, width: 0.0),
          //     ),
          //   ),
          // ),
          // // const SizedBox(height: 10.0),
          // // Row(
          // //     crossAxisAlignment: CrossAxisAlignment.center,
          // //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // //     children: [
          // //       InkWell(
          // //         onTap: () {
          // //           setState(() {
          // //             getFutureCoinList();
          // //             showFutureSheeet();
          // //           });
          // //         },
          // //         child: Row(
          // //           children: [
          // //             Container(
          // //               margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
          // //               padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          // //               child: InkWell(
          // //                 child: Icon(
          // //                   Icons.menu_rounded,
          // //                   size: 20.0,
          // //                   color: Theme
          // //                       .of(context)
          // //                       .focusColor,
          // //                 ),
          // //               ),
          // //             ),
          // //             // futuretradePair.length > 0 ?
          // //             Text(
          // //               futureselectPair?.symbol.toString() ?? "",
          // //               style: CustomWidget(context: context)
          // //                   .CustomSizedTextStyle(
          // //                   12.0,
          // //                   Theme
          // //                       .of(context)
          // //                       .focusColor,
          // //                   FontWeight.w500,
          // //                   'FontRegular'),
          // //             )
          // //             // : Container(),
          // //           ],
          // //         ),
          // //       ),
          // //     ]),
          // const SizedBox(height: 10,),
          Container(width: MediaQuery
              .of(context)
              .size
              .width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start, children: [
              //Flexible(flex: 1,child:Image.asset("assets/images/blogo.png",height: MediaQuery.of(context).size.height*0.06,width: MediaQuery.of(context).size.height*0.06), ),
              GestureDetector(child:Icon(Icons.menu,size: 30,),onTap: () {
                setState(() {
                  showFutureSheeet();
                });
              },),
              const SizedBox(width: 5,),
              Flexible(flex: 3, child: Column(children: [
                Row(children: [
                  Flexible(child:Text(
                    "${futureselectPair?.symbol.toString() ?? ""}",
                    style: CustomWidget(context: context)
                        .CustomSizedTextStyle(
                        14.0,
                        Theme
                            .of(context)
                            .focusColor,
                        FontWeight.w500,
                        'FontRegular'),softWrap: true,
                  ),),
                  // GestureDetector(child: selectedfav?Icon(Icons.star,color: Colors.orangeAccent,size: 30,):Icon(Icons.star_outline_sharp,color: Colors.orangeAccent,size: 30,),onTap: () {
                  //   setState(() {
                  //     selectedfav=!selectedfav;
                  //     loading=true;
                  //     addFutureFavourite(selectedfav.toString(), futureselectPair!.symbol.toString()??"");
                  //   });
                  // },)
                  // Text(
                  //   "Bitcoin",
                  //   style: CustomWidget(context: context)
                  //       .CustomSizedTextStyle(
                  //       12.0,
                  //       Theme.of(context).focusColor.withOpacity(0.5),
                  //       FontWeight.w500,
                  //       'FontRegular'),
                  // ),
                ],),
                Row(children: [
                  Text(
                    "${futureselectPair?.lastPrice.toString() ?? ""}",
                    style: CustomWidget(context: context)
                        .CustomSizedTextStyle(
                        16.0,
                        Theme
                            .of(context)
                            .focusColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                  // Text(
                  //   "USD",
                  //   style: CustomWidget(context: context)
                  //       .CustomSizedTextStyle(
                  //       12.0,
                  //       Theme.of(context).focusColor.withOpacity(0.5),
                  //       FontWeight.w500,
                  //       'FontRegular'),
                  // ),
                  // Row(children: [
                  //   Icon(Icons.arrow_drop_up,size: 8,color: Theme.of(context).disabledColor,),
                  //   Text(
                  //     "USD",
                  //     style: CustomWidget(context: context)
                  //         .CustomSizedTextStyle(
                  //         12.0,
                  //         Theme.of(context).disabledColor,
                  //         FontWeight.w500,
                  //         'FontRegular'),
                  //   ),
                  // ],)

                ],),
              ],)),
              Flexible(flex: 3,
                  child: GestureDetector(child:Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset("assets/menu/graph.png", height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.08, width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.28),
                      visiblefuture?Icon(Icons.keyboard_arrow_up_rounded,size: 30,color: Theme.of(context).focusColor,):Icon(Icons.keyboard_arrow_down_rounded,size: 30,color: Theme.of(context).focusColor,)
                    ],),onTap: () {
                      setState(() {
                        visiblefuture=!visiblefuture;
                      });
                    },),),
            ],),),
          const SizedBox(
            height: 10.0,
          ),
          // GestureDetector(onTap: () {
          //   setState(() {
          //     loading=true;
          //     addFavourite("true",futureselectPair!.symbol.toString());
          //   });
          // },child:Align(alignment: Alignment.centerRight,child: Container(padding: EdgeInsets.all(8),child: Text("Add to Favourites",
          //   style: CustomWidget(context: context)
          //       .CustomSizedTextStyle(
          //     8.0,
          //     Theme
          //         .of(context)
          //         .focusColor,
          //     FontWeight.w500,
          //     'FontRegular',),),
          //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: Theme.of(context).indicatorColor),),),),
          // const SizedBox(height: 10.0),
          Visibility(visible: visiblefuture,child:Column(children: [
          Image.asset("assets/images/newchart.png", height: MediaQuery
              .of(context)
              .size
              .height * 0.40, width: MediaQuery
              .of(context)
              .size
              .width,),
            const SizedBox(
              height: 10.0,
            ),
          ],)),

          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: FutureOrderWidget(),
                  flex: 1,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Flexible(
                  child: marketWidget(),
                  flex: 1,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 35.0,
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    width: 1.0,
                    color: CustomTheme
                        .of(context)
                        .focusColor
                        .withOpacity(0.5),
                  ),
                  // color: CustomTheme.of(context).disabledColor,
                ),
                child: Center(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: CustomTheme
                          .of(context)
                          .canvasColor,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        items: _decimal
                            .map((value) =>
                            DropdownMenuItem(
                              child: Text(
                                value,
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    Theme
                                        .of(context)
                                        .focusColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                              value: value,
                            ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDecimal = value.toString();
                            for (int m = 0; m < _decimal.length; m++) {
                              if (value == _decimal[m]) {
                                if (m == 0) {
                                  decimalIndex = 8;
                                } else if (m == 1) {
                                  decimalIndex = 4;
                                } else {
                                  decimalIndex = 2;
                                }
                              }
                            }
                          });
                        },
                        isExpanded: false,
                        value: selectedDecimal,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: CustomTheme
                              .of(context)
                              .focusColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              InkWell(
                onTap: () {
                  showSuccessAlertDialog();
                },
                child: Container(
                  padding: EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    // color: CustomTheme.of(context).disabledColor,
                  ),
                  child: Icon(
                    Icons.settings,
                    color: Theme
                        .of(context)
                        .disabledColor,
                    size: 20.0,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Live Price",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme
                            .of(context)
                            .focusColor,
                        FontWeight.bold,
                        'FontRegular'),
                  ),
                  Text(
                    livePrice,
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        11.5,
                        Theme
                            .of(context)
                            .focusColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Available",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme
                            .of(context)
                            .focusColor
                            .withOpacity(0.5),
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                  Text(
                    balance,
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        11.5,
                        Theme
                            .of(context)
                            .focusColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Available",
              //       style: CustomWidget(context: context).CustomSizedTextStyle(
              //           12.0,
              //           Theme
              //               .of(context)
              //               .focusColor
              //               .withOpacity(0.5),
              //           FontWeight.w500,
              //           'FontRegular'),
              //     ),
              //     Text(
              //       tbalance,
              //       style: CustomWidget(context: context).CustomSizedTextStyle(
              //           11.5,
              //           Theme
              //               .of(context)
              //               .focusColor,
              //           FontWeight.w500,
              //           'FontRegular'),
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: 5.0,
              // ),

              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Maxbuy",
              //       style: CustomWidget(context: context).CustomSizedTextStyle(
              //           12.0,
              //           Theme
              //               .of(context)
              //               .focusColor
              //               .withOpacity(0.5),
              //           FontWeight.w500,
              //           'FontRegular'),
              //     ),
              //     priceController.text.isNotEmpty?Text(
              //       (((double.parse(balance) * 100) /
              //           double.parse(priceController.text)) /
              //           100).toStringAsFixed(4),
              //       style: CustomWidget(context: context).CustomSizedTextStyle(
              //           11.5,
              //           Theme
              //               .of(context)
              //               .focusColor,
              //           FontWeight.w500,
              //           'FontRegular'),
              //     ):Text(""),
              //   ],
              // ),
              // SizedBox(
              //   height: 5.0,
              // ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Minbuy Qty",
              //       style: CustomWidget(context: context).CustomSizedTextStyle(
              //           12.0,
              //           Theme
              //               .of(context)
              //               .focusColor
              //               .withOpacity(0.5),
              //           FontWeight.w500,
              //           'FontRegular'),
              //     ),
              //     Text(
              //       minimumbuy,
              //       style: CustomWidget(context: context).CustomSizedTextStyle(
              //           11.5,
              //           Theme
              //               .of(context)
              //               .focusColor,
              //           FontWeight.w500,
              //           'FontRegular'),
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: 5.0,
              // ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Live Price",
              //       style: CustomWidget(context: context).CustomSizedTextStyle(
              //           12.0,
              //           Theme.of(context).focusColor,
              //           FontWeight.bold,
              //           'FontRegular'),
              //     ),
              //     Text(
              //       livePrice ,
              //       style: CustomWidget(context: context).CustomSizedTextStyle(
              //           11.5,
              //           Theme.of(context).focusColor,
              //           FontWeight.w500,
              //           'FontRegular'),
              //     ),
              //   ],
              // ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Frozen amount",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme
                            .of(context)
                            .focusColor
                            .withOpacity(0.5),
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                  Text(
                    escrow,
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        11.5,
                        Theme
                            .of(context)
                            .focusColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Asset",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme
                            .of(context)
                            .focusColor
                            .withOpacity(0.5),
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                  Text(
                    totalBalance,
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        11.5,
                        Theme
                            .of(context)
                            .focusColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Container(child:Row(children: [
            GestureDetector(child:Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
              Text(
                "Open Orders ( " + (openOrders.length.toString()) + " )",
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    13.0,
                    selectfuturetab=="Open Orders"?Theme.of(context).indicatorColor:Theme
                        .of(context)
                        .focusColor
                        .withOpacity(0.5),
                    FontWeight.w400,
                    'FontRegular'),
                textAlign: TextAlign.center,
              ),
              SizedBox(width: MediaQuery.of(context).size.width*0.30,child:Divider(height: 8,color:
              selectfuturetab=="Open Orders"?Theme.of(context).indicatorColor:Theme
                  .of(context)
                  .focusColor
                  .withOpacity(0.2)
                ,thickness: 4,indent: 0,endIndent: 1,),),
            ],),onTap: () {
              setState(() {
                selectfuturetab="Open Orders";
                loading=true;
                      getTradeHistory(spotOption || marginOption
                          ? selectPair!.symbol.toString()
                          : futureselectPair!.symbol.toString(),);
                getOpenOrderHistory(spotOption || marginOption
                    ? selectPair!.symbol.toString()
                    : futureselectPair!.symbol.toString(), spotOption||marginOption?"spot":"linear");
                      Future.delayed(Duration(seconds: 1));
                      _tabController.animateTo(0);
                showFutureOrders();
                selectfuturetab="Open Orders";
              });
            },),
            const SizedBox(width: 10,),
            GestureDetector(child:Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
              Text(
                "Open History",
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    13.0,
                    selectfuturetab=="Open History"?Theme.of(context).indicatorColor:Theme
                        .of(context)
                        .focusColor
                        .withOpacity(0.5),
                    FontWeight.w400,
                    'FontRegular'),
                textAlign: TextAlign.center,
              ),
              SizedBox(width: MediaQuery.of(context).size.width*0.30,child:Divider(height: 8,color:
              selectfuturetab=="Open History"?Theme.of(context).indicatorColor:Theme
                  .of(context)
                  .focusColor
                  .withOpacity(0.2)
                ,thickness: 4,indent: 0,endIndent: 1,),),
            ],),onTap: () {
              setState(() {
                selectfuturetab="Open History";
                loading=true;
                      getTradeHistory(spotOption || marginOption
                          ? selectPair!.symbol.toString()
                          : futureselectPair!.symbol.toString(),);
                getOpenOrderHistory(spotOption || marginOption
                    ? selectPair!.symbol.toString()
                    : futureselectPair!.symbol.toString(), spotOption||marginOption?"spot":"linear");
                      Future.delayed(Duration(seconds: 1));
                _tabController.animateTo(1);
                showFutureOrders();
                selectfuturetab="Open Orders";
              });
            },),
            const SizedBox(width: 10,),
            GestureDetector(child:Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
              Text(
                "Position",
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    13.0,
                    selectfuturetab=="Position"?Theme.of(context).indicatorColor:Theme
                        .of(context)
                        .focusColor
                        .withOpacity(0.5),
                    FontWeight.w400,
                    'FontRegular'),
                textAlign: TextAlign.center,
              ),
              SizedBox(width: MediaQuery.of(context).size.width*0.20,child:Divider(height: 8,color:
              selectfuturetab=="Position"?Theme.of(context).indicatorColor:Theme
                  .of(context)
                  .focusColor
                  .withOpacity(0.2)
                ,thickness: 4,indent: 0,endIndent: 1,),),
            ],),onTap: () {
              setState(() {
                selectfuturetab="Position";
                loading=true;
                      getTradeHistory(spotOption || marginOption
                          ? selectPair!.symbol.toString()
                          : futureselectPair!.symbol.toString(),);
                getOpenOrderHistory(spotOption || marginOption
                    ? selectPair!.symbol.toString()
                    : futureselectPair!.symbol.toString(), spotOption||marginOption?"spot":"linear");
                getTradePositionHistory();
                      Future.delayed(Duration(seconds: 1));
                _tabController.animateTo(2);
                showFutureOrders();
                selectfuturetab="Open Orders";
              });
            },),
          ],) ,),
          const SizedBox(height: 20,),
          // InkWell(
          //   onTap: () {
          //     setState(() {
          //
          //       // completedOrders=[];
          //       loading=true;
          //       getTradeHistory(spotOption || marginOption
          //           ? selectPair!.symbol.toString()
          //           : futureselectPair!.symbol.toString(),);
          //       Future.delayed(Duration(seconds: 1));
          //       showOrders();
          //     });
          //     //futureOption ? showFutureOrders() : showOrders();
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.only(left: 0.0, right: 0.0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           "Open Orders ( " + (openOrders.length.toString()) + " )",
          //           style: CustomWidget(context: context).CustomSizedTextStyle(
          //               13.0,
          //               Theme
          //                   .of(context)
          //                   .focusColor
          //                   .withOpacity(0.5),
          //               FontWeight.w400,
          //               'FontRegular'),
          //           textAlign: TextAlign.center,
          //         ),
          //         Row(
          //           children: [
          //             Text(
          //               "Show all",
          //               style: CustomWidget(context: context)
          //                   .CustomSizedTextStyle(
          //                   12.0,
          //                   Theme
          //                       .of(context)
          //                       .focusColor
          //                       .withOpacity(0.5),
          //                   FontWeight.w500,
          //                   'FontRegular'),
          //               textAlign: TextAlign.center,
          //             ),
          //             Icon(
          //               Icons.arrow_forward_ios_outlined,
          //               color: Theme
          //                   .of(context)
          //                   .focusColor
          //                   .withOpacity(0.5),
          //               size: 10.0,
          //             )
          //           ],
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 10.0,
          // ),
          openOrdersUIS(),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  Widget marketWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                spotOption || marginOption ? (AppLocalizations.instance.text(
                    "loc_sell_trade_price") +
                    "\n(" +
                    secondCoin +
                    ")") : AppLocalizations.instance.text(
                    "loc_sell_trade_price"),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    12.0,
                    Theme
                        .of(context)
                        .focusColor
                        .withOpacity(0.5),
                    FontWeight.w500,
                    'FontRegular'),
              ),
            ),
            Expanded(

              child: Text(
                spotOption || marginOption ? (AppLocalizations.instance.text(
                    "loc_sell_trade_Qty") +
                    "\n(" +
                    firstCoin +
                    ")") : AppLocalizations.instance.text("loc_sell_trade_Qty"),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    12.0,
                    Theme
                        .of(context)
                        .focusColor
                        .withOpacity(0.5),
                    FontWeight.w500,
                    'FontRegular'),
                textAlign: TextAlign.end,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 5.0,
        ),
        socketLoader
            ? Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.4,
          child: CustomWidget(context: context)
              .loadingIndicator(CustomTheme
              .of(context)
              .focusColor),
        )
            : buyData.length > 0 && sellData.length > 0
            ? Column(
          children: [
            buyOption
                ? SizedBox(
                height: !sellOption
                    ? MediaQuery
                    .of(context)
                    .size
                    .height * 0.40
                    :marginOption? MediaQuery
                    .of(context)
                    .size
                    .height *
                    0.23:MediaQuery
                    .of(context)
                    .size
                    .height *
                    0.20,
                child: buyData.length > 0
                    ? ListView.builder(
                    controller: controller,
                    itemCount: buyData.length,

                    itemBuilder:
                    ((BuildContext context, int index) {
                      return InkWell(
                          onTap: () {
                            setState(() {
                              priceController.clear();
                              amountController.clear();
                              // if (spotOption || marginOption) {
                              //if (!enableTrade) {
                              priceController.text = livePrice;
                              buySell = false;
                              priceController.text =
                                  buyData[index]
                                      .price
                                      .toString()
                                      .replaceAll(",", "");
                              loading=true;
                              getBalance(secondCoin);
                              Future.delayed(Duration(milliseconds: 500));
                              amountController.text =(
                                  (((double.parse(balance)) * int.parse(tleverageVal)) *
                                      double.parse(priceController.text)) /
                                      100).toStringAsFixed(decimal_val);
                              // (double.parse(balance) * val) /
                              //     double.parse(priceController.text)) /
                              // 100;

                              //amountController.text="0.0";
                              // amountController.text =
                              //     buyData[index]
                              //         .quantity
                              //         .toString()
                              //         .replaceAll(",", "");

                              takerFee = ((double.parse(
                                  amountController
                                      .text
                                      .toString()) *
                                  double.parse(
                                      priceController
                                          .text
                                          .toString()) *
                                  double.parse(
                                      takerFeeValue
                                          .toString())) /
                                  100)
                                  .toStringAsFixed(decimal_val);
                              totalAmount = ((double.parse(
                                  priceController
                                      .text) *
                                  double.parse(
                                      amountController
                                          .text)))
                                  .toStringAsFixed(quote_pre);

                              if (futureOption) {
                                FuturefirstCoin =
                                    futureselectPair!
                                    .symbol
                                    .toString();
                                FuturesecondCoin = futureselectPair!
                                    .symbol
                                    .toString();
                              } else {

                              }
                              // getCoinDetailsList(
                              //     selectPair!.id.toString());
                            });
                          },
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Flexible(flex: 2,child:Text(
                                double.parse(buyData[index].price.toString())
                                    .toStringAsFixed(
                                    decimalIndex),
                                style: CustomWidget(
                                    context: context)
                                    .CustomSizedTextStyle(
                                    9.0,
                                    Theme
                                        .of(context)
                                        .hoverColor,
                                    FontWeight.w500,
                                    'FontRegular'),overflow: TextOverflow.ellipsis,
                              ),),
                              Flexible(flex: 3,child:Text(
                                double.parse(buyData[index]
                                    .quantity
                                    .toString()
                                    .replaceAll(",", ""))
                                    .toStringAsFixed(
                                    decimalIndex),
                                style: CustomWidget(
                                    context: context)
                                    .CustomSizedTextStyle(
                                    9.0,
                                    Theme
                                        .of(context)
                                        .focusColor,
                                    FontWeight.w500,
                                    'FontRegular'),overflow: TextOverflow.ellipsis,
                              ),),
                            ],
                          ));
                    }))
                    : Container(
                  height: !sellOption
                      ? MediaQuery
                      .of(context)
                      .size
                      .height *
                      0.40
                      : marginOption? MediaQuery
                      .of(context)
                      .size
                      .height *
                      0.23:MediaQuery
                      .of(context)
                      .size
                      .height *
                      0.20,
                  color:
                  CustomTheme
                      .of(context)
                      .primaryColor,
                  child: Center(
                    child: Text(
                      " No Data Found..!",
                      style: TextStyle(
                        fontFamily: "FontRegular",
                        color: CustomTheme
                            .of(context)
                            .focusColor,
                      ),
                    ),
                  ),
                ))
                : Container(),
            const SizedBox(
              height: 12.0,
            ),
   Align(child:Text(
    "$livePrice",
    style: TextStyle(
    fontFamily: "FontRegular",
    color: CustomTheme
        .of(context)
        .indicatorColor,
    ),textAlign: TextAlign.start,),alignment: Alignment.centerLeft,),

            Align(child:Text(
              formatToUSD(double.parse(livePrice.toString())),
              style: TextStyle(
                fontFamily: "FontRegular",fontSize: 10,
                color: CustomTheme
                    .of(context)
                    .focusColor,
              ),textAlign: TextAlign.start,),alignment: Alignment.centerLeft,),
            const SizedBox(
              height: 12.0,
            ),
            sellOption
                ? SizedBox(
              height: !buyOption
                  ? MediaQuery
                  .of(context)
                  .size
                  .height * 0.40
                  : MediaQuery
                  .of(context)
                  .size
                  .height * 0.23,
              child: sellData.length > 0
                  ? ListView.builder(
                  controller: controller,
                  itemCount: sellData.length,


                  itemBuilder:
                  ((BuildContext context, int index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              priceController.clear();
                              amountController.clear();
                              // if (spotOption || marginOption) {
                              //if (!enableTrade) {
                              priceController.text = livePrice;
                              buySell = true;
                              priceController.text =
                                  sellData[index]
                                      .price
                                      .toString()
                                      .replaceAll(",", "");
                              loading=true;
                              getBalance(firstCoin);
                              Future.delayed(Duration(milliseconds: 500));
                              setState(() {
                              amountController.text =(
                              (((double.parse(balance)) * int.parse(tleverageVal)) /
                                      double.parse(priceController.text)) /
                                      100).toStringAsFixed(decimal_val);
                              //amountController.text="0.0";

                              totalAmount = (double.parse(
                                  amountController
                                      .text
                                      .toString()) *
                                  double.parse(
                                      priceController
                                          .text
                                          .toString()))
                                  .toStringAsFixed(quote_pre);
                              });

                              // coinName = selectPair!
                              //     .coinname1
                              //     .toString();
                              // coinTwoName = selectPair!
                              //     .coinname2
                              //     .toString();
                              // getCoinDetailsList(selectPair!
                              //     .id
                              //     .toString());
                            });
                          },
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Flexible(flex: 2,child:Text(
                                double.parse(sellData[index]
                                    .price
                                    .toString())
                                    .toStringAsFixed(
                                    decimalIndex),
                                style: CustomWidget(
                                    context: context)
                                    .CustomSizedTextStyle(
                                    9.0,
                                    Theme
                                        .of(context)
                                        .indicatorColor,
                                    FontWeight.w500,
                                    'FontRegular'),overflow: TextOverflow.ellipsis,
                              ),),
                              Flexible(child: Text(
                                double.parse(sellData[index]
                                    .quantity
                                    .toString()
                                    .replaceAll(
                                    ",", ""))
                                    .toStringAsFixed(
                                    decimalIndex),
                                style: CustomWidget(
                                    context: context)
                                    .CustomSizedTextStyle(
                                    9.0,
                                    Theme
                                        .of(context)
                                        .focusColor,
                                    FontWeight.w500,
                                    'FontRegular'),overflow: TextOverflow.ellipsis,
                              ),flex: 3,),
                            ],
                          ),
                        )
                      ],
                    );
                  }))
                  : Container(
                height: !buyOption
                    ? MediaQuery
                    .of(context)
                    .size
                    .height *
                    0.32
                    : MediaQuery
                    .of(context)
                    .size
                    .height *
                    0.16,
                color:
                CustomTheme
                    .of(context)
                    .primaryColor,
                child: Center(
                  child: Text(
                    " No Data Found..!",
                    style: TextStyle(
                      fontFamily: "FontRegular",
                      color: CustomTheme
                          .of(context)
                          .focusColor,
                    ),
                  ),
                ),
              ),
            )
                : Container(
              color: Colors.white,
            ),


          ],
        )
            : Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.30,
          color: CustomTheme
              .of(context)
              .primaryColor,
          child: Center(
            child: Text(
              " No Data Found..!",
              style: TextStyle(
                fontFamily: "FontRegular",
                color: CustomTheme
                    .of(context)
                    .focusColor,
              ),
            ),
          ),
        ),

        const SizedBox(
          height: 12.0,
        ),
      ],
    );
  }
  String formatToUSD(double number) {
    final formatCurrency = NumberFormat.currency(
      locale: 'en_US',
      symbol: '',          // Remove the "$" symbol
      decimalDigits: number < 1 ? 4 : 2, // Use more decimal places for small numbers
    );
    return formatCurrency.format(number).trim() + " USD";
  }

  Widget openOrdersUIS() {
    return Column(
      children: [
        openOrders.length > 0
            ? Container(
          color: Theme
              .of(context)
              .primaryColorLight,
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height * 0.3,
          child: ListView.builder(
            itemCount: openOrders.length,
            shrinkWrap: true,
            controller: controller,

            itemBuilder: (BuildContext context, int index) {
              DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(openOrders[index].createdTime.toString().isEmpty?"0":openOrders[index].createdTime.toString()));
              String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
              // Moment spiritRoverOnMars =
              // Moment(openOrders[index].createdAt!).toLocal();
              return Column(
                children: [
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      key: PageStorageKey(index.toString()),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pair",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.5),
                                    FontWeight.w400,
                                    'FontRegular'),
                              ),
                              Text(
                                openOrders[index].symbol.toString(),
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    14.0,
                                    Theme
                                        .of(context)
                                        .focusColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: Theme
                                .of(context)
                                .focusColor,
                            size: 18.0,
                          )
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Date",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme
                                                  .of(context)
                                                  .focusColor
                                                  .withOpacity(0.5),
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                        Text(
                                          // spiritRoverOnMars
                                          //     .format(
                                          //     "YYYY MMMM Do - hh:mm:ssa")
                                          //     .toString(),
                                          formattedDate,
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme
                                                  .of(context)
                                                  .focusColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                      ],
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Type",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme
                                                  .of(context)
                                                  .focusColor
                                                  .withOpacity(0.5),
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                        Text(
                                          openOrders[index]
                                              .side
                                              .toString(),
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              14.0,
                                              openOrders[index]
                                                  .side
                                                  .toString()
                                                  .toLowerCase() ==
                                                  "buy"
                                                  ? CustomTheme
                                                  .of(
                                                  context)
                                                  .indicatorColor
                                                  : CustomTheme
                                                  .of(
                                                  context)
                                                  .hoverColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Order Type",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme
                                                  .of(context)
                                                  .focusColor
                                                  .withOpacity(0.5),
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                        Text(
                                          openOrders[index]
                                              .orderType
                                              .toString(),
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme
                                                  .of(context)
                                                  .focusColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                      ],
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Price",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme
                                                  .of(context)
                                                  .focusColor
                                                  .withOpacity(0.5),
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                        Text(
                                          openOrders[index]
                                              .price
                                              .toString()==null || openOrders[index]
                                              .price
                                              .toString()=="null" ?  openOrders[index]
                                              .price
                                              .toString(): openOrders[index]
                                              .price
                                              .toString(),
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme
                                                  .of(context)
                                                  .focusColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                      ],
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Quantity",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme
                                                  .of(context)
                                                  .focusColor
                                                  .withOpacity(0.5),
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                        Text(
                                          openOrders[index]
                                              .qty
                                              .toString(),
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme
                                                  .of(context)
                                                  .focusColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                      ],
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Remain",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme
                                                  .of(context)
                                                  .focusColor
                                                  .withOpacity(0.5),
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                        Text(
                                          "0",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme
                                                  .of(context)
                                                  .focusColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                        ),
                                      ],
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                    ),
                                    InkWell(
                                      child: Container(
                                        width: 80,
                                        padding: const EdgeInsets.only(
                                            top: 3.0, bottom: 3.0),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                          BorderRadius.circular(5),
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Cancel",
                                            style: CustomWidget(
                                                context: context)
                                                .CustomSizedTextStyle(
                                                12.0,
                                                Theme
                                                    .of(context)
                                                    .focusColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          loading = true;
                                          updatecancelOrder(
                                              marginOption||spotOption?"":"linear",
                                              openOrders[index]
                                                  .orderId
                                                  .toString(),openOrders[index].symbol.toString());
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        )
                      ],
                      trailing: Container(
                        width: 1.0,
                        height: 10.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height: 1.0,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    color: Theme
                        .of(context)
                        .focusColor,
                  ),
                ],
              );
            },
          ),
        )
            : Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.3,
          color: Theme
              .of(context)
              .cardColor,
          child: Center(
            child:Column(mainAxisAlignment: MainAxisAlignment.center,children: [
              spotOption?Text(
                "Please deposit or buy crypto first",
                style: CustomWidget(context: context)
                    .CustomSizedTextStyle(
                    12.0,
                    Theme
                        .of(context)
                        .focusColor,
                    FontWeight.w400,
                    'FontRegular'),
              ):Text(
                "No Record Found...",
                style: CustomWidget(context: context)
                    .CustomSizedTextStyle(
                    12.0,
                    Theme
                        .of(context)
                        .focusColor,
                    FontWeight.w400,
                    'FontRegular'),
              ),
              const SizedBox(height: 20,),
              spotOption?Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                InkWell(onTap: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => Deposit_Screen(coinList:),));
                },child:Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width*0.40,
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: CustomTheme
                          .of(context)
                          .indicatorColor
                      ,
                    ),
                    child: Center(
                      child: Text(
                       'Deposit',
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            14.0,
                            Theme
                                .of(context)
                                .cardColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                    )),),
                Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width*0.40,
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: CustomTheme
                          .of(context)
                          .hoverColor,
                    ),
                    child: Center(
                      child: Text(
                        AppLocalizations.instance.text("loc_sell_trade_txt5"),
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            14.0,
                            Theme
                                .of(context)
                                .cardColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                    )),
              ],):Container()
            ],),
          ),
        ),
        const SizedBox(
          height: 30.0,
        )
      ],
    );
  }

  showSuccessAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext contexts) {
          return Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: CustomTheme
                  .of(context)
                  .primaryColorLight,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.pop(contexts);
                          buyOption = true;
                          sellOption = true;
                        });
                      },
                      child: Text(
                        AppLocalizations.instance.text("loc_all").toUpperCase(),
                        style: CustomWidget(context: context).CustomTextStyle(
                            Theme
                                .of(context)
                                .focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.pop(contexts);
                          buyOption = true;
                          sellOption = false;
                        });
                      },
                      child: Text(
                        AppLocalizations.instance.text("loc_buy").toUpperCase(),
                        style: CustomWidget(context: context).CustomTextStyle(
                            Theme
                                .of(context)
                                .focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.pop(contexts);
                          buyOption = false;
                          sellOption = true;
                        });
                      },
                      child: Text(
                        AppLocalizations.instance
                            .text("loc_sell")
                            .toUpperCase(),
                        style: CustomWidget(context: context).CustomTextStyle(
                            Theme
                                .of(context)
                                .focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    // show the dialog
  }

  Widget OrderWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            // border: Border.all(
            //     color: CustomTheme.of(context).focusColor.withOpacity(0.3),
            //     width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        buySell = true;
                      });
                      setState(() {
                        amountController.clear();
                        priceController.text=livePrice;
                        stopPriceController.clear();
                        totalAmount = "0.0";
                        _currentSliderValue = 0;
                        tleverageVal = "1";
                        balance = "0.00";
                        tbalance="0.00";

                        // getCoinDetailsList(selectPair!.id.toString());
                        // coinName = selectPair!.coinname1.toString();
                        // coinTwoName = selectPair!.coinname2.toString();
                        // print(coinName);
                        loading=true;
                        getBalance(firstCoin);
                      });
                    },
                    child: Stack(
                      children: [
                        // Container(
                        //   child: SvgPicture.asset(
                        //     'assets/icons/buy.svg',
                        //     color: buySell
                        //         ? CustomTheme
                        //         .of(context)
                        //         .indicatorColor
                        //         : CustomTheme
                        //         .of(context)
                        //         .focusColor
                        //         .withOpacity(0.2),
                        //     fit: BoxFit.fill,
                        //   ),
                        //   height: 34.0,
                        // ),
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0),color: buySell
            ? CustomTheme
            .of(context)
            .indicatorColor
            : CustomTheme
            .of(context)
            .focusColor ),
                            child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(6.0
                                      ),
                                  child: Text(
                                    AppLocalizations.instance
                                        .text("loc_sell_trade_txt5"),
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        13.0,
                                        buySell
                                            ? CustomTheme
                                            .of(context)
                                            .cardColor
                                            : CustomTheme
                                            .of(context)
                                            .cardColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                                  ),
                                ))),
                      ],
                    )),
              ),
              const SizedBox(width: 5,),
              Flexible(
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          buySell = false;
                          balance = "0.00";
                          tbalance="0.00";
                        });
                        // print("Test");
                        setState(() {
                          buySell = false;
                          amountController.clear();
                          priceController.text=livePrice;
                          stopPriceController.clear();
                          totalAmount = "0.0";
                          _currentSliderValue = 0;
                          tleverageVal = "1";
                          // getCoinDetailsList(selectPair!.id.toString());
                          // coinName = selectPair!.coinname1.toString();
                          // coinTwoName = selectPair!.coinname2.toString();
                          loading=true;
                          getBalance(secondCoin);
                        });
                      },
                      child: Stack(
                        children: [
                          // Container(
                          //   child: SvgPicture.asset(
                          //     'assets/icons/sell.svg',
                          //     color: !buySell
                          //         ? CustomTheme
                          //         .of(context)
                          //         .hoverColor
                          //         : CustomTheme
                          //         .of(context)
                          //         .focusColor
                          //         .withOpacity(0.2),
                          //     fit: BoxFit.fill,
                          //   ),
                          //   height: 34.0,
                          // ),
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: !buySell
            ? CustomTheme
            .of(context)
            .hoverColor
            : CustomTheme
            .of(context)
            .focusColor
            ),
                              child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        6.0),
                                    child: Text(
                                      AppLocalizations.instance
                                          .text("loc_sell_trade_txt6"),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          13.0,
                                          !buySell
                                              ? CustomTheme
                                              .of(context)
                                              .cardColor
                                              : CustomTheme
                                              .of(context)
                                              .cardColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                    ),
                                  ))),
                        ],
                      )))
            ],
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 35.0,
          padding: EdgeInsets.fromLTRB(5, 0.0, 5, 0.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: CustomTheme
                    .of(context)
                    .focusColor
                    .withOpacity(0.5),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: CustomTheme
                  .of(context)
                  .primaryColorLight,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                menuMaxHeight: MediaQuery
                    .of(context)
                    .size
                    .height * 0.7,
                items: chartTime
                    .map((value) =>
                    DropdownMenuItem(
                      child: Text(
                        value.toString(),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            10.0,
                            Theme
                                .of(context)
                                .focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                      value: value,
                    ))
                    .toList(),
                onChanged: (value) async {
                  setState(() {
                    selectedTime = value.toString();
                    if (selectedTime == "Limit") {
                      enableTrade = false;
                      _currentSliderValue = 0;
                      tleverageVal = "1";
                      enableStopLimit = false;
                      priceController.text=livePrice;
                      amountController.clear();
                      totalAmount = "0.00";
                    } else if (selectedTime == "Market") {
                      priceController.text=livePrice;
                      _currentSliderValue = 0;
                      tleverageVal = "1";
                      amountController.clear();
                      enableStopLimit = false;
                      totalAmount = "0.00";
                      enableTrade = true;
                    } else {
                      enableStopLimit = true;
                      _currentSliderValue = 0;
                      tleverageVal = "1";
                      priceController.clear();
                      amountController.clear();
                      stopPriceController.clear();
                      totalAmount = "0.00";
                      enableTrade = false;
                    }
                  });
                },
                hint: Text(
                  "Select Category",
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      12.0,
                      Theme
                          .of(context)
                          .focusColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
                isExpanded: true,
                value: selectedTime,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Theme
                      .of(context)
                      .focusColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        spotOption
            ? Container()
            : Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 35.0,
          padding: EdgeInsets.fromLTRB(5, 0.0, 5, 0.0),
          decoration: BoxDecoration(
            border: Border.all(
                color:
                CustomTheme
                    .of(context)
                    .focusColor
                    .withOpacity(0.5),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: CustomTheme
                  .of(context)
                  .primaryColorLight,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                menuMaxHeight: MediaQuery
                    .of(context)
                    .size
                    .height * 0.7,
                items: !futureOption
                    ? tradeType
                    .map((value) =>
                    DropdownMenuItem(
                      child: Text(
                        value.toString(),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            10.0,
                            Theme
                                .of(context)
                                .focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                      value: value,
                    ))
                    .toList()
                    : tradeType
                    .map((value) =>
                    DropdownMenuItem(
                      child: Text(
                        value.toString(),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            10.0,
                            Theme
                                .of(context)
                                .focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                      value: value,
                    ))
                    .toList(),
                onChanged: (value) async {
                  setState(() {
                    selectedHistoryTradeType = value.toString();
                  });
                },
                hint: Text(
                  "Select Category",
                  style: CustomWidget(context: context)
                      .CustomSizedTextStyle(
                      12.0,
                      Theme
                          .of(context)
                          .focusColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
                isExpanded: true,
                value: selectedHistoryTradeType,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Theme
                      .of(context)
                      .focusColor,
                ),
              ),
            ),
          ),
        ),
        spotOption
            ? const SizedBox()
            : const SizedBox(
          height: 10.0,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: enableTrade
                    ? Theme
                    .of(context)
                    .focusColor
                    .withOpacity(0.1)
                    : CustomTheme
                    .of(context)
                    .focusColor
                    .withOpacity(0.5),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Container(
                    height: 40.0,
                    child: TextField(
                      enabled: !enableTrade,
                      controller: priceController,
                      keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          13.0,
                          Theme
                              .of(context)
                              .focusColor,
                          FontWeight.w500,
                          'FontRegular'),
                      onChanged: (value) {
                        setState(() {
                          price = "0.0";
                          // price = value.toString();
                          tradeAmount = "0.00";

                          if (priceController.text.isNotEmpty) {
                            double amount = double.parse(priceController.text);
                            price = priceController.text;
                            if (enableStopLimit) {
                              if (priceController.text.isNotEmpty &&
                                  stopPriceController.text.isNotEmpty) {
                                if ((double.parse(
                                    priceController.text.toString()) >
                                    double.parse(
                                        stopPriceController.text.toString()))) {
                                  takerFee = ((double.parse(
                                      priceController.text.toString()) *
                                      double.parse(amountController.text
                                          .toString()) *
                                      double.parse(
                                          takerFeeValue.toString())) /
                                      100)
                                      .toStringAsFixed(decimal_val);

                                  totalAmount = (double.parse(
                                      amountController.text.toString()) *
                                      double.parse(
                                          priceController.text.toString()))
                                      .toStringAsFixed(decimal_val);
                                } else {
                                  takerFee =
                                      ((double.parse(stopPriceController.text
                                          .toString()) *
                                          double.parse(amountController.text
                                              .toString()) *
                                          double.parse(
                                              takerFeeValue.toString())) /
                                          100)
                                          .toStringAsFixed(decimal_val);

                                  totalAmount = (double.parse(
                                      amountController.text.toString()) *
                                      double.parse(
                                          stopPriceController.text.toString()))
                                      .toStringAsFixed(quote_pre);
                                }
                              }
                            } else {
                              if (priceController.text.isNotEmpty) {
                                if (!buySell) {
                                  takerFee = ((amount *
                                      double.parse(
                                          priceController.text.toString()) *
                                      double.parse(
                                          takerFeeValue.toString())) /
                                      100)
                                      .toStringAsFixed(decimal_val);

                                  totalAmount = (double.parse(
                                      amountController.text.toString()) *
                                      double.parse(
                                          priceController.text.toString()))
                                      .toStringAsFixed(quote_pre);
                                } else {
                                  totalAmount = (double.parse(
                                      amountController.text.toString()) *
                                      double.parse(
                                          priceController.text.toString()))
                                      .toStringAsFixed(quote_pre);
                                }
                              }
                            }
                          } else {
                            tradeAmount = "0.00";
                            totalAmount = "0.00";
                          }
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 8.0),
                          hintText: "Price",
                          hintStyle: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                              12.0,
                              Theme
                                  .of(context)
                                  .focusColor
                                  .withOpacity(0.5),
                              FontWeight.w500,
                              'FontRegular'),
                          border: InputBorder.none),
                      textAlign: TextAlign.start,
                    ),
                  )),
              // InkWell(
              //   onTap: () {
              //     if (enableTrade) {
              //     } else {
              //       setState(() {
              //         if (priceController.text.isNotEmpty) {
              //           double amount = double.parse(priceController.text);
              //           if (amount > 0) {
              //             amount = amount - 0.01;
              //             priceController.text = amount.toStringAsFixed(2);
              //             tradeAmount = priceController.text;
              //             if (enableStopLimit) {
              //               if (stopPriceController.text.isNotEmpty &&
              //                   priceController.text.isNotEmpty) {
              //                 if ((double.parse(
              //                         priceController.text.toString()) >
              //                     double.parse(
              //                         stopPriceController.text.toString()))) {
              //                   takerFee =
              //                       ((double.parse(priceController.text
              //                                       .toString()) *
              //                                   double.parse(amountController
              //                                       .text
              //                                       .toString()) *
              //                                   double.parse(
              //                                       takerFeeValue.toString())) /
              //                               100)
              //                           .toStringAsFixed(decimal_val);
              //
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(
              //                               priceController.text.toString()))
              //                       .toStringAsFixed(decimal_val);
              //                   /*  totalAmount = ((double.parse(
              //                       priceController.text
              //                           .toString()) *
              //                       double.parse(amountController
              //                           .text
              //                           .toString())) -
              //                       double.parse(takerFee))
              //                       .toStringAsFixed(decimal_val);*/
              //                 } else {
              //                   takerFee = ((double.parse(stopPriceController
              //                                   .text
              //                                   .toString()) *
              //                               double.parse(amountController.text
              //                                   .toString()) *
              //                               double.parse(
              //                                   takerFeeValue.toString())) /
              //                           100)
              //                       .toStringAsFixed(decimal_val);
              //
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(livePrice))
              //                       .toStringAsFixed(decimal_val);
              //
              //                   /*totalAmount = ((double.parse(
              //                       stopPriceController.text
              //                           .toString()) *
              //                       double.parse(amountController
              //                           .text
              //                           .toString())) -
              //                       double.parse(takerFee))
              //                       .toStringAsFixed(decimal_val);*/
              //                 }
              //               }
              //             } else {
              //               if (priceController.text.isNotEmpty) {
              //                 if (!buySell) {
              //                   takerFee = ((amount *
              //                               double.parse(priceController.text
              //                                   .toString()) *
              //                               double.parse(
              //                                   takerFeeValue.toString())) /
              //                           100)
              //                       .toStringAsFixed(decimal_val);
              //
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(
              //                               priceController.text.toString()))
              //                       .toStringAsFixed(decimal_val);
              //                 } else {
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(
              //                               priceController.text.toString()))
              //                       .toStringAsFixed(decimal_val);
              //                 }
              //               }
              //             }
              //           }
              //         } else {
              //           priceController.text = "0.01";
              //           tradeAmount = amountController.text;
              //           totalAmount = "0.000";
              //         }
              //       });
              //     }
              //   },
              //   child: Container(
              //       height: 40.0,
              //       width: 35.0,
              //       padding: const EdgeInsets.only(
              //         left: 10.0,
              //         right: 10.0,
              //       ),
              //       decoration: BoxDecoration(
              //         color: enableTrade
              //             ? Theme.of(context).cardColor.withOpacity(0.2)
              //             : CustomTheme.of(context).cardColor,
              //         borderRadius: BorderRadius.circular(2),
              //       ),
              //       child: Center(
              //         child: Text(
              //           "-",
              //           style: CustomWidget(context: context)
              //               .CustomSizedTextStyle(
              //                   20.0,
              //                   enableTrade
              //                       ? Theme.of(context)
              //                           .cardColor
              //                           .withOpacity(0.5)
              //                       : Theme.of(context).focusColor,
              //                   FontWeight.w500,
              //                   'FontRegular'),
              //         ),
              //       )),
              // ),
              const SizedBox(
                width: 2.0,
              ),
              // InkWell(
              //   onTap: () {
              //     if (enableTrade) {
              //     } else {
              //       setState(() {
              //         if (priceController.text.isNotEmpty) {
              //           double amount = double.parse(priceController.text);
              //           if (amount >= 0) {
              //             amount = amount + 0.01;
              //             priceController.text = amount.toStringAsFixed(2);
              //             tradeAmount = priceController.text;
              //             if (enableStopLimit) {
              //               if (stopPriceController.text.isNotEmpty &&
              //                   priceController.text.isNotEmpty) {
              //                 if ((double.parse(
              //                         priceController.text.toString()) >
              //                     double.parse(
              //                         stopPriceController.text.toString()))) {
              //                   takerFee =
              //                       ((double.parse(priceController.text
              //                                       .toString()) *
              //                                   double.parse(amountController
              //                                       .text
              //                                       .toString()) *
              //                                   double.parse(
              //                                       takerFeeValue.toString())) /
              //                               100)
              //                           .toStringAsFixed(decimal_val);
              //
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(
              //                               priceController.text.toString()))
              //                       .toStringAsFixed(decimal_val);
              //                   /*  totalAmount = ((double.parse(
              //                       priceController.text
              //                           .toString()) *
              //                       double.parse(amountController
              //                           .text
              //                           .toString())) -
              //                       double.parse(takerFee))
              //                       .toStringAsFixed(decimal_val);*/
              //                 } else {
              //                   takerFee = ((double.parse(stopPriceController
              //                                   .text
              //                                   .toString()) *
              //                               double.parse(amountController.text
              //                                   .toString()) *
              //                               double.parse(
              //                                   takerFeeValue.toString())) /
              //                           100)
              //                       .toStringAsFixed(decimal_val);
              //
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(livePrice))
              //                       .toStringAsFixed(decimal_val);
              //
              //                   /*totalAmount = ((double.parse(
              //                       stopPriceController.text
              //                           .toString()) *
              //                       double.parse(amountController
              //                           .text
              //                           .toString())) -
              //                       double.parse(takerFee))
              //                       .toStringAsFixed(decimal_val);*/
              //                 }
              //               }
              //             } else {
              //               if (priceController.text.isNotEmpty) {
              //                 if (!buySell) {
              //                   takerFee = ((amount *
              //                               double.parse(priceController.text
              //                                   .toString()) *
              //                               double.parse(
              //                                   takerFeeValue.toString())) /
              //                           100)
              //                       .toStringAsFixed(decimal_val);
              //
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(
              //                               priceController.text.toString()))
              //                       .toStringAsFixed(decimal_val);
              //                 } else {
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(
              //                               priceController.text.toString()))
              //                       .toStringAsFixed(decimal_val);
              //                 }
              //               }
              //             }
              //           }
              //         } else {
              //           priceController.text = "0.01";
              //           tradeAmount = amountController.text;
              //           totalAmount = "0.000";
              //         }
              //       });
              //     }
              //   },
              //   child: Container(
              //       height: 40.0,
              //       width: 35.0,
              //       padding: const EdgeInsets.only(
              //         left: 10.0,
              //         right: 10.0,
              //       ),
              //       decoration: BoxDecoration(
              //         color: enableTrade
              //             ? Theme.of(context).cardColor.withOpacity(0.2)
              //             : CustomTheme.of(context).cardColor,
              //         borderRadius: BorderRadius.circular(2),
              //       ),
              //       child: Center(
              //         child: Text(
              //           "+",
              //           style: CustomWidget(context: context)
              //               .CustomSizedTextStyle(
              //                   20.0,
              //                   enableTrade
              //                       ? Theme.of(context)
              //                           .cardColor
              //                           .withOpacity(0.2)
              //                       : Theme.of(context).focusColor,
              //                   FontWeight.w500,
              //                   'FontRegular'),
              //         ),
              //       )),
              // ),
            ],
          ),
        ),
        enableTrade
            ? Container()
            : const SizedBox(
          height: 5.0,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: CustomTheme
                    .of(context)
                    .focusColor
                    .withOpacity(0.5),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Container(
                    height: 40.0,
                    child: TextField(
                      controller: amountController,
                      keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          13.0,
                          Theme
                              .of(context)
                              .focusColor,
                          FontWeight.w500,
                          'FontRegular'),
                      onChanged: (value) {
                        setState(() {
                          price = "0.0";
                          // price = value.toString();
                          totalAmount = "0.00";

                          if (enableTrade) {
                            if (amountController.text.isNotEmpty) {
                              totalAmount =
                                  (double.parse(
                                      amountController.text.toString()) /
                                      double.parse(balance))
                                      .toStringAsFixed(quote_pre);
                            }
                            else{
                              totalAmount =
                                  (double.parse(
                                      amountController.text.toString()) *
                                      double.parse(balance))
                                      .toStringAsFixed(quote_pre);
                            }
                          } else {
                            if (amountController.text.isNotEmpty) {
                              double amount = double.parse(
                                  amountController.text);
                              if (amount >= 0) {
                                tradeAmount = amountController.text;
                                if (enableStopLimit) {
                                  if (stopPriceController.text.isNotEmpty &&
                                      priceController.text.isNotEmpty) {
                                    if ((double.parse(
                                        priceController.text.toString()) >
                                        double.parse(
                                            stopPriceController.text
                                                .toString()))) {
                                      takerFee =
                                          ((double.parse(priceController.text
                                              .toString()) *
                                              double.parse(amountController
                                                  .text
                                                  .toString()) *
                                              double.parse(takerFeeValue
                                                  .toString())) /
                                              100)
                                              .toStringAsFixed(decimal_val);

                                      totalAmount =
                                          (double.parse(amountController
                                              .text
                                              .toString()) *
                                              double.parse(
                                                  priceController.text
                                                      .toString()))
                                              .toStringAsFixed(quote_pre);
                                      /*  totalAmount = ((double.parse(
                                    priceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(decimal_val);*/
                                    } else {
                                      takerFee =
                                          ((double.parse(stopPriceController
                                              .text
                                              .toString()) *
                                              double.parse(amountController.text
                                                  .toString()) *
                                              double.parse(
                                                  takerFeeValue.toString())) /
                                              100)
                                              .toStringAsFixed(decimal_val);

                                      totalAmount =
                                          (double.parse(amountController
                                              .text
                                              .toString()) *
                                              double.parse(livePrice))
                                              .toStringAsFixed(quote_pre);

                                      /*totalAmount = ((double.parse(
                                    stopPriceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(decimal_val);*/
                                    }
                                  }
                                } else {
                                  if (priceController.text.isNotEmpty) {
                                    if (!buySell) {
                                      takerFee = ((amount *
                                          double.parse(priceController.text
                                              .toString()) *
                                          double.parse(
                                              takerFeeValue.toString())) /
                                          100)
                                          .toStringAsFixed(decimal_val);

                                      totalAmount =
                                          (double.parse(amountController
                                              .text
                                              .toString()) /
                                              double.parse(
                                                  priceController.text
                                                      .toString()))
                                              .toStringAsFixed(quote_pre);
                                    } else {
                                      totalAmount =
                                          (double.parse(amountController
                                              .text
                                              .toString()) *
                                              double.parse(
                                                  priceController.text
                                                      .toString()))
                                              .toStringAsFixed(quote_pre);
                                    }
                                  }
                                }
                              }
                            } else {
                              tradeAmount = amountController.text;
                              totalAmount = "0.000";
                            }
                          }
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 8.0),
                          hintText: "Quantity",
                          hintStyle: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                              12.0,
                              Theme
                                  .of(context)
                                  .focusColor
                                  .withOpacity(0.5),
                              FontWeight.w500,
                              'FontRegular'),
                          border: InputBorder.none),
                      textAlign: TextAlign.start,
                    ),
                  )),

              const SizedBox(
                width: 2.0,
              ),

            ],
          ),
        ),
        // enableStopLimit
        //     ? SizedBox(
        //         height: 15.0,
        //       )
        //     : Container(),
        // enableStopLimit
        //     ? Container(
        //         padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
        //         decoration: BoxDecoration(
        //           border: Border.all(
        //               color: enableTrade
        //                   ? Theme.of(context).focusColor.withOpacity(0.1)
        //                   : CustomTheme.of(context).focusColor.withOpacity(0.5),
        //               width: 1.0),
        //           borderRadius: BorderRadius.circular(5.0),
        //           color: Colors.transparent,
        //         ),
        //         child: Row(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Flexible(
        //                 child: Container(
        //               height: 40.0,
        //               child: TextField(
        //                 enabled: !enableTrade,
        //                 controller: stopPriceController,
        //                 keyboardType: const TextInputType.numberWithOptions(
        //                     decimal: true),
        //                 style: CustomWidget(context: context)
        //                     .CustomSizedTextStyle(
        //                         13.0,
        //                         Theme.of(context).focusColor,
        //                         FontWeight.w500,
        //                         'FontRegular'),
        //                 onChanged: (value) {
        //                   setState(() {
        //                     stopPrice = "0.0";
        //                     // price = value.toString();
        //                     tradeAmount = "0.00";
        //
        //                     if (stopPriceController.text.isNotEmpty) {
        //                       stopPrice = stopPriceController.text;
        //                       tradeAmount = stopPriceController.text.toString();
        //                       if (amountController.text.isNotEmpty &&
        //                           priceController.text.isNotEmpty) {
        //                         if (!buySell) {
        //                           if ((double.parse(
        //                                   priceController.text.toString()) >
        //                               double.parse(stopPriceController.text
        //                                   .toString()))) {
        //                             takerFee =
        //                                 ((double.parse(priceController.text
        //                                                 .toString()) *
        //                                             double.parse(
        //                                                 amountController.text
        //                                                     .toString()) *
        //                                             double.parse(takerFeeValue
        //                                                 .toString())) /
        //                                         100)
        //                                     .toStringAsFixed(decimal_val);
        //
        //                             totalAmount = (double.parse(priceController
        //                                         .text
        //                                         .toString()) *
        //                                     double.parse(amountController.text
        //                                         .toString()))
        //                                 .toStringAsFixed(decimal_val);
        //                           } else {
        //                             takerFee = ((double.parse(
        //                                             stopPriceController.text
        //                                                 .toString()) *
        //                                         double.parse(amountController
        //                                             .text
        //                                             .toString()) *
        //                                         double.parse(
        //                                             takerFeeValue.toString())) /
        //                                     100)
        //                                 .toStringAsFixed(decimal_val);
        //
        //                             totalAmount = (double.parse(
        //                                         stopPriceController.text
        //                                             .toString()) *
        //                                     double.parse(amountController.text
        //                                         .toString()))
        //                                 .toStringAsFixed(decimal_val);
        //                           }
        //                         } else {
        //                           if ((double.parse(
        //                                   priceController.text.toString()) >
        //                               double.parse(stopPriceController.text
        //                                   .toString()))) {
        //                             takerFee =
        //                                 ((double.parse(priceController.text
        //                                                 .toString()) *
        //                                             double.parse(
        //                                                 amountController.text
        //                                                     .toString()) *
        //                                             double.parse(takerFeeValue
        //                                                 .toString())) /
        //                                         100)
        //                                     .toStringAsFixed(decimal_val);
        //
        //                             totalAmount = (double.parse(priceController
        //                                         .text
        //                                         .toString()) *
        //                                     double.parse(amountController.text
        //                                         .toString()))
        //                                 .toStringAsFixed(decimal_val);
        //                             ;
        //                           } else {
        //                             takerFee = ((double.parse(amountController
        //                                             .text
        //                                             .toString()) *
        //                                         double.parse(stopPriceController
        //                                             .text
        //                                             .toString()) *
        //                                         double.parse(
        //                                             takerFeeValue.toString())) /
        //                                     100)
        //                                 .toStringAsFixed(decimal_val);
        //
        //                             totalAmount = (double.parse(
        //                                         stopPriceController.text
        //                                             .toString()) *
        //                                     double.parse(amountController.text
        //                                         .toString()))
        //                                 .toStringAsFixed(decimal_val);
        //                           }
        //                         }
        //                       }
        //                     } else {
        //                       tradeAmount = "0.00";
        //                       totalAmount = "0.00";
        //                     }
        //                   });
        //                 },
        //                 decoration: InputDecoration(
        //                     contentPadding: EdgeInsets.only(bottom: 8.0),
        //                     hintText: "Stop-Price",
        //                     hintStyle: CustomWidget(context: context)
        //                         .CustomSizedTextStyle(
        //                             12.0,
        //                             Theme.of(context)
        //                                 .focusColor
        //                                 .withOpacity(0.5),
        //                             FontWeight.w500,
        //                             'FontRegular'),
        //                     border: InputBorder.none),
        //                 textAlign: TextAlign.start,
        //               ),
        //             )),
        //             InkWell(
        //               onTap: () {
        //                 if (enableTrade) {
        //                 } else {
        //                   setState(() {
        //                     tradeAmount = "0.00";
        //                     if (stopPriceController.text.isNotEmpty) {
        //                       double amount =
        //                           double.parse(stopPriceController.text);
        //
        //                       if (amount > 0) {
        //                         amount = amount - 0.01;
        //                         stopPriceController.text =
        //                             amount.toStringAsFixed(2);
        //                         stopPrice = stopPriceController.text;
        //
        //                         if (amountController.text.isNotEmpty) {
        //                           tradeAmount =
        //                               amountController.text.toString();
        //                           takerFee = ((amount *
        //                                       double.parse(amountController.text
        //                                           .toString()) *
        //                                       double.parse(
        //                                           takerFeeValue.toString())) /
        //                                   100)
        //                               .toStringAsFixed(decimal_val);
        //
        //                           totalAmount = (double.parse(
        //                                       stopPriceController.text
        //                                           .toString()) *
        //                                   double.parse(
        //                                       amountController.text.toString()))
        //                               .toStringAsFixed(decimal_val);
        //                         } else {
        //                           totalAmount = "0.00";
        //                         }
        //                       } else {
        //                         stopPriceController.text = "0.01";
        //                         totalAmount = "0.00";
        //                       }
        //                     }
        //                   });
        //                 }
        //               },
        //               child: Container(
        //                   height: 40.0,
        //                   width: 35.0,
        //                   padding: const EdgeInsets.only(
        //                     left: 10.0,
        //                     right: 10.0,
        //                   ),
        //                   decoration: BoxDecoration(
        //                     color: enableTrade
        //                         ? Theme.of(context).cardColor.withOpacity(0.2)
        //                         : CustomTheme.of(context).cardColor,
        //                     borderRadius: BorderRadius.circular(2),
        //                   ),
        //                   child: Center(
        //                     child: Text(
        //                       "-",
        //                       style: CustomWidget(context: context)
        //                           .CustomSizedTextStyle(
        //                               20.0,
        //                               enableTrade
        //                                   ? Theme.of(context)
        //                                       .cardColor
        //                                       .withOpacity(0.5)
        //                                   : Theme.of(context).focusColor,
        //                               FontWeight.w500,
        //                               'FontRegular'),
        //                     ),
        //                   )),
        //             ),
        //             const SizedBox(
        //               width: 2.0,
        //             ),
        //             InkWell(
        //               onTap: () {
        //                 if (enableTrade) {
        //                 } else {
        //                   setState(() {
        //                     if (stopPriceController.text.isNotEmpty) {
        //                       double amount =
        //                           double.parse(stopPriceController.text);
        //                       if (amount >= 0) {
        //                         amount = amount + 0.01;
        //                         stopPriceController.text =
        //                             amount.toStringAsFixed(2);
        //                         stopPrice = stopPriceController.text;
        //                         if (amountController.text.isNotEmpty) {
        //                           takerFee = ((double.parse(amountController
        //                                           .text
        //                                           .toString()) *
        //                                       double.parse(stopPriceController
        //                                           .text
        //                                           .toString()) *
        //                                       double.parse(
        //                                           takerFeeValue.toString())) /
        //                                   100)
        //                               .toStringAsFixed(decimal_val);
        //
        //                           totalAmount = (double.parse(
        //                                       stopPriceController.text
        //                                           .toString()) *
        //                                   double.parse(
        //                                       amountController.text.toString()))
        //                               .toStringAsFixed(decimal_val);
        //                         } else {
        //                           // priceController.text = "0.01";
        //                           tradeAmount = "0.00";
        //                         }
        //                       }
        //                     } else {
        //                       stopPriceController.text = "0.01";
        //                       tradeAmount = "0.00";
        //                     }
        //                   });
        //                 }
        //               },
        //               child: Container(
        //                   height: 40.0,
        //                   width: 35.0,
        //                   padding: const EdgeInsets.only(
        //                     left: 10.0,
        //                     right: 10.0,
        //                   ),
        //                   decoration: BoxDecoration(
        //                     color: enableTrade
        //                         ? Theme.of(context).cardColor.withOpacity(0.2)
        //                         : CustomTheme.of(context).cardColor,
        //                     borderRadius: BorderRadius.circular(2),
        //                   ),
        //                   child: Center(
        //                     child: Text(
        //                       "+",
        //                       style: CustomWidget(context: context)
        //                           .CustomSizedTextStyle(
        //                               20.0,
        //                               enableTrade
        //                                   ? Theme.of(context)
        //                                       .cardColor
        //                                       .withOpacity(0.2)
        //                                   : Theme.of(context).focusColor,
        //                               FontWeight.w500,
        //                               'FontRegular'),
        //                     ),
        //                   )),
        //             ),
        //           ],
        //         ),
        //       )
        //     : SizedBox(),
        Container(
          child: SliderTheme(
            data: SliderThemeData(
              valueIndicatorColor: CustomTheme
                  .of(context)
                  .indicatorColor,
              trackHeight: 1.0,

              activeTickMarkColor: CustomTheme
                  .of(context)
                  .focusColor,
              inactiveTickMarkColor:
              CustomTheme
                  .of(context)
                  .focusColor
                  .withOpacity(0.5),
              tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 4.0),
              trackShape: CustomTrackShape(),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
            ),
            child: Slider(
              value: _currentSliderValue,
              max: 100,
              divisions: 4,
              label: tleverageVal,
              inactiveColor: CustomTheme
                  .of(context)
                  .focusColor,
              activeColor: buySell
                  ? CustomTheme
                  .of(context)
                  .indicatorColor
                  : CustomTheme
                  .of(context)
                  .hoverColor,
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                  if (_currentSliderValue > 0) {
                    _tLevSliderValue = _currentSliderValue.toInt();
                    print(_tLevSliderValue);
                    setState(() {
                      if(marginOption==false) {
                        if (_tLevSliderValue == 25) {
                          tleverageVal = "25";
                        } else if (_tLevSliderValue == 50) {
                          tleverageVal = "50";
                        } else if (_tLevSliderValue == 75) {
                          tleverageVal = "75";
                        } else {
                          tleverageVal = "100";
                        }
                      }
                    });
                    int val = _currentSliderValue.toInt();
                    setState(() {
                      priceController.clear();
                      amountController.clear();
                      // if (spotOption || marginOption) {
                        //if (!enableTrade) {
                          priceController.text = livePrice;
                        //}
                        if (double.parse(livePrice) > 0) {
                          if (buySell) {
                            double perce = ((double.parse(balance) * val==100?98:val) /
                                double.parse(priceController.text)) /
                                100;

                            amountController.text =
                                double.parse(perce.toString())
                                    .toStringAsFixed(decimal_val);
                            double a = double.parse(perce
                                .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                            double b = double.parse(livePrice);
                            totalAmount = double.parse((a * b).toString())
                                .toStringAsFixed(quote_pre);
                          } else {
                            double perce = ((double.parse(balance) * val==100?98:val)*
                                double.parse(priceController.text)) / 100;

                            amountController.text =
                                double.parse(perce.toString())
                                    .toStringAsFixed(decimal_val);
                            double a = double.parse(perce
                                .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                            double b = double.parse(livePrice);
                            totalAmount = double.parse((a / b).toString())
                                .toStringAsFixed(quote_pre);
                          }
                        }
                        else{
                          amountController.text = "0.00";
                        }
                      //}
                    });
                  } else {
                    amountController.text = "0.00";
                    if (!enableTrade) {
                      priceController.text = "0.00";
                    }
                    totalAmount = "0.00";
                  }
                });
              },
            ),
          ),
        ),
        marginOption?Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
          Flexible(child:GestureDetector(onTap: () {
            setState(() {
              tleverageVal="2";
            });
          },child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
              color: tleverageVal=="2"?Theme.of(context).indicatorColor:Theme.of(context).dividerColor),padding: EdgeInsets.all(8),child: Text("2%",style:CustomWidget(context: context)
              .CustomSizedTextStyle(
              10.0,
              Theme
                  .of(context)
                  .focusColor,
              FontWeight.w400,
              'FontRegular'),),),),),
          Flexible(child:GestureDetector(onTap: () {
            setState(() {
              tleverageVal="5";
            });
          },child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
              color: tleverageVal=="5"?Theme.of(context).indicatorColor:Theme.of(context).dividerColor),padding: EdgeInsets.all(8),child: Text("5%",style:CustomWidget(context: context)
              .CustomSizedTextStyle(
              10.0,
              Theme
                  .of(context)
                  .focusColor,
              FontWeight.w400,
              'FontRegular'),),),),),
          Flexible(child:GestureDetector(onTap: () {
            setState(() {
              tleverageVal="8";
            });
          },child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
              color: tleverageVal=="8"?Theme.of(context).indicatorColor:Theme.of(context).dividerColor),padding: EdgeInsets.all(8),child: Text("8%",style:CustomWidget(context: context)
              .CustomSizedTextStyle(
              10.0,
              Theme
                  .of(context)
                  .focusColor,
              FontWeight.w400,
              'FontRegular'),),),),),
          Flexible(child: GestureDetector(onTap: () {
            setState(() {
              tleverageVal="10";
            });
          },child:Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
              color: tleverageVal=="10"?Theme.of(context).indicatorColor:Theme.of(context).dividerColor),padding: EdgeInsets.all(8),child: Text("10%",style:CustomWidget(context: context)
              .CustomSizedTextStyle(
              10.0,
              Theme
                  .of(context)
                  .focusColor,
              FontWeight.w400,
              'FontRegular'),),),),),
        ],):Container(),
        marginOption?const SizedBox(height: 15,):SizedBox(height: 10,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              child: Transform.scale(
                scale: 0.8,
                child: Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  value: tpslCheck,
                  activeColor: Theme
                      .of(context)
                      .focusColor,
                  checkColor: Theme
                      .of(context)
                      .primaryColorDark,
                  onChanged: (bool? value) {
                    setState(() {
                      tpslCheck = value!;
                    });
                  },
                ),
              ),
              width: 18.0,
              height: 20.0,

            ),
            const SizedBox(
              width: 5.0,
            ),
            Flexible(child: RichText(
              text: TextSpan(
                text: 'TP/SL',
                style: CustomWidget(context: context)
                    .CustomSizedTextStyle(
                    12.0,
                    Theme
                        .of(context)
                        .disabledColor,
                    FontWeight.w400,
                    'FontRegular'),
              ),
            ),),
            //Checkbox
          ],
        ),
        const SizedBox(
          height: 5.0,
        ),
        tpslCheck ? Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: enableTrade
                          ? Theme
                          .of(context)
                          .focusColor
                          .withOpacity(0.1)
                          : CustomTheme
                          .of(context)
                          .focusColor
                          .withOpacity(0.5),
                      width: 1.0),
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.transparent,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Container(
                          height: 40.0,
                          child: TextField(
                            enabled: !enableTrade,
                            controller: tppriceController,
                            keyboardType:
                            const TextInputType.numberWithOptions(
                                decimal: true),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                13.0,
                                Theme
                                    .of(context)
                                    .focusColor,
                                FontWeight.w500,
                                'FontRegular'),
                            onChanged: (value) {
                              setState(() {
                                price = "0.0";
                                // price = value.toString();
                                tradeAmount = "0.00";

                                // if (tppriceController.text.isNotEmpty) {
                                //   double amount = double.parse(priceController.text);
                                //   price = priceController.text;
                                //   if (enableStopLimit) {
                                //     if (priceController.text.isNotEmpty &&
                                //         stopPriceController.text.isNotEmpty) {
                                //       if ((double.parse(priceController.text.toString()) >
                                //           double.parse(
                                //               stopPriceController.text.toString()))) {
                                //         takerFee = ((double.parse(
                                //             priceController.text.toString()) *
                                //             double.parse(amountController.text
                                //                 .toString()) *
                                //             double.parse(
                                //                 takerFeeValue.toString())) /
                                //             100)
                                //             .toStringAsFixed(decimal_val);
                                //
                                //         totalAmount = (double.parse(
                                //             amountController.text.toString()) *
                                //             double.parse(
                                //                 priceController.text.toString()))
                                //             .toStringAsFixed(decimal_val);
                                //
                                //       } else {
                                //         takerFee = ((double.parse(stopPriceController.text
                                //             .toString()) *
                                //             double.parse(amountController.text
                                //                 .toString()) *
                                //             double.parse(
                                //                 takerFeeValue.toString())) /
                                //             100)
                                //             .toStringAsFixed(decimal_val);
                                //
                                //         totalAmount = (double.parse(
                                //             amountController.text.toString()) *
                                //             double.parse(
                                //                 stopPriceController.text.toString()))
                                //             .toStringAsFixed(decimal_val);
                                //
                                //
                                //       }
                                //     }
                                //   } else {
                                //     if (priceController.text.isNotEmpty) {
                                //       if (!buySell) {
                                //         takerFee = ((amount *
                                //             double.parse(
                                //                 priceController.text.toString()) *
                                //             double.parse(
                                //                 takerFeeValue.toString())) /
                                //             100)
                                //             .toStringAsFixed(decimal_val);
                                //
                                //         totalAmount = (double.parse(
                                //             amountController.text.toString()) *
                                //             double.parse(
                                //                 priceController.text.toString()))
                                //             .toStringAsFixed(decimal_val);
                                //       } else {
                                //         totalAmount = (double.parse(
                                //             amountController.text.toString()) *
                                //             double.parse(
                                //                 priceController.text.toString()))
                                //             .toStringAsFixed(decimal_val);
                                //       }
                                //     }
                                //   }
                                //
                                // } else {
                                //   tradeAmount = "0.00";
                                //   totalAmount = "0.00";
                                // }
                              });
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 8.0),
                                hintText: "TP trigger price",
                                hintStyle: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.5),
                                    FontWeight.w500,
                                    'FontRegular'),
                                border: InputBorder.none),
                            textAlign: TextAlign.start,
                          ),
                        )),
                    // InkWell(
                    //   onTap: () {
                    //     if (enableTrade) {
                    //     } else {
                    //       setState(() {
                    //         if (priceController.text.isNotEmpty) {
                    //           double amount = double.parse(priceController.text);
                    //           if (amount > 0) {
                    //             amount = amount - 0.01;
                    //             priceController.text = amount.toStringAsFixed(2);
                    //             tradeAmount = priceController.text;
                    //             if (enableStopLimit) {
                    //               if (stopPriceController.text.isNotEmpty &&
                    //                   priceController.text.isNotEmpty) {
                    //                 if ((double.parse(
                    //                         priceController.text.toString()) >
                    //                     double.parse(
                    //                         stopPriceController.text.toString()))) {
                    //                   takerFee =
                    //                       ((double.parse(priceController.text
                    //                                       .toString()) *
                    //                                   double.parse(amountController
                    //                                       .text
                    //                                       .toString()) *
                    //                                   double.parse(
                    //                                       takerFeeValue.toString())) /
                    //                               100)
                    //                           .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                   /*  totalAmount = ((double.parse(
                    //                       priceController.text
                    //                           .toString()) *
                    //                       double.parse(amountController
                    //                           .text
                    //                           .toString())) -
                    //                       double.parse(takerFee))
                    //                       .toStringAsFixed(decimal_val);*/
                    //                 } else {
                    //                   takerFee = ((double.parse(stopPriceController
                    //                                   .text
                    //                                   .toString()) *
                    //                               double.parse(amountController.text
                    //                                   .toString()) *
                    //                               double.parse(
                    //                                   takerFeeValue.toString())) /
                    //                           100)
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(livePrice))
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   /*totalAmount = ((double.parse(
                    //                       stopPriceController.text
                    //                           .toString()) *
                    //                       double.parse(amountController
                    //                           .text
                    //                           .toString())) -
                    //                       double.parse(takerFee))
                    //                       .toStringAsFixed(decimal_val);*/
                    //                 }
                    //               }
                    //             } else {
                    //               if (priceController.text.isNotEmpty) {
                    //                 if (!buySell) {
                    //                   takerFee = ((amount *
                    //                               double.parse(priceController.text
                    //                                   .toString()) *
                    //                               double.parse(
                    //                                   takerFeeValue.toString())) /
                    //                           100)
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                 } else {
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                 }
                    //               }
                    //             }
                    //           }
                    //         } else {
                    //           priceController.text = "0.01";
                    //           tradeAmount = amountController.text;
                    //           totalAmount = "0.000";
                    //         }
                    //       });
                    //     }
                    //   },
                    //   child: Container(
                    //       height: 40.0,
                    //       width: 35.0,
                    //       padding: const EdgeInsets.only(
                    //         left: 10.0,
                    //         right: 10.0,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: enableTrade
                    //             ? Theme.of(context).cardColor.withOpacity(0.2)
                    //             : CustomTheme.of(context).cardColor,
                    //         borderRadius: BorderRadius.circular(2),
                    //       ),
                    //       child: Center(
                    //         child: Text(
                    //           "-",
                    //           style: CustomWidget(context: context)
                    //               .CustomSizedTextStyle(
                    //                   20.0,
                    //                   enableTrade
                    //                       ? Theme.of(context)
                    //                           .cardColor
                    //                           .withOpacity(0.5)
                    //                       : Theme.of(context).focusColor,
                    //                   FontWeight.w500,
                    //                   'FontRegular'),
                    //         ),
                    //       )),
                    // ),
                    const SizedBox(
                      width: 2.0,
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     if (enableTrade) {
                    //     } else {
                    //       setState(() {
                    //         if (priceController.text.isNotEmpty) {
                    //           double amount = double.parse(priceController.text);
                    //           if (amount >= 0) {
                    //             amount = amount + 0.01;
                    //             priceController.text = amount.toStringAsFixed(2);
                    //             tradeAmount = priceController.text;
                    //             if (enableStopLimit) {
                    //               if (stopPriceController.text.isNotEmpty &&
                    //                   priceController.text.isNotEmpty) {
                    //                 if ((double.parse(
                    //                         priceController.text.toString()) >
                    //                     double.parse(
                    //                         stopPriceController.text.toString()))) {
                    //                   takerFee =
                    //                       ((double.parse(priceController.text
                    //                                       .toString()) *
                    //                                   double.parse(amountController
                    //                                       .text
                    //                                       .toString()) *
                    //                                   double.parse(
                    //                                       takerFeeValue.toString())) /
                    //                               100)
                    //                           .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                   /*  totalAmount = ((double.parse(
                    //                       priceController.text
                    //                           .toString()) *
                    //                       double.parse(amountController
                    //                           .text
                    //                           .toString())) -
                    //                       double.parse(takerFee))
                    //                       .toStringAsFixed(decimal_val);*/
                    //                 } else {
                    //                   takerFee = ((double.parse(stopPriceController
                    //                                   .text
                    //                                   .toString()) *
                    //                               double.parse(amountController.text
                    //                                   .toString()) *
                    //                               double.parse(
                    //                                   takerFeeValue.toString())) /
                    //                           100)
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(livePrice))
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   /*totalAmount = ((double.parse(
                    //                       stopPriceController.text
                    //                           .toString()) *
                    //                       double.parse(amountController
                    //                           .text
                    //                           .toString())) -
                    //                       double.parse(takerFee))
                    //                       .toStringAsFixed(decimal_val);*/
                    //                 }
                    //               }
                    //             } else {
                    //               if (priceController.text.isNotEmpty) {
                    //                 if (!buySell) {
                    //                   takerFee = ((amount *
                    //                               double.parse(priceController.text
                    //                                   .toString()) *
                    //                               double.parse(
                    //                                   takerFeeValue.toString())) /
                    //                           100)
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                 } else {
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                 }
                    //               }
                    //             }
                    //           }
                    //         } else {
                    //           priceController.text = "0.01";
                    //           tradeAmount = amountController.text;
                    //           totalAmount = "0.000";
                    //         }
                    //       });
                    //     }
                    //   },
                    //   child: Container(
                    //       height: 40.0,
                    //       width: 35.0,
                    //       padding: const EdgeInsets.only(
                    //         left: 10.0,
                    //         right: 10.0,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: enableTrade
                    //             ? Theme.of(context).cardColor.withOpacity(0.2)
                    //             : CustomTheme.of(context).cardColor,
                    //         borderRadius: BorderRadius.circular(2),
                    //       ),
                    //       child: Center(
                    //         child: Text(
                    //           "+",
                    //           style: CustomWidget(context: context)
                    //               .CustomSizedTextStyle(
                    //                   20.0,
                    //                   enableTrade
                    //                       ? Theme.of(context)
                    //                           .cardColor
                    //                           .withOpacity(0.2)
                    //                       : Theme.of(context).focusColor,
                    //                   FontWeight.w500,
                    //                   'FontRegular'),
                    //         ),
                    //       )),
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: enableTrade
                          ? Theme
                          .of(context)
                          .focusColor
                          .withOpacity(0.1)
                          : CustomTheme
                          .of(context)
                          .focusColor
                          .withOpacity(0.5),
                      width: 1.0),
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.transparent,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Container(
                          height: 40.0,
                          child: TextField(
                            enabled: !enableTrade,
                            controller: slpriceController,
                            keyboardType:
                            const TextInputType.numberWithOptions(
                                decimal: true),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                13.0,
                                Theme
                                    .of(context)
                                    .focusColor,
                                FontWeight.w500,
                                'FontRegular'),
                            onChanged: (value) {
                              setState(() {
                                price = "0.0";
                                // price = value.toString();
                                tradeAmount = "0.00";

                                // if (tppriceController.text.isNotEmpty) {
                                //   double amount = double.parse(priceController.text);
                                //   price = priceController.text;
                                //   if (enableStopLimit) {
                                //     if (priceController.text.isNotEmpty &&
                                //         stopPriceController.text.isNotEmpty) {
                                //       if ((double.parse(priceController.text.toString()) >
                                //           double.parse(
                                //               stopPriceController.text.toString()))) {
                                //         takerFee = ((double.parse(
                                //             priceController.text.toString()) *
                                //             double.parse(amountController.text
                                //                 .toString()) *
                                //             double.parse(
                                //                 takerFeeValue.toString())) /
                                //             100)
                                //             .toStringAsFixed(decimal_val);
                                //
                                //         totalAmount = (double.parse(
                                //             amountController.text.toString()) *
                                //             double.parse(
                                //                 priceController.text.toString()))
                                //             .toStringAsFixed(decimal_val);
                                //
                                //       } else {
                                //         takerFee = ((double.parse(stopPriceController.text
                                //             .toString()) *
                                //             double.parse(amountController.text
                                //                 .toString()) *
                                //             double.parse(
                                //                 takerFeeValue.toString())) /
                                //             100)
                                //             .toStringAsFixed(decimal_val);
                                //
                                //         totalAmount = (double.parse(
                                //             amountController.text.toString()) *
                                //             double.parse(
                                //                 stopPriceController.text.toString()))
                                //             .toStringAsFixed(decimal_val);
                                //
                                //
                                //       }
                                //     }
                                //   } else {
                                //     if (priceController.text.isNotEmpty) {
                                //       if (!buySell) {
                                //         takerFee = ((amount *
                                //             double.parse(
                                //                 priceController.text.toString()) *
                                //             double.parse(
                                //                 takerFeeValue.toString())) /
                                //             100)
                                //             .toStringAsFixed(decimal_val);
                                //
                                //         totalAmount = (double.parse(
                                //             amountController.text.toString()) *
                                //             double.parse(
                                //                 priceController.text.toString()))
                                //             .toStringAsFixed(decimal_val);
                                //       } else {
                                //         totalAmount = (double.parse(
                                //             amountController.text.toString()) *
                                //             double.parse(
                                //                 priceController.text.toString()))
                                //             .toStringAsFixed(decimal_val);
                                //       }
                                //     }
                                //   }
                                //
                                // } else {
                                //   tradeAmount = "0.00";
                                //   totalAmount = "0.00";
                                // }
                              });
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 8.0),
                                hintText: "SL trigger price",
                                hintStyle: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.5),
                                    FontWeight.w500,
                                    'FontRegular'),
                                border: InputBorder.none),
                            textAlign: TextAlign.start,
                          ),
                        )),
                    // InkWell(
                    //   onTap: () {
                    //     if (enableTrade) {
                    //     } else {
                    //       setState(() {
                    //         if (priceController.text.isNotEmpty) {
                    //           double amount = double.parse(priceController.text);
                    //           if (amount > 0) {
                    //             amount = amount - 0.01;
                    //             priceController.text = amount.toStringAsFixed(2);
                    //             tradeAmount = priceController.text;
                    //             if (enableStopLimit) {
                    //               if (stopPriceController.text.isNotEmpty &&
                    //                   priceController.text.isNotEmpty) {
                    //                 if ((double.parse(
                    //                         priceController.text.toString()) >
                    //                     double.parse(
                    //                         stopPriceController.text.toString()))) {
                    //                   takerFee =
                    //                       ((double.parse(priceController.text
                    //                                       .toString()) *
                    //                                   double.parse(amountController
                    //                                       .text
                    //                                       .toString()) *
                    //                                   double.parse(
                    //                                       takerFeeValue.toString())) /
                    //                               100)
                    //                           .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                   /*  totalAmount = ((double.parse(
                    //                       priceController.text
                    //                           .toString()) *
                    //                       double.parse(amountController
                    //                           .text
                    //                           .toString())) -
                    //                       double.parse(takerFee))
                    //                       .toStringAsFixed(decimal_val);*/
                    //                 } else {
                    //                   takerFee = ((double.parse(stopPriceController
                    //                                   .text
                    //                                   .toString()) *
                    //                               double.parse(amountController.text
                    //                                   .toString()) *
                    //                               double.parse(
                    //                                   takerFeeValue.toString())) /
                    //                           100)
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(livePrice))
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   /*totalAmount = ((double.parse(
                    //                       stopPriceController.text
                    //                           .toString()) *
                    //                       double.parse(amountController
                    //                           .text
                    //                           .toString())) -
                    //                       double.parse(takerFee))
                    //                       .toStringAsFixed(decimal_val);*/
                    //                 }
                    //               }
                    //             } else {
                    //               if (priceController.text.isNotEmpty) {
                    //                 if (!buySell) {
                    //                   takerFee = ((amount *
                    //                               double.parse(priceController.text
                    //                                   .toString()) *
                    //                               double.parse(
                    //                                   takerFeeValue.toString())) /
                    //                           100)
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                 } else {
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                 }
                    //               }
                    //             }
                    //           }
                    //         } else {
                    //           priceController.text = "0.01";
                    //           tradeAmount = amountController.text;
                    //           totalAmount = "0.000";
                    //         }
                    //       });
                    //     }
                    //   },
                    //   child: Container(
                    //       height: 40.0,
                    //       width: 35.0,
                    //       padding: const EdgeInsets.only(
                    //         left: 10.0,
                    //         right: 10.0,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: enableTrade
                    //             ? Theme.of(context).cardColor.withOpacity(0.2)
                    //             : CustomTheme.of(context).cardColor,
                    //         borderRadius: BorderRadius.circular(2),
                    //       ),
                    //       child: Center(
                    //         child: Text(
                    //           "-",
                    //           style: CustomWidget(context: context)
                    //               .CustomSizedTextStyle(
                    //                   20.0,
                    //                   enableTrade
                    //                       ? Theme.of(context)
                    //                           .cardColor
                    //                           .withOpacity(0.5)
                    //                       : Theme.of(context).focusColor,
                    //                   FontWeight.w500,
                    //                   'FontRegular'),
                    //         ),
                    //       )),
                    // ),
                    const SizedBox(
                      width: 2.0,
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     if (enableTrade) {
                    //     } else {
                    //       setState(() {
                    //         if (priceController.text.isNotEmpty) {
                    //           double amount = double.parse(priceController.text);
                    //           if (amount >= 0) {
                    //             amount = amount + 0.01;
                    //             priceController.text = amount.toStringAsFixed(2);
                    //             tradeAmount = priceController.text;
                    //             if (enableStopLimit) {
                    //               if (stopPriceController.text.isNotEmpty &&
                    //                   priceController.text.isNotEmpty) {
                    //                 if ((double.parse(
                    //                         priceController.text.toString()) >
                    //                     double.parse(
                    //                         stopPriceController.text.toString()))) {
                    //                   takerFee =
                    //                       ((double.parse(priceController.text
                    //                                       .toString()) *
                    //                                   double.parse(amountController
                    //                                       .text
                    //                                       .toString()) *
                    //                                   double.parse(
                    //                                       takerFeeValue.toString())) /
                    //                               100)
                    //                           .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                   /*  totalAmount = ((double.parse(
                    //                       priceController.text
                    //                           .toString()) *
                    //                       double.parse(amountController
                    //                           .text
                    //                           .toString())) -
                    //                       double.parse(takerFee))
                    //                       .toStringAsFixed(decimal_val);*/
                    //                 } else {
                    //                   takerFee = ((double.parse(stopPriceController
                    //                                   .text
                    //                                   .toString()) *
                    //                               double.parse(amountController.text
                    //                                   .toString()) *
                    //                               double.parse(
                    //                                   takerFeeValue.toString())) /
                    //                           100)
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(livePrice))
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   /*totalAmount = ((double.parse(
                    //                       stopPriceController.text
                    //                           .toString()) *
                    //                       double.parse(amountController
                    //                           .text
                    //                           .toString())) -
                    //                       double.parse(takerFee))
                    //                       .toStringAsFixed(decimal_val);*/
                    //                 }
                    //               }
                    //             } else {
                    //               if (priceController.text.isNotEmpty) {
                    //                 if (!buySell) {
                    //                   takerFee = ((amount *
                    //                               double.parse(priceController.text
                    //                                   .toString()) *
                    //                               double.parse(
                    //                                   takerFeeValue.toString())) /
                    //                           100)
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                 } else {
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                 }
                    //               }
                    //             }
                    //           }
                    //         } else {
                    //           priceController.text = "0.01";
                    //           tradeAmount = amountController.text;
                    //           totalAmount = "0.000";
                    //         }
                    //       });
                    //     }
                    //   },
                    //   child: Container(
                    //       height: 40.0,
                    //       width: 35.0,
                    //       padding: const EdgeInsets.only(
                    //         left: 10.0,
                    //         right: 10.0,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: enableTrade
                    //             ? Theme.of(context).cardColor.withOpacity(0.2)
                    //             : CustomTheme.of(context).cardColor,
                    //         borderRadius: BorderRadius.circular(2),
                    //       ),
                    //       child: Center(
                    //         child: Text(
                    //           "+",
                    //           style: CustomWidget(context: context)
                    //               .CustomSizedTextStyle(
                    //                   20.0,
                    //                   enableTrade
                    //                       ? Theme.of(context)
                    //                           .cardColor
                    //                           .withOpacity(0.2)
                    //                       : Theme.of(context).focusColor,
                    //                   FontWeight.w500,
                    //                   'FontRegular'),
                    //         ),
                    //       )),
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ) : Container(),
        spotOption?const SizedBox(height: 10,):SizedBox(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Available",
              style: CustomWidget(context: context).CustomSizedTextStyle(
                  12.0,
                  Theme
                      .of(context)
                      .focusColor
                      .withOpacity(0.5),
                  FontWeight.w500,
                  'FontRegular'),
            ),
            Text(
              double.parse(balance.isNotEmpty?balance:"0.0").toStringAsFixed(5).toString()+"" " ${buySell==true?firstCoin:secondCoin}",
              style: CustomWidget(context: context).CustomSizedTextStyle(11.5,
                  Theme
                      .of(context)
                      .focusColor, FontWeight.w500, 'FontRegular'),
            ),
          ],
        ),
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       "Available",
        //       style: CustomWidget(context: context).CustomSizedTextStyle(
        //           12.0,
        //           Theme
        //               .of(context)
        //               .focusColor
        //               .withOpacity(0.5),
        //           FontWeight.w500,
        //           'FontRegular'),
        //     ),
        //     Text(
        //       double.parse(tbalance.isNotEmpty?tbalance:"0.0").toStringAsFixed(4).toString()+"" " ${buySell==true?firstCoin:secondCoin}",
        //       style: CustomWidget(context: context).CustomSizedTextStyle(
        //           11.5,
        //           Theme
        //               .of(context)
        //               .focusColor,
        //           FontWeight.w500,
        //           'FontRegular'),
        //     ),
        //   ],
        // ),
        // SizedBox(
        //   height: 5.0,
        // ),
        // SizedBox(
        //   height: 5.0,
        // ),
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       "Maxbuy",
        //       style: CustomWidget(context: context).CustomSizedTextStyle(
        //           12.0,
        //           Theme
        //               .of(context)
        //               .focusColor
        //               .withOpacity(0.5),
        //           FontWeight.w500,
        //           'FontRegular'),
        //     ),
        //     priceController.text.isNotEmpty?Text(
        //       (((double.parse(balance) * 100) /
        //           double.parse(priceController.text)) /
        //           100).toStringAsFixed(4),
        //       style: CustomWidget(context: context).CustomSizedTextStyle(
        //           11.5,
        //           Theme
        //               .of(context)
        //               .focusColor,
        //           FontWeight.w500,
        //           'FontRegular'),
        //     ):Text(""),
        //
        //   ],
        // ),
        // SizedBox(
        //   height: 5.0,
        // ),
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       "Minbuy Qty",
        //       style: CustomWidget(context: context).CustomSizedTextStyle(
        //           12.0,
        //           Theme
        //               .of(context)
        //               .focusColor
        //               .withOpacity(0.5),
        //           FontWeight.w500,
        //           'FontRegular'),
        //     ),
        //     Text(
        //       minimumbuy,
        //       style: CustomWidget(context: context).CustomSizedTextStyle(
        //           11.5,
        //           Theme
        //               .of(context)
        //               .focusColor,
        //           FontWeight.w500,
        //           'FontRegular'),
        //     ),
        //   ],
        // ),
        // SizedBox(
        //   height: 5.0,
        // ),
        spotOption?const SizedBox(height: 10,):SizedBox(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Live Price",
              style: CustomWidget(context: context).CustomSizedTextStyle(12.0,
                  Theme
                      .of(context)
                      .focusColor, FontWeight.bold, 'FontRegular'),
            ),
            Text(
              livePrice,
              style: CustomWidget(context: context).CustomSizedTextStyle(11.5,
                  Theme
                      .of(context)
                      .focusColor, FontWeight.w500, 'FontRegular'),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: CustomTheme
                    .of(context)
                    .focusColor
                    .withOpacity(0.5),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              child: Text(
                totalAmount,
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    13.0,
                    Theme
                        .of(context)
                        .focusColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        InkWell(
          onTap: () {
            setState(() {
              if (enableTrade) {
                if (amountController.text.isNotEmpty) {
                  if (tpslCheck) {
                    if (tppriceController.text.isNotEmpty) {
                      if (slpriceController.text.isNotEmpty) {
                        if (double.parse(balance) >=
                            double.parse(totalAmount)) {
                          if (traderType == "user") {
                            loading = true;
                            tradeDetails();
                          } else {
                            loading = true;
                            massTradeDetails();
                          }
                        }
                        else {
                          CustomWidget(context: context).showSuccessAlertDialog(
                              "Trade", "Insufficient Balance", "error");
                        }
                      } else {
                        CustomWidget(context: context).showSuccessAlertDialog(
                            "Trade", "Enter Stop Loss Price", "error");
                      }
                    } else {
                      CustomWidget(context: context).showSuccessAlertDialog(
                          "Trade", "Enter Take Profit Price", "error");
                    }
                  }
                  else if (double.parse(balance) >= double.parse(totalAmount)) {
                    if (traderType == "user") {
                      loading = true;
                      tradeDetails();
                    } else {
                      loading = true;
                      massTradeDetails();
                    }
                  }
                  else {
                    CustomWidget(context: context).showSuccessAlertDialog(
                        "Trade", "Insufficient Balance", "error");
                  }
                } else {
                  CustomWidget(context: context).showSuccessAlertDialog(
                      "Trade", "Enter Trade Quantity", "error");
                }
              } else {
                if (priceController.text.isNotEmpty) {
                  if (amountController.text.isNotEmpty) {
                    if (tpslCheck) {
                      if (tppriceController.text.isNotEmpty) {
                        if (slpriceController.text.isNotEmpty) {
                          if (double.parse(balance) >= double.parse(
                              totalAmount)) {
                            if (traderType == "user") {
                              print("trade type$tradeType");
                              loading = true;
                              tradeDetails();
                            } else {
                              loading = true;
                              massTradeDetails();
                            }
                          }
                          else {
                            CustomWidget(context: context)
                                .showSuccessAlertDialog(
                                "Trade", "Insufficient Balance", "error");
                          }
                        } else {
                          CustomWidget(context: context).showSuccessAlertDialog(
                              "Trade", "Enter Stop Loss Price", "error");
                        }
                      } else {
                        CustomWidget(context: context).showSuccessAlertDialog(
                            "Trade", "Enter Take Profit Price", "error");
                      }
                    }
                    else
                    if (double.parse(balance) >= double.parse(totalAmount)) {
                      if (traderType == "user") {
                        print("trade type1${tradeType}");
                        loading = true;
                        tradeDetails();
                      } else {
                        loading = true;
                        massTradeDetails();
                      }
                    }
                    else {
                      CustomWidget(context: context).showSuccessAlertDialog(
                          "Trade", "Insufficient Balance", "error");
                    }
                  } else {
                    CustomWidget(context: context).showSuccessAlertDialog(
                        "Trade", "Enter Trade Quantity", "error");
                  }
                } else {
                  CustomWidget(context: context).showSuccessAlertDialog(
                      "Trade", "Enter Trade Price", "error");
                }
              }

                loading=true;


              buySell?getBalance(firstCoin):getBalance(secondCoin);
            });
          },
          child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: buySell
                    ? CustomTheme
                    .of(context)
                    .indicatorColor
                    : CustomTheme
                    .of(context)
                    .hoverColor,
              ),
              child: Center(
                child: Text(
                  buySell
                      ? AppLocalizations.instance.text("loc_sell_trade_txt5")+ " "+firstCoin
                      : AppLocalizations.instance.text("loc_sell_trade_txt6") + " "+secondCoin,
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      14.0,
                      Theme
                          .of(context)
                          .cardColor,
                      FontWeight.w600,
                      'FontRegular'),
                ),
              )),
        ),
        SizedBox(
          height: 5.0,
        ),
      ],
    );
  }

  Widget FutureOrderWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: CustomTheme.of(context).focusColor.withOpacity(0.8),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      buySell = true;
                      futurelong = true;
                    });
                    setState(() {
                      amountController.clear();
                      priceController.clear();
                      stopPriceController.clear();
                      totalAmount = "0.0";
                      _currentSliderValue = 0;
                      tleverageVal = "1";


                      // loading = true;
                      FuturefirstCoin =
                          futureselectPair!.symbol.toString();
                      FuturesecondCoin =
                          futureselectPair!.symbol.toString();
                      loading=true;
                      getBalance("USDT");
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          color: buySell
                              ? CustomTheme
                              .of(context)
                              .indicatorColor
                              : Colors.transparent),
                      child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0,left: 2.0),
                            child: Text(
                              "Open",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  13.0,
                                  buySell
                                      ? CustomTheme
                                      .of(context)
                                      .focusColor
                                      : CustomTheme
                                      .of(context)
                                      .focusColor
                                      .withOpacity(0.5),
                                  FontWeight.w500,
                                  'FontRegular'),
                            ),
                          ))),
                ),
              ),
              Flexible(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        buySell = false;
                      });
                      // print("Test");
                      setState(() {
                        buySell = false;
                        amountController.clear();
                        priceController.clear();
                        stopPriceController.clear();
                        totalAmount = "0.0";
                        _currentSliderValue = 0;
                        tleverageVal = "1";
                        FuturefirstCoin =
                            futureselectPair!.symbol.toString();
                        FuturesecondCoin =
                            futureselectPair!.symbol.toString();
                        loading=true;

                        getBalance("USDT");
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                            color: !buySell
                                ? CustomTheme
                                .of(context)
                                .hoverColor
                                : Colors.transparent),
                        child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: Text(
                                "Close",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    13.0,
                                    !buySell
                                        ? CustomTheme
                                        .of(context)
                                        .focusColor
                                        : CustomTheme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.5),
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                            ))),
                  ))
            ],
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Container(
          decoration: BoxDecoration(
            // border: Border.all(
            //     color: CustomTheme.of(context).focusColor.withOpacity(0.3),
            //     width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      futurelong = true;
                      amountController.clear();
                      priceController.clear();
                      stopPriceController.clear();
                      totalAmount = "0.0";
                      _currentSliderValue = 0;
                      tleverageVal = "1";
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          color: futurelong
                              ? CustomTheme
                              .of(context)
                              .indicatorColor
                              : Colors.transparent),
                      child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text(
                              "Long",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  13.0,
                                  futurelong
                                      ? CustomTheme
                                      .of(context)
                                      .focusColor
                                      : CustomTheme
                                      .of(context)
                                      .focusColor
                                      .withOpacity(0.5),
                                  FontWeight.w500,
                                  'FontRegular'),
                            ),
                          ))),
                ),
              ),
              Flexible(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        futurelong = false;

                        amountController.clear();
                        priceController.clear();
                        stopPriceController.clear();
                        totalAmount = "0.0";
                        _currentSliderValue = 0;
                        tleverageVal = "1";
                        // getCoinDetailsList(selectPair!.id.toString());
                        FuturefirstCoin =
                            futureselectPair!.symbol.toString();
                        FuturefirstCoin =
                            futureselectPair!.symbol.toString();
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                            color: !futurelong
                                ? CustomTheme
                                .of(context)
                                .hoverColor
                                : Colors.transparent),
                        child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: Text(
                                "Short",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    13.0,
                                    !futurelong
                                        ? CustomTheme
                                        .of(context)
                                        .focusColor
                                        : CustomTheme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.5),
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                            ))),
                  ))
            ],
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 35.0,
          padding: EdgeInsets.fromLTRB(5, 0.0, 5, 0.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: CustomTheme
                    .of(context)
                    .focusColor
                    .withOpacity(0.5),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: CustomTheme
                  .of(context)
                  .primaryColorLight,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                menuMaxHeight: MediaQuery
                    .of(context)
                    .size
                    .height * 0.7,
                items: chartFutureTime
                    .map((value) =>
                    DropdownMenuItem(
                      child: Text(
                        value.toString(),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            10.0,
                            Theme
                                .of(context)
                                .focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                      value: value,
                    ))
                    .toList(),
                onChanged: (value) async {
                  setState(() {
                    selectedFutureTime = value.toString();
                    if (selectedFutureTime == "Limit Order") {
                      enableTrade = false;
                      _currentSliderValue = 0;
                      tleverageVal = "1";
                      enableStopLimit = false;
                      priceController.clear();
                      amountController.clear();
                      totalAmount = "0.00";
                    } else if (selectedFutureTime == "Market Order") {
                      priceController.clear();
                      _currentSliderValue = 0;
                      tleverageVal = "1";
                      amountController.clear();
                      enableStopLimit = false;
                      totalAmount = "0.00";
                      enableTrade = true;
                    } else {
                      enableStopLimit = true;
                      _currentSliderValue = 0;
                      tleverageVal = "1";
                      priceController.clear();
                      amountController.clear();
                      stopPriceController.clear();
                      totalAmount = "0.00";
                      enableTrade = false;
                    }
                  });
                },
                hint: Text(
                  "Select Category",
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      12.0,
                      Theme
                          .of(context)
                          .focusColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
                isExpanded: true,
                value: selectedTime,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Theme
                      .of(context)
                      .focusColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 35.0,
          padding: EdgeInsets.fromLTRB(5, 0.0, 5, 0.0),
          decoration: BoxDecoration(
            border: Border.all(
                color:
                CustomTheme
                    .of(context)
                    .focusColor
                    .withOpacity(0.5),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: CustomTheme
                  .of(context)
                  .primaryColorLight,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                menuMaxHeight: MediaQuery
                    .of(context)
                    .size
                    .height * 0.7,
                items: !futureOption
                    ? tradeType
                    .map((value) =>
                    DropdownMenuItem(
                      child: Text(
                        value.toString(),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            10.0,
                            Theme
                                .of(context)
                                .focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                      value: value,
                    ))
                    .toList()
                    : tradeType
                    .map((value) =>
                    DropdownMenuItem(
                      child: Text(
                        value.toString(),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            10.0,
                            Theme
                                .of(context)
                                .focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                      value: value,
                    ))
                    .toList(),
                onChanged: (value) async {
                  setState(() {
                    futureselectedHistoryTradeType = value.toString();
                  });
                },
                hint: Text(
                  "Select Category",
                  style: CustomWidget(context: context)
                      .CustomSizedTextStyle(
                      12.0,
                      Theme
                          .of(context)
                          .focusColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
                isExpanded: true,
                value: futureselectedHistoryTradeType,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Theme
                      .of(context)
                      .focusColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: enableTrade
                    ? Theme
                    .of(context)
                    .focusColor
                    .withOpacity(0.1)
                    : CustomTheme
                    .of(context)
                    .focusColor
                    .withOpacity(0.5),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Container(
                    height: 40.0,
                    child: TextField(
                      enabled: !enableTrade,
                      controller: priceController,
                      keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          13.0,
                          Theme
                              .of(context)
                              .focusColor,
                          FontWeight.w500,
                          'FontRegular'),
                      onChanged: (value) {
                        setState(() {
                          price = "0.0";
                          // price = value.toString();
                          tradeAmount = "0.00";

                          if (priceController.text.isNotEmpty) {
                            double amount = double.parse(priceController.text);
                            price = priceController.text;
                            if (enableStopLimit) {
                              if (priceController.text.isNotEmpty &&
                                  stopPriceController.text.isNotEmpty) {
                                if ((double.parse(
                                    priceController.text.toString()) >
                                    double.parse(
                                        stopPriceController.text.toString()))) {
                                  takerFee = ((double.parse(
                                      priceController.text.toString()) *
                                      double.parse(amountController.text
                                          .toString()) *
                                      double.parse(
                                          takerFeeValue.toString())) /
                                      100)
                                      .toStringAsFixed(decimal_val);

                                  totalAmount = (double.parse(
                                      amountController.text.toString()) *
                                      double.parse(
                                          priceController.text.toString()))
                                      .toStringAsFixed(decimal_val);
                                } else {
                                  takerFee =
                                      ((double.parse(stopPriceController.text
                                          .toString()) *
                                          double.parse(amountController.text
                                              .toString()) *
                                          double.parse(
                                              takerFeeValue.toString())) /
                                          100)
                                          .toStringAsFixed(decimal_val);

                                  totalAmount = (double.parse(
                                      amountController.text.toString()) *
                                      double.parse(
                                          stopPriceController.text.toString()))
                                      .toStringAsFixed(decimal_val);

                                  /*totalAmount = ((double.parse(
                                    stopPriceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(decimal_val);*/
                                }
                              }
                            } else {
                              if (priceController.text.isNotEmpty) {
                                if (!buySell) {
                                  takerFee = ((amount *
                                      double.parse(
                                          priceController.text.toString()) *
                                      double.parse(
                                          takerFeeValue.toString())) /
                                      100)
                                      .toStringAsFixed(decimal_val);

                                  totalAmount = (double.parse(
                                      amountController.text.toString()) *
                                      double.parse(
                                          priceController.text.toString()))
                                      .toStringAsFixed(decimal_val);
                                } else {
                                  totalAmount = (double.parse(
                                      amountController.text.toString()) *
                                      double.parse(
                                          priceController.text.toString()))
                                      .toStringAsFixed(decimal_val);
                                }
                              }
                            }
                          } else {
                            tradeAmount = "0.00";
                            totalAmount = "0.00";
                          }
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 8.0),
                          hintText: "Price",
                          hintStyle: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                              12.0,
                              Theme
                                  .of(context)
                                  .focusColor
                                  .withOpacity(0.5),
                              FontWeight.w500,
                              'FontRegular'),
                          border: InputBorder.none),
                      textAlign: TextAlign.start,
                    ),
                  )),
              InkWell(
                onTap: () {
                  if (enableTrade) {} else {
                    setState(() {
                      if (priceController.text.isNotEmpty) {
                        double amount = double.parse(priceController.text);
                        if (amount > 0) {
                          amount = amount - 0.01;
                          priceController.text = amount.toStringAsFixed(2);
                          tradeAmount = priceController.text;
                          if (enableStopLimit) {
                            if (stopPriceController.text.isNotEmpty &&
                                priceController.text.isNotEmpty) {
                              if ((double.parse(
                                  priceController.text.toString()) >
                                  double.parse(
                                      stopPriceController.text.toString()))) {
                                takerFee =
                                    ((double.parse(priceController.text
                                        .toString()) *
                                        double.parse(amountController
                                            .text
                                            .toString()) *
                                        double.parse(
                                            takerFeeValue.toString())) /
                                        100)
                                        .toStringAsFixed(decimal_val);

                                totalAmount = (double.parse(
                                    amountController.text.toString()) *
                                    double.parse(
                                        priceController.text.toString()))
                                    .toStringAsFixed(decimal_val);
                                /*  totalAmount = ((double.parse(
                                    priceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(decimal_val);*/
                              } else {
                                takerFee = ((double.parse(stopPriceController
                                    .text
                                    .toString()) *
                                    double.parse(amountController.text
                                        .toString()) *
                                    double.parse(
                                        takerFeeValue.toString())) /
                                    100)
                                    .toStringAsFixed(decimal_val);

                                totalAmount = (double.parse(
                                    amountController.text.toString()) *
                                    double.parse(livePrice))
                                    .toStringAsFixed(decimal_val);

                                /*totalAmount = ((double.parse(
                                    stopPriceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(decimal_val);*/
                              }
                            }
                          } else {
                            if (priceController.text.isNotEmpty) {
                              if (!buySell) {
                                takerFee = ((amount *
                                    double.parse(priceController.text
                                        .toString()) *
                                    double.parse(
                                        takerFeeValue.toString())) /
                                    100)
                                    .toStringAsFixed(decimal_val);

                                totalAmount = (double.parse(
                                    amountController.text.toString()) *
                                    double.parse(
                                        priceController.text.toString()))
                                    .toStringAsFixed(decimal_val);
                              } else {
                                totalAmount = (double.parse(
                                    amountController.text.toString()) *
                                    double.parse(
                                        priceController.text.toString()))
                                    .toStringAsFixed(decimal_val);
                              }
                            }
                          }
                        }
                      } else {
                        priceController.text = "0.01";
                        tradeAmount = amountController.text;
                        totalAmount = "0.000";
                      }
                    });
                  }
                },
                child: Container(
                    height: 40.0,
                    width: 35.0,
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: enableTrade
                          ? Theme
                          .of(context)
                          .cardColor
                          .withOpacity(0.2)
                          : CustomTheme
                          .of(context)
                          .cardColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Text(
                        "-",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            20.0,
                            enableTrade
                                ? Theme
                                .of(context)
                                .cardColor
                                .withOpacity(0.5)
                                : Theme
                                .of(context)
                                .focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                    )),
              ),
              const SizedBox(
                width: 2.0,
              ),
              InkWell(
                onTap: () {
                  if (enableTrade) {} else {
                    setState(() {
                      if (priceController.text.isNotEmpty) {
                        double amount = double.parse(priceController.text);
                        if (amount >= 0) {
                          amount = amount + 0.01;
                          priceController.text = amount.toStringAsFixed(2);
                          tradeAmount = priceController.text;
                          if (enableStopLimit) {
                            if (stopPriceController.text.isNotEmpty &&
                                priceController.text.isNotEmpty) {
                              if ((double.parse(
                                  priceController.text.toString()) >
                                  double.parse(
                                      stopPriceController.text.toString()))) {
                                takerFee =
                                    ((double.parse(priceController.text
                                        .toString()) *
                                        double.parse(amountController
                                            .text
                                            .toString()) *
                                        double.parse(
                                            takerFeeValue.toString())) /
                                        100)
                                        .toStringAsFixed(decimal_val);

                                totalAmount = (double.parse(
                                    amountController.text.toString()) *
                                    double.parse(
                                        priceController.text.toString()))
                                    .toStringAsFixed(decimal_val);
                                /*  totalAmount = ((double.parse(
                                    priceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(decimal_val);*/
                              } else {
                                takerFee = ((double.parse(stopPriceController
                                    .text
                                    .toString()) *
                                    double.parse(amountController.text
                                        .toString()) *
                                    double.parse(
                                        takerFeeValue.toString())) /
                                    100)
                                    .toStringAsFixed(decimal_val);

                                totalAmount = (double.parse(
                                    amountController.text.toString()) *
                                    double.parse(livePrice))
                                    .toStringAsFixed(decimal_val);

                                /*totalAmount = ((double.parse(
                                    stopPriceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(decimal_val);*/
                              }
                            }
                          } else {
                            if (priceController.text.isNotEmpty) {
                              if (!buySell) {
                                takerFee = ((amount *
                                    double.parse(priceController.text
                                        .toString()) *
                                    double.parse(
                                        takerFeeValue.toString())) /
                                    100)
                                    .toStringAsFixed(decimal_val);

                                totalAmount = (double.parse(
                                    amountController.text.toString()) *
                                    double.parse(
                                        priceController.text.toString()))
                                    .toStringAsFixed(decimal_val);
                              } else {
                                totalAmount = (double.parse(
                                    amountController.text.toString()) *
                                    double.parse(
                                        priceController.text.toString()))
                                    .toStringAsFixed(decimal_val);
                              }
                            }
                          }
                        }
                      } else {
                        priceController.text = "0.01";
                        tradeAmount = amountController.text;
                        totalAmount = "0.000";
                      }
                    });
                  }
                },
                child: Container(
                    height: 40.0,
                    width: 35.0,
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: enableTrade
                          ? Theme
                          .of(context)
                          .cardColor
                          .withOpacity(0.2)
                          : CustomTheme
                          .of(context)
                          .cardColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Text(
                        "+",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            20.0,
                            enableTrade
                                ? Theme
                                .of(context)
                                .cardColor
                                .withOpacity(0.2)
                                : Theme
                                .of(context)
                                .focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                    )),
              ),
            ],
          ),
        ),
        enableTrade
            ? Container()
            : const SizedBox(
          height: 5.0,
        ),
        SizedBox(
          height: 15.0,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: CustomTheme
                    .of(context)
                    .focusColor
                    .withOpacity(0.5),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Container(
                    height: 40.0,
                    child: TextField(
                      controller: amountController,
                      keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          13.0,
                          Theme
                              .of(context)
                              .focusColor,
                          FontWeight.w500,
                          'FontRegular'),
                      onChanged: (value) {
                        setState(() {
                          price = "0.0";
                          // price = value.toString();
                          totalAmount = "0.00";

                          if (enableTrade) {
                            if (amountController.text.isNotEmpty) {
                              totalAmount =
                                  (double.parse(
                                      amountController.text.toString()) *
                                      double.parse(livePrice))
                                      .toStringAsFixed(decimal_val);
                            }
                          } else {
                            if (amountController.text.isNotEmpty) {
                              double amount = double.parse(
                                  amountController.text);
                              if (amount >= 0) {
                                tradeAmount = amountController.text;
                                if (enableStopLimit) {
                                  if (stopPriceController.text.isNotEmpty &&
                                      priceController.text.isNotEmpty) {
                                    if ((double.parse(
                                        priceController.text.toString()) >
                                        double.parse(
                                            stopPriceController.text
                                                .toString()))) {
                                      takerFee =
                                          ((double.parse(priceController.text
                                              .toString()) *
                                              double.parse(amountController
                                                  .text
                                                  .toString()) *
                                              double.parse(takerFeeValue
                                                  .toString())) /
                                              100)
                                              .toStringAsFixed(decimal_val);

                                      totalAmount =
                                          (double.parse(amountController
                                              .text
                                              .toString()) *
                                              double.parse(
                                                  priceController.text
                                                      .toString()))
                                              .toStringAsFixed(decimal_val);
                                      /*  totalAmount = ((double.parse(
                                    priceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(decimal_val);*/
                                    } else {
                                      takerFee =
                                          ((double.parse(stopPriceController
                                              .text
                                              .toString()) *
                                              double.parse(amountController.text
                                                  .toString()) *
                                              double.parse(
                                                  takerFeeValue.toString())) /
                                              100)
                                              .toStringAsFixed(decimal_val);

                                      totalAmount =
                                          (double.parse(amountController
                                              .text
                                              .toString()) *
                                              double.parse(livePrice))
                                              .toStringAsFixed(decimal_val);

                                      /*totalAmount = ((double.parse(
                                    stopPriceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(decimal_val);*/
                                    }
                                  }
                                } else {
                                  if (priceController.text.isNotEmpty) {
                                    if (!buySell) {
                                      takerFee = ((amount *
                                          double.parse(priceController.text
                                              .toString()) *
                                          double.parse(
                                              takerFeeValue.toString())) /
                                          100)
                                          .toStringAsFixed(decimal_val);

                                      totalAmount =
                                          (double.parse(amountController
                                              .text
                                              .toString()) *
                                              double.parse(
                                                  priceController.text
                                                      .toString()))
                                              .toStringAsFixed(decimal_val);
                                    } else {
                                      totalAmount =
                                          (double.parse(amountController
                                              .text
                                              .toString()) *
                                              double.parse(
                                                  priceController.text
                                                      .toString()))
                                              .toStringAsFixed(decimal_val);
                                    }
                                  }
                                }
                              }
                            } else {
                              tradeAmount = amountController.text;
                              totalAmount = "0.000";
                            }
                          }
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 8.0),
                          hintText: "Quantity",
                          hintStyle: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                              12.0,
                              Theme
                                  .of(context)
                                  .focusColor
                                  .withOpacity(0.5),
                              FontWeight.w500,
                              'FontRegular'),
                          border: InputBorder.none),
                      textAlign: TextAlign.start,
                    ),
                  )),
              InkWell(
                onTap: () {
                  setState(() {
                    tradeAmount = "0.0";
                    totalAmount = "0.0";
                    if (enableTrade) {
                      if (amountController.text.isNotEmpty) {
                        double amount = double.parse(amountController.text);
                        if (amount > 0) {
                          amount = amount - 0.01;
                          amountController.text = amount.toStringAsFixed(2);
                          tradeAmount = amountController.text;
                          totalAmount =
                              (double.parse(amountController.text.toString()) *
                                  double.parse(livePrice))
                                  .toStringAsFixed(decimal_val);
                        }
                      } else {
                        totalAmount = "0.00";
                      }
                    } else {
                      if (amountController.text.isNotEmpty) {
                        double amount = double.parse(amountController.text);
                        if (amount > 0) {
                          amount = amount - 0.01;
                          amountController.text = amount.toStringAsFixed(2);
                          tradeAmount = amountController.text;
                          if (enableStopLimit) {
                            if (stopPriceController.text.isNotEmpty &&
                                priceController.text.isNotEmpty) {
                              if ((double.parse(
                                  priceController.text.toString()) >
                                  double.parse(
                                      stopPriceController.text.toString()))) {
                                takerFee =
                                    ((double.parse(priceController.text
                                        .toString()) *
                                        double.parse(amountController
                                            .text
                                            .toString()) *
                                        double.parse(
                                            takerFeeValue.toString())) /
                                        100)
                                        .toStringAsFixed(decimal_val);

                                totalAmount = (double.parse(
                                    amountController.text.toString()) *
                                    double.parse(
                                        priceController.text.toString()))
                                    .toStringAsFixed(decimal_val);
                                /*  totalAmount = ((double.parse(
                                    priceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(decimal_val);*/
                              } else {
                                takerFee = ((double.parse(stopPriceController
                                    .text
                                    .toString()) *
                                    double.parse(amountController.text
                                        .toString()) *
                                    double.parse(
                                        takerFeeValue.toString())) /
                                    100)
                                    .toStringAsFixed(decimal_val);

                                totalAmount = (double.parse(
                                    amountController.text.toString()) *
                                    double.parse(livePrice))
                                    .toStringAsFixed(decimal_val);

                                /*totalAmount = ((double.parse(
                                    stopPriceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(decimal_val);*/
                              }
                            }
                          } else {
                            if (priceController.text.isNotEmpty) {
                              if (!buySell) {
                                takerFee = ((amount *
                                    double.parse(priceController.text
                                        .toString()) *
                                    double.parse(
                                        takerFeeValue.toString())) /
                                    100)
                                    .toStringAsFixed(decimal_val);

                                totalAmount = (double.parse(
                                    amountController.text.toString()) *
                                    double.parse(
                                        priceController.text.toString()))
                                    .toStringAsFixed(decimal_val);
                              } else {
                                totalAmount = (double.parse(
                                    amountController.text.toString()) *
                                    double.parse(
                                        priceController.text.toString()))
                                    .toStringAsFixed(decimal_val);
                              }
                            }
                          }
                        }
                      } else {
                        amountController.text = "0.01";
                        tradeAmount = amountController.text;
                        totalAmount = "0.000";
                      }
                    }
                  });
                },
                child: Container(
                    height: 40.0,
                    width: 35.0,
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: CustomTheme
                          .of(context)
                          .cardColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Text(
                        "-",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            20.0,
                            Theme
                                .of(context)
                                .focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                    )),
              ),
              const SizedBox(
                width: 2.0,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    totalAmount = "0.000";
                    if (enableTrade) {
                      if (amountController.text.isNotEmpty) {
                        double amount = double.parse(amountController.text);
                        if (amount > 0) {
                          amount = amount + 0.01;
                          amountController.text = amount.toStringAsFixed(2);
                          tradeAmount = amountController.text;
                          totalAmount =
                              (double.parse(amountController.text.toString()) *
                                  double.parse(livePrice))
                                  .toStringAsFixed(decimal_val);
                        }
                      } else {
                        totalAmount = "0.00";
                      }
                    } else {
                      if (amountController.text.isNotEmpty) {
                        double amount = double.parse(amountController.text);
                        if (amount >= 0) {
                          amount = amount + 0.01;
                          amountController.text = amount.toStringAsFixed(2);
                          tradeAmount = amountController.text;
                          if (enableStopLimit) {
                            if (stopPriceController.text.isNotEmpty &&
                                priceController.text.isNotEmpty) {
                              if ((double.parse(
                                  priceController.text.toString()) >
                                  double.parse(
                                      stopPriceController.text.toString()))) {
                                takerFee =
                                    ((double.parse(priceController.text
                                        .toString()) *
                                        double.parse(amountController
                                            .text
                                            .toString()) *
                                        double.parse(
                                            takerFeeValue.toString())) /
                                        100)
                                        .toStringAsFixed(decimal_val);

                                totalAmount = (double.parse(
                                    amountController.text.toString()) *
                                    double.parse(
                                        priceController.text.toString()))
                                    .toStringAsFixed(decimal_val);
                                /*  totalAmount = ((double.parse(
                                    priceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(decimal_val);*/
                              } else {
                                takerFee = ((double.parse(stopPriceController
                                    .text
                                    .toString()) *
                                    double.parse(amountController.text
                                        .toString()) *
                                    double.parse(
                                        takerFeeValue.toString())) /
                                    100)
                                    .toStringAsFixed(decimal_val);

                                totalAmount = (double.parse(
                                    amountController.text.toString()) *
                                    double.parse(livePrice))
                                    .toStringAsFixed(decimal_val);

                                /*totalAmount = ((double.parse(
                                    stopPriceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(decimal_val);*/
                              }
                            }
                          } else {
                            if (priceController.text.isNotEmpty) {
                              if (!buySell) {
                                takerFee = ((amount *
                                    double.parse(priceController.text
                                        .toString()) *
                                    double.parse(
                                        takerFeeValue.toString())) /
                                    100)
                                    .toStringAsFixed(decimal_val);

                                totalAmount = (double.parse(
                                    amountController.text.toString()) *
                                    double.parse(
                                        priceController.text.toString()))
                                    .toStringAsFixed(decimal_val);
                              } else {
                                totalAmount = (double.parse(
                                    amountController.text.toString()) *
                                    double.parse(
                                        priceController.text.toString()))
                                    .toStringAsFixed(decimal_val);
                              }
                            }
                          }
                        }
                      } else {
                        amountController.text = "0.01";
                        tradeAmount = amountController.text;
                        totalAmount = "0.000";
                      }
                    }
                  });
                },
                child: Container(
                    height: 40.0,
                    width: 35.0,
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: CustomTheme
                          .of(context)
                          .cardColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Text(
                        "+",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            20.0,
                            Theme
                                .of(context)
                                .focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                    )),
              ),
            ],
          ),
        ),
        enableStopLimit
            ? SizedBox(
          height: 15.0,
        )
            : Container(),
        enableStopLimit
            ? Container(
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: enableTrade
                    ? Theme
                    .of(context)
                    .focusColor
                    .withOpacity(0.1)
                    : CustomTheme
                    .of(context)
                    .focusColor
                    .withOpacity(0.5),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Container(
                    height: 40.0,
                    child: TextField(
                      enabled: !enableTrade,
                      controller: stopPriceController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          13.0,
                          Theme
                              .of(context)
                              .focusColor,
                          FontWeight.w500,
                          'FontRegular'),
                      onChanged: (value) {
                        setState(() {
                          stopPrice = "0.0";
                          // price = value.toString();
                          tradeAmount = "0.00";

                          if (stopPriceController.text.isNotEmpty) {
                            stopPrice = stopPriceController.text;
                            tradeAmount = stopPriceController.text.toString();
                            if (amountController.text.isNotEmpty &&
                                priceController.text.isNotEmpty) {
                              if (!buySell) {
                                if ((double.parse(
                                    priceController.text.toString()) >
                                    double.parse(stopPriceController.text
                                        .toString()))) {
                                  takerFee =
                                      ((double.parse(priceController.text
                                          .toString()) *
                                          double.parse(
                                              amountController.text
                                                  .toString()) *
                                          double.parse(takerFeeValue
                                              .toString())) /
                                          100)
                                          .toStringAsFixed(decimal_val);

                                  totalAmount = (double.parse(priceController
                                      .text
                                      .toString()) *
                                      double.parse(amountController.text
                                          .toString()))
                                      .toStringAsFixed(decimal_val);
                                } else {
                                  takerFee = ((double.parse(
                                      stopPriceController.text
                                          .toString()) *
                                      double.parse(amountController
                                          .text
                                          .toString()) *
                                      double.parse(
                                          takerFeeValue.toString())) /
                                      100)
                                      .toStringAsFixed(decimal_val);

                                  totalAmount = (double.parse(
                                      stopPriceController.text
                                          .toString()) *
                                      double.parse(amountController.text
                                          .toString()))
                                      .toStringAsFixed(decimal_val);
                                }
                              } else {
                                if ((double.parse(
                                    priceController.text.toString()) >
                                    double.parse(stopPriceController.text
                                        .toString()))) {
                                  takerFee =
                                      ((double.parse(priceController.text
                                          .toString()) *
                                          double.parse(
                                              amountController.text
                                                  .toString()) *
                                          double.parse(takerFeeValue
                                              .toString())) /
                                          100)
                                          .toStringAsFixed(decimal_val);

                                  totalAmount = (double.parse(priceController
                                      .text
                                      .toString()) *
                                      double.parse(amountController.text
                                          .toString()))
                                      .toStringAsFixed(decimal_val);
                                  ;
                                } else {
                                  takerFee = ((double.parse(amountController
                                      .text
                                      .toString()) *
                                      double.parse(stopPriceController
                                          .text
                                          .toString()) *
                                      double.parse(
                                          takerFeeValue.toString())) /
                                      100)
                                      .toStringAsFixed(decimal_val);

                                  totalAmount = (double.parse(
                                      stopPriceController.text
                                          .toString()) *
                                      double.parse(amountController.text
                                          .toString()))
                                      .toStringAsFixed(decimal_val);
                                }
                              }
                            }
                          } else {
                            tradeAmount = "0.00";
                            totalAmount = "0.00";
                          }
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 8.0),
                          hintText: "Stop-Price",
                          hintStyle: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                              12.0,
                              Theme
                                  .of(context)
                                  .focusColor
                                  .withOpacity(0.5),
                              FontWeight.w500,
                              'FontRegular'),
                          border: InputBorder.none),
                      textAlign: TextAlign.start,
                    ),
                  )),
              InkWell(
                onTap: () {
                  if (enableTrade) {} else {
                    setState(() {
                      tradeAmount = "0.00";
                      if (stopPriceController.text.isNotEmpty) {
                        double amount =
                        double.parse(stopPriceController.text);

                        if (amount > 0) {
                          amount = amount - 0.01;
                          stopPriceController.text =
                              amount.toStringAsFixed(2);
                          stopPrice = stopPriceController.text;

                          if (amountController.text.isNotEmpty) {
                            tradeAmount =
                                amountController.text.toString();
                            takerFee = ((amount *
                                double.parse(amountController.text
                                    .toString()) *
                                double.parse(
                                    takerFeeValue.toString())) /
                                100)
                                .toStringAsFixed(decimal_val);

                            totalAmount = (double.parse(
                                stopPriceController.text
                                    .toString()) *
                                double.parse(
                                    amountController.text.toString()))
                                .toStringAsFixed(decimal_val);
                          } else {
                            totalAmount = "0.00";
                          }
                        } else {
                          stopPriceController.text = "0.01";
                          totalAmount = "0.00";
                        }
                      }
                    });
                  }
                },
                child: Container(
                    height: 40.0,
                    width: 35.0,
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: enableTrade
                          ? Theme
                          .of(context)
                          .cardColor
                          .withOpacity(0.2)
                          : CustomTheme
                          .of(context)
                          .cardColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Text(
                        "-",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            20.0,
                            enableTrade
                                ? Theme
                                .of(context)
                                .cardColor
                                .withOpacity(0.5)
                                : Theme
                                .of(context)
                                .focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                    )),
              ),
              const SizedBox(
                width: 2.0,
              ),
              InkWell(
                onTap: () {
                  if (enableTrade) {} else {
                    setState(() {
                      if (stopPriceController.text.isNotEmpty) {
                        double amount =
                        double.parse(stopPriceController.text);
                        if (amount >= 0) {
                          amount = amount + 0.01;
                          stopPriceController.text =
                              amount.toStringAsFixed(2);
                          stopPrice = stopPriceController.text;
                          if (amountController.text.isNotEmpty) {
                            takerFee = ((double.parse(amountController
                                .text
                                .toString()) *
                                double.parse(stopPriceController
                                    .text
                                    .toString()) *
                                double.parse(
                                    takerFeeValue.toString())) /
                                100)
                                .toStringAsFixed(decimal_val);

                            totalAmount = (double.parse(
                                stopPriceController.text
                                    .toString()) *
                                double.parse(
                                    amountController.text.toString()))
                                .toStringAsFixed(decimal_val);
                          } else {
                            // priceController.text = "0.01";
                            tradeAmount = "0.00";
                          }
                        }
                      } else {
                        stopPriceController.text = "0.01";
                        tradeAmount = "0.00";
                      }
                    });
                  }
                },
                child: Container(
                    height: 40.0,
                    width: 35.0,
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: enableTrade
                          ? Theme
                          .of(context)
                          .cardColor
                          .withOpacity(0.2)
                          : CustomTheme
                          .of(context)
                          .cardColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Text(
                        "+",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            20.0,
                            enableTrade
                                ? Theme
                                .of(context)
                                .cardColor
                                .withOpacity(0.2)
                                : Theme
                                .of(context)
                                .focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                    )),
              ),
            ],
          ),
        )
            : SizedBox(),
        Container(
          child: SliderTheme(
            data: SliderThemeData(
              valueIndicatorColor: CustomTheme
                  .of(context)
                  .indicatorColor,
              trackHeight: 1.0,
              activeTickMarkColor: CustomTheme
                  .of(context)
                  .focusColor,
              inactiveTickMarkColor:
              CustomTheme
                  .of(context)
                  .focusColor
                  .withOpacity(0.5),
              tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 4.0),
              trackShape: CustomTrackShape(),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
            ),
            child: Slider(
              value: _currentSliderValue,
              max: 100,
              divisions: 4,
              label: tleverageVal,
              inactiveColor:
              CustomTheme
                  .of(context)
                  .focusColor
                  .withOpacity(0.5),
              activeColor: buySell
                  ? CustomTheme
                  .of(context)
                  .indicatorColor
                  : CustomTheme
                  .of(context)
                  .hoverColor,
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                  if (_currentSliderValue > 0) {
                    _tLevSliderValue = _currentSliderValue.toInt();
                    print(_tLevSliderValue);
                    setState(() {
                      if (_tLevSliderValue == 25) {
                        tleverageVal = "25";
                      } else if (_tLevSliderValue == 50) {
                        tleverageVal = "50";
                      } else if (_tLevSliderValue == 75) {
                        tleverageVal = "75";
                      } else {
                        tleverageVal = "100";
                      }
                    });
                    int val = _currentSliderValue.toInt();
                    setState(() {
                      priceController.clear();
                      amountController.clear();
                      //if (spotOption) {
                        if (!enableTrade) {
                          priceController.text = livePrice;
                        }
                        if (double.parse(livePrice) > 0) {
                          print("urs");
                          if (buySell) {
                            double perce = ((double.parse(balance) * val) /
                                double.parse(priceController.text)) /
                                100;
print("hi$perce");
                            amountController.text =
                                double.parse(perce.toString())
                                    .toStringAsFixed(decimal_val);
                            double a = double.parse(perce
                                .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                            double b = double.parse(livePrice);
                            totalAmount = double.parse((a * b).toString())
                                .toStringAsFixed(decimal_val);
                          } else {
                            double perce = ((double.parse(balance) * val) * double.parse(priceController.text)) / 100;

                            amountController.text =
                                double.parse(perce.toString())
                                    .toStringAsFixed(decimal_val);
                            double a = double.parse(perce
                                .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                            double b = double.parse(livePrice);
                            totalAmount = double.parse((a / b).toString())
                                .toStringAsFixed(decimal_val);
                          }
                        }
                    //  }
                    });
                  } else {
                    amountController.text = "0.00";
                    if (!enableTrade) {
                      priceController.text = "0.00";
                    }
                    totalAmount = "0.00";
                  }
                });
              },
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              child: Transform.scale(
                scale: 0.8,
                child: Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  value: tpslCheck,
                  activeColor: Theme
                      .of(context)
                      .focusColor,
                  checkColor: Theme
                      .of(context)
                      .primaryColorDark,
                  onChanged: (bool? value) {
                    setState(() {
                      tpslCheck = value!;
                    });
                  },
                ),
              ),
              width: 18.0,
              height: 20.0,

            ),
            const SizedBox(
              width: 5.0,
            ),
            Flexible(child: RichText(
              text: TextSpan(
                text: 'TP/SL',
                style: CustomWidget(context: context)
                    .CustomSizedTextStyle(
                    12.0,
                    Theme
                        .of(context)
                        .disabledColor,
                    FontWeight.w400,
                    'FontRegular'),
              ),
            ),),
            //Checkbox
          ],
        ),
        const SizedBox(
          height: 5.0,
        ),
        tpslCheck ? Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: enableTrade
                          ? Theme
                          .of(context)
                          .focusColor
                          .withOpacity(0.1)
                          : CustomTheme
                          .of(context)
                          .focusColor
                          .withOpacity(0.5),
                      width: 1.0),
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.transparent,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Container(
                          height: 40.0,
                          child: TextField(
                            enabled: !enableTrade,
                            controller: tppriceController,
                            keyboardType:
                            const TextInputType.numberWithOptions(
                                decimal: true),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                13.0,
                                Theme
                                    .of(context)
                                    .focusColor,
                                FontWeight.w500,
                                'FontRegular'),
                            onChanged: (value) {
                              setState(() {
                                price = "0.0";
                                // price = value.toString();
                                tradeAmount = "0.00";

                                // if (tppriceController.text.isNotEmpty) {
                                //   double amount = double.parse(priceController.text);
                                //   price = priceController.text;
                                //   if (enableStopLimit) {
                                //     if (priceController.text.isNotEmpty &&
                                //         stopPriceController.text.isNotEmpty) {
                                //       if ((double.parse(priceController.text.toString()) >
                                //           double.parse(
                                //               stopPriceController.text.toString()))) {
                                //         takerFee = ((double.parse(
                                //             priceController.text.toString()) *
                                //             double.parse(amountController.text
                                //                 .toString()) *
                                //             double.parse(
                                //                 takerFeeValue.toString())) /
                                //             100)
                                //             .toStringAsFixed(decimal_val);
                                //
                                //         totalAmount = (double.parse(
                                //             amountController.text.toString()) *
                                //             double.parse(
                                //                 priceController.text.toString()))
                                //             .toStringAsFixed(decimal_val);
                                //
                                //       } else {
                                //         takerFee = ((double.parse(stopPriceController.text
                                //             .toString()) *
                                //             double.parse(amountController.text
                                //                 .toString()) *
                                //             double.parse(
                                //                 takerFeeValue.toString())) /
                                //             100)
                                //             .toStringAsFixed(decimal_val);
                                //
                                //         totalAmount = (double.parse(
                                //             amountController.text.toString()) *
                                //             double.parse(
                                //                 stopPriceController.text.toString()))
                                //             .toStringAsFixed(decimal_val);
                                //
                                //
                                //       }
                                //     }
                                //   } else {
                                //     if (priceController.text.isNotEmpty) {
                                //       if (!buySell) {
                                //         takerFee = ((amount *
                                //             double.parse(
                                //                 priceController.text.toString()) *
                                //             double.parse(
                                //                 takerFeeValue.toString())) /
                                //             100)
                                //             .toStringAsFixed(decimal_val);
                                //
                                //         totalAmount = (double.parse(
                                //             amountController.text.toString()) *
                                //             double.parse(
                                //                 priceController.text.toString()))
                                //             .toStringAsFixed(decimal_val);
                                //       } else {
                                //         totalAmount = (double.parse(
                                //             amountController.text.toString()) *
                                //             double.parse(
                                //                 priceController.text.toString()))
                                //             .toStringAsFixed(decimal_val);
                                //       }
                                //     }
                                //   }
                                //
                                // } else {
                                //   tradeAmount = "0.00";
                                //   totalAmount = "0.00";
                                // }
                              });
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 8.0),
                                hintText: "TP trigger price",
                                hintStyle: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.5),
                                    FontWeight.w500,
                                    'FontRegular'),
                                border: InputBorder.none),
                            textAlign: TextAlign.start,
                          ),
                        )),
                    // InkWell(
                    //   onTap: () {
                    //     if (enableTrade) {
                    //     } else {
                    //       setState(() {
                    //         if (priceController.text.isNotEmpty) {
                    //           double amount = double.parse(priceController.text);
                    //           if (amount > 0) {
                    //             amount = amount - 0.01;
                    //             priceController.text = amount.toStringAsFixed(2);
                    //             tradeAmount = priceController.text;
                    //             if (enableStopLimit) {
                    //               if (stopPriceController.text.isNotEmpty &&
                    //                   priceController.text.isNotEmpty) {
                    //                 if ((double.parse(
                    //                         priceController.text.toString()) >
                    //                     double.parse(
                    //                         stopPriceController.text.toString()))) {
                    //                   takerFee =
                    //                       ((double.parse(priceController.text
                    //                                       .toString()) *
                    //                                   double.parse(amountController
                    //                                       .text
                    //                                       .toString()) *
                    //                                   double.parse(
                    //                                       takerFeeValue.toString())) /
                    //                               100)
                    //                           .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                   /*  totalAmount = ((double.parse(
                    //                       priceController.text
                    //                           .toString()) *
                    //                       double.parse(amountController
                    //                           .text
                    //                           .toString())) -
                    //                       double.parse(takerFee))
                    //                       .toStringAsFixed(decimal_val);*/
                    //                 } else {
                    //                   takerFee = ((double.parse(stopPriceController
                    //                                   .text
                    //                                   .toString()) *
                    //                               double.parse(amountController.text
                    //                                   .toString()) *
                    //                               double.parse(
                    //                                   takerFeeValue.toString())) /
                    //                           100)
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(livePrice))
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   /*totalAmount = ((double.parse(
                    //                       stopPriceController.text
                    //                           .toString()) *
                    //                       double.parse(amountController
                    //                           .text
                    //                           .toString())) -
                    //                       double.parse(takerFee))
                    //                       .toStringAsFixed(decimal_val);*/
                    //                 }
                    //               }
                    //             } else {
                    //               if (priceController.text.isNotEmpty) {
                    //                 if (!buySell) {
                    //                   takerFee = ((amount *
                    //                               double.parse(priceController.text
                    //                                   .toString()) *
                    //                               double.parse(
                    //                                   takerFeeValue.toString())) /
                    //                           100)
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                 } else {
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                 }
                    //               }
                    //             }
                    //           }
                    //         } else {
                    //           priceController.text = "0.01";
                    //           tradeAmount = amountController.text;
                    //           totalAmount = "0.000";
                    //         }
                    //       });
                    //     }
                    //   },
                    //   child: Container(
                    //       height: 40.0,
                    //       width: 35.0,
                    //       padding: const EdgeInsets.only(
                    //         left: 10.0,
                    //         right: 10.0,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: enableTrade
                    //             ? Theme.of(context).cardColor.withOpacity(0.2)
                    //             : CustomTheme.of(context).cardColor,
                    //         borderRadius: BorderRadius.circular(2),
                    //       ),
                    //       child: Center(
                    //         child: Text(
                    //           "-",
                    //           style: CustomWidget(context: context)
                    //               .CustomSizedTextStyle(
                    //                   20.0,
                    //                   enableTrade
                    //                       ? Theme.of(context)
                    //                           .cardColor
                    //                           .withOpacity(0.5)
                    //                       : Theme.of(context).focusColor,
                    //                   FontWeight.w500,
                    //                   'FontRegular'),
                    //         ),
                    //       )),
                    // ),
                    const SizedBox(
                      width: 2.0,
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     if (enableTrade) {
                    //     } else {
                    //       setState(() {
                    //         if (priceController.text.isNotEmpty) {
                    //           double amount = double.parse(priceController.text);
                    //           if (amount >= 0) {
                    //             amount = amount + 0.01;
                    //             priceController.text = amount.toStringAsFixed(2);
                    //             tradeAmount = priceController.text;
                    //             if (enableStopLimit) {
                    //               if (stopPriceController.text.isNotEmpty &&
                    //                   priceController.text.isNotEmpty) {
                    //                 if ((double.parse(
                    //                         priceController.text.toString()) >
                    //                     double.parse(
                    //                         stopPriceController.text.toString()))) {
                    //                   takerFee =
                    //                       ((double.parse(priceController.text
                    //                                       .toString()) *
                    //                                   double.parse(amountController
                    //                                       .text
                    //                                       .toString()) *
                    //                                   double.parse(
                    //                                       takerFeeValue.toString())) /
                    //                               100)
                    //                           .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                   /*  totalAmount = ((double.parse(
                    //                       priceController.text
                    //                           .toString()) *
                    //                       double.parse(amountController
                    //                           .text
                    //                           .toString())) -
                    //                       double.parse(takerFee))
                    //                       .toStringAsFixed(decimal_val);*/
                    //                 } else {
                    //                   takerFee = ((double.parse(stopPriceController
                    //                                   .text
                    //                                   .toString()) *
                    //                               double.parse(amountController.text
                    //                                   .toString()) *
                    //                               double.parse(
                    //                                   takerFeeValue.toString())) /
                    //                           100)
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(livePrice))
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   /*totalAmount = ((double.parse(
                    //                       stopPriceController.text
                    //                           .toString()) *
                    //                       double.parse(amountController
                    //                           .text
                    //                           .toString())) -
                    //                       double.parse(takerFee))
                    //                       .toStringAsFixed(decimal_val);*/
                    //                 }
                    //               }
                    //             } else {
                    //               if (priceController.text.isNotEmpty) {
                    //                 if (!buySell) {
                    //                   takerFee = ((amount *
                    //                               double.parse(priceController.text
                    //                                   .toString()) *
                    //                               double.parse(
                    //                                   takerFeeValue.toString())) /
                    //                           100)
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                 } else {
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                 }
                    //               }
                    //             }
                    //           }
                    //         } else {
                    //           priceController.text = "0.01";
                    //           tradeAmount = amountController.text;
                    //           totalAmount = "0.000";
                    //         }
                    //       });
                    //     }
                    //   },
                    //   child: Container(
                    //       height: 40.0,
                    //       width: 35.0,
                    //       padding: const EdgeInsets.only(
                    //         left: 10.0,
                    //         right: 10.0,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: enableTrade
                    //             ? Theme.of(context).cardColor.withOpacity(0.2)
                    //             : CustomTheme.of(context).cardColor,
                    //         borderRadius: BorderRadius.circular(2),
                    //       ),
                    //       child: Center(
                    //         child: Text(
                    //           "+",
                    //           style: CustomWidget(context: context)
                    //               .CustomSizedTextStyle(
                    //                   20.0,
                    //                   enableTrade
                    //                       ? Theme.of(context)
                    //                           .cardColor
                    //                           .withOpacity(0.2)
                    //                       : Theme.of(context).focusColor,
                    //                   FontWeight.w500,
                    //                   'FontRegular'),
                    //         ),
                    //       )),
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: enableTrade
                          ? Theme
                          .of(context)
                          .focusColor
                          .withOpacity(0.1)
                          : CustomTheme
                          .of(context)
                          .focusColor
                          .withOpacity(0.5),
                      width: 1.0),
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.transparent,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Container(
                          height: 40.0,
                          child: TextField(
                            enabled: !enableTrade,
                            controller: slpriceController,
                            keyboardType:
                            const TextInputType.numberWithOptions(
                                decimal: true),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                13.0,
                                Theme
                                    .of(context)
                                    .focusColor,
                                FontWeight.w500,
                                'FontRegular'),
                            onChanged: (value) {
                              setState(() {
                                price = "0.0";
                                // price = value.toString();
                                tradeAmount = "0.00";

                                // if (tppriceController.text.isNotEmpty) {
                                //   double amount = double.parse(priceController.text);
                                //   price = priceController.text;
                                //   if (enableStopLimit) {
                                //     if (priceController.text.isNotEmpty &&
                                //         stopPriceController.text.isNotEmpty) {
                                //       if ((double.parse(priceController.text.toString()) >
                                //           double.parse(
                                //               stopPriceController.text.toString()))) {
                                //         takerFee = ((double.parse(
                                //             priceController.text.toString()) *
                                //             double.parse(amountController.text
                                //                 .toString()) *
                                //             double.parse(
                                //                 takerFeeValue.toString())) /
                                //             100)
                                //             .toStringAsFixed(decimal_val);
                                //
                                //         totalAmount = (double.parse(
                                //             amountController.text.toString()) *
                                //             double.parse(
                                //                 priceController.text.toString()))
                                //             .toStringAsFixed(decimal_val);
                                //
                                //       } else {
                                //         takerFee = ((double.parse(stopPriceController.text
                                //             .toString()) *
                                //             double.parse(amountController.text
                                //                 .toString()) *
                                //             double.parse(
                                //                 takerFeeValue.toString())) /
                                //             100)
                                //             .toStringAsFixed(decimal_val);
                                //
                                //         totalAmount = (double.parse(
                                //             amountController.text.toString()) *
                                //             double.parse(
                                //                 stopPriceController.text.toString()))
                                //             .toStringAsFixed(decimal_val);
                                //
                                //
                                //       }
                                //     }
                                //   } else {
                                //     if (priceController.text.isNotEmpty) {
                                //       if (!buySell) {
                                //         takerFee = ((amount *
                                //             double.parse(
                                //                 priceController.text.toString()) *
                                //             double.parse(
                                //                 takerFeeValue.toString())) /
                                //             100)
                                //             .toStringAsFixed(decimal_val);
                                //
                                //         totalAmount = (double.parse(
                                //             amountController.text.toString()) *
                                //             double.parse(
                                //                 priceController.text.toString()))
                                //             .toStringAsFixed(decimal_val);
                                //       } else {
                                //         totalAmount = (double.parse(
                                //             amountController.text.toString()) *
                                //             double.parse(
                                //                 priceController.text.toString()))
                                //             .toStringAsFixed(decimal_val);
                                //       }
                                //     }
                                //   }
                                //
                                // } else {
                                //   tradeAmount = "0.00";
                                //   totalAmount = "0.00";
                                // }
                              });
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 8.0),
                                hintText: "SL trigger price",
                                hintStyle: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    12.0,
                                    Theme
                                        .of(context)
                                        .focusColor
                                        .withOpacity(0.5),
                                    FontWeight.w500,
                                    'FontRegular'),
                                border: InputBorder.none),
                            textAlign: TextAlign.start,
                          ),
                        )),
                    // InkWell(
                    //   onTap: () {
                    //     if (enableTrade) {
                    //     } else {
                    //       setState(() {
                    //         if (priceController.text.isNotEmpty) {
                    //           double amount = double.parse(priceController.text);
                    //           if (amount > 0) {
                    //             amount = amount - 0.01;
                    //             priceController.text = amount.toStringAsFixed(2);
                    //             tradeAmount = priceController.text;
                    //             if (enableStopLimit) {
                    //               if (stopPriceController.text.isNotEmpty &&
                    //                   priceController.text.isNotEmpty) {
                    //                 if ((double.parse(
                    //                         priceController.text.toString()) >
                    //                     double.parse(
                    //                         stopPriceController.text.toString()))) {
                    //                   takerFee =
                    //                       ((double.parse(priceController.text
                    //                                       .toString()) *
                    //                                   double.parse(amountController
                    //                                       .text
                    //                                       .toString()) *
                    //                                   double.parse(
                    //                                       takerFeeValue.toString())) /
                    //                               100)
                    //                           .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                   /*  totalAmount = ((double.parse(
                    //                       priceController.text
                    //                           .toString()) *
                    //                       double.parse(amountController
                    //                           .text
                    //                           .toString())) -
                    //                       double.parse(takerFee))
                    //                       .toStringAsFixed(decimal_val);*/
                    //                 } else {
                    //                   takerFee = ((double.parse(stopPriceController
                    //                                   .text
                    //                                   .toString()) *
                    //                               double.parse(amountController.text
                    //                                   .toString()) *
                    //                               double.parse(
                    //                                   takerFeeValue.toString())) /
                    //                           100)
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(livePrice))
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   /*totalAmount = ((double.parse(
                    //                       stopPriceController.text
                    //                           .toString()) *
                    //                       double.parse(amountController
                    //                           .text
                    //                           .toString())) -
                    //                       double.parse(takerFee))
                    //                       .toStringAsFixed(decimal_val);*/
                    //                 }
                    //               }
                    //             } else {
                    //               if (priceController.text.isNotEmpty) {
                    //                 if (!buySell) {
                    //                   takerFee = ((amount *
                    //                               double.parse(priceController.text
                    //                                   .toString()) *
                    //                               double.parse(
                    //                                   takerFeeValue.toString())) /
                    //                           100)
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                 } else {
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                 }
                    //               }
                    //             }
                    //           }
                    //         } else {
                    //           priceController.text = "0.01";
                    //           tradeAmount = amountController.text;
                    //           totalAmount = "0.000";
                    //         }
                    //       });
                    //     }
                    //   },
                    //   child: Container(
                    //       height: 40.0,
                    //       width: 35.0,
                    //       padding: const EdgeInsets.only(
                    //         left: 10.0,
                    //         right: 10.0,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: enableTrade
                    //             ? Theme.of(context).cardColor.withOpacity(0.2)
                    //             : CustomTheme.of(context).cardColor,
                    //         borderRadius: BorderRadius.circular(2),
                    //       ),
                    //       child: Center(
                    //         child: Text(
                    //           "-",
                    //           style: CustomWidget(context: context)
                    //               .CustomSizedTextStyle(
                    //                   20.0,
                    //                   enableTrade
                    //                       ? Theme.of(context)
                    //                           .cardColor
                    //                           .withOpacity(0.5)
                    //                       : Theme.of(context).focusColor,
                    //                   FontWeight.w500,
                    //                   'FontRegular'),
                    //         ),
                    //       )),
                    // ),
                    const SizedBox(
                      width: 2.0,
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     if (enableTrade) {
                    //     } else {
                    //       setState(() {
                    //         if (priceController.text.isNotEmpty) {
                    //           double amount = double.parse(priceController.text);
                    //           if (amount >= 0) {
                    //             amount = amount + 0.01;
                    //             priceController.text = amount.toStringAsFixed(2);
                    //             tradeAmount = priceController.text;
                    //             if (enableStopLimit) {
                    //               if (stopPriceController.text.isNotEmpty &&
                    //                   priceController.text.isNotEmpty) {
                    //                 if ((double.parse(
                    //                         priceController.text.toString()) >
                    //                     double.parse(
                    //                         stopPriceController.text.toString()))) {
                    //                   takerFee =
                    //                       ((double.parse(priceController.text
                    //                                       .toString()) *
                    //                                   double.parse(amountController
                    //                                       .text
                    //                                       .toString()) *
                    //                                   double.parse(
                    //                                       takerFeeValue.toString())) /
                    //                               100)
                    //                           .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                   /*  totalAmount = ((double.parse(
                    //                       priceController.text
                    //                           .toString()) *
                    //                       double.parse(amountController
                    //                           .text
                    //                           .toString())) -
                    //                       double.parse(takerFee))
                    //                       .toStringAsFixed(decimal_val);*/
                    //                 } else {
                    //                   takerFee = ((double.parse(stopPriceController
                    //                                   .text
                    //                                   .toString()) *
                    //                               double.parse(amountController.text
                    //                                   .toString()) *
                    //                               double.parse(
                    //                                   takerFeeValue.toString())) /
                    //                           100)
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(livePrice))
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   /*totalAmount = ((double.parse(
                    //                       stopPriceController.text
                    //                           .toString()) *
                    //                       double.parse(amountController
                    //                           .text
                    //                           .toString())) -
                    //                       double.parse(takerFee))
                    //                       .toStringAsFixed(decimal_val);*/
                    //                 }
                    //               }
                    //             } else {
                    //               if (priceController.text.isNotEmpty) {
                    //                 if (!buySell) {
                    //                   takerFee = ((amount *
                    //                               double.parse(priceController.text
                    //                                   .toString()) *
                    //                               double.parse(
                    //                                   takerFeeValue.toString())) /
                    //                           100)
                    //                       .toStringAsFixed(decimal_val);
                    //
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                 } else {
                    //                   totalAmount = (double.parse(
                    //                               amountController.text.toString()) *
                    //                           double.parse(
                    //                               priceController.text.toString()))
                    //                       .toStringAsFixed(decimal_val);
                    //                 }
                    //               }
                    //             }
                    //           }
                    //         } else {
                    //           priceController.text = "0.01";
                    //           tradeAmount = amountController.text;
                    //           totalAmount = "0.000";
                    //         }
                    //       });
                    //     }
                    //   },
                    //   child: Container(
                    //       height: 40.0,
                    //       width: 35.0,
                    //       padding: const EdgeInsets.only(
                    //         left: 10.0,
                    //         right: 10.0,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: enableTrade
                    //             ? Theme.of(context).cardColor.withOpacity(0.2)
                    //             : CustomTheme.of(context).cardColor,
                    //         borderRadius: BorderRadius.circular(2),
                    //       ),
                    //       child: Center(
                    //         child: Text(
                    //           "+",
                    //           style: CustomWidget(context: context)
                    //               .CustomSizedTextStyle(
                    //                   20.0,
                    //                   enableTrade
                    //                       ? Theme.of(context)
                    //                           .cardColor
                    //                           .withOpacity(0.2)
                    //                       : Theme.of(context).focusColor,
                    //                   FontWeight.w500,
                    //                   'FontRegular'),
                    //         ),
                    //       )),
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ) : Container(),
        Container(
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: CustomTheme
                    .of(context)
                    .focusColor
                    .withOpacity(0.5),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              child: Text(
                totalAmount,
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    13.0,
                    Theme
                        .of(context)
                        .focusColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        InkWell(
          onTap: () {
            setState(() {
              if (enableTrade) {
                if (amountController.text.isNotEmpty) {
                  if (double.parse(balance) >= double.parse(totalAmount)) {
                    if (traderType == "user") {
                      loading = true;
                      tradeDetails();
                    } else {
                      loading = true;
                      massTradeDetails();
                    }
                  } else {
                    CustomWidget(context: context).showSuccessAlertDialog(
                        "Trade", "Insufficienqqt Balance", "error");
                  }
                } else {
                  CustomWidget(context: context).showSuccessAlertDialog(
                      "Trade", "Enter Trade Quantity", "error");
                }
              } else {
                if (priceController.text.isNotEmpty) {
                  if (amountController.text.isNotEmpty) {
                    if (double.parse(balance) >= double.parse(totalAmount)) {
                      if (traderType == "user") {
                        loading = true;
                        tradeDetails();
                      } else {
                        loading = true;
                        massTradeDetails();
                      }
                    } else {
                      CustomWidget(context: context).showSuccessAlertDialog(
                          "Trade", "Insufficient Balance", "error");
                    }
                  } else {
                    CustomWidget(context: context).showSuccessAlertDialog(
                        "Trade", "Enter Trade Quantity", "error");
                  }
                } else {
                  CustomWidget(context: context).showSuccessAlertDialog(
                      "Trade", "Enter Trade Price", "error");
                }
              }
            });
            /*    setState(() {
              if (enableTrade) {
                if (amountController.text.isNotEmpty) {
                  if (double.parse(balance) >= double.parse(totalAmount)) {
                    loading = true;
                    if (buySell) {
                      if (marginVisibleOption) {
                        placeMarginOrder(
                            false, false, "buy-market", "1", tleverageVal);
                      } else if (futureOption) {
                        placeMarginOrder(
                            false, false, "buy-market", "2", tleverageVal);
                      } else {
                        placeMarginOrder(true, false, "buy-market", "0", "");
                      }
                    } else {
                      if (marginVisibleOption) {
                        placeMarginOrder(
                            false, false, "sell-market", "1", tleverageVal);
                      } else if (futureOption) {
                        placeMarginOrder(
                            false, false, "sell-market", "2", tleverageVal);
                      } else {
                        placeMarginOrder(true, false, "sell-market", "0", "");
                      }
                    }
                  } else {
                    CustomWidget(context: context)
                        .custombar("Trade", "Insufficient Balance", false);
                  }
                } else {
                  CustomWidget(context: context)
                      .custombar("Trade", "Enter Trade Quantity", false);
                }
              } else {
                if (priceController.text.isNotEmpty) {
                  if (amountController.text.isNotEmpty) {
                    if (double.parse(balance) >= double.parse(totalAmount)) {
                      if (buySell) {
                        if (marginVisibleOption) {
                          enableStopLimit ? "" : loading = true;
                          placeMarginOrder(
                              false, true, "buy", "1", tleverageVal);
                          if (enableStopLimit) {
                            if (stopPriceController.text.isNotEmpty) {
                              loading = true;
                              stopLimit(
                                  false, "buy-stop-limit", "1", tleverageVal);
                            } else {
                              CustomWidget(context: context).custombar(
                                  "Trade", "Enter the stop limit-price", false);
                            }
                          }
                        } else if (enableStopLimit) {
                          if (stopPriceController.text.isNotEmpty) {
                            loading = true;
                            stopLimit(true, "buy-stop-limit", "0", "");
                          } else {
                            CustomWidget(context: context).custombar(
                                "Trade", "Enter the stop limit-price", false);
                          }
                        } else if (futureOption) {
                          placeMarginOrder(
                              false, true, "buy", "2", tleverageVal);
                        } else {
                          placeMarginOrder(true, true, "buy", "0", "");
                        }
                      } else {
                        if (marginVisibleOption) {
                          placeMarginOrder(
                              false, true, "sell", "1", tleverageVal);
                          if (enableStopLimit) {
                            if (stopPriceController.text.isNotEmpty) {
                              loading = true;
                              stopLimit(
                                  false, "sell-stop-limit", "1", tleverageVal);
                            } else {
                              CustomWidget(context: context).custombar(
                                  "Trade", "Enter the stop limit-price", false);
                            }
                          }
                        } else if (enableStopLimit) {
                          if (stopPriceController.text.isNotEmpty) {
                            loading = true;
                            stopLimit(true, "sell-stop-limit", "0", "");
                          } else {
                            CustomWidget(context: context).custombar(
                                "Trade", "Enter the stop limit-price", false);
                          }
                        } else if (futureOption) {
                          placeMarginOrder(
                              false, true, "sell", "2", tleverageVal);
                        } else {
                          placeMarginOrder(true, true, "sell", "0", "");
                        }
                      }
                    } else {
                      CustomWidget(context: context)
                          .custombar("Trade", "Insufficient Balance", false);
                    }
                  } else {
                    CustomWidget(context: context)
                        .custombar("Trade", "Enter Trade Quantity", false);
                  }
                } else {
                  CustomWidget(context: context)
                      .custombar("Trade", "Enter Trade Price", false);
                }
              }
            });*/
          },
          child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: buySell
                    ? CustomTheme
                    .of(context)
                    .indicatorColor
                    : CustomTheme
                    .of(context)
                    .hoverColor,
              ),
              child: Center(
                child: Text(
                  futurelong ? "Long" : "Short",
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      14.0,
                      Theme
                          .of(context)
                          .cardColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
              )),
        ),
        SizedBox(
          height: 5.0,
        ),
      ],
    );
  }

  showFutureOrders() {
    showBarModalBottomSheet(
        expand: true,
        context: context,
        backgroundColor: CustomTheme
            .of(context)
            .primaryColorLight,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter ssetState) {
                return Container(
                  margin:EdgeInsets.only(top:MediaQuery
                      .of(context)
                      .size
                      .height*0.04) ,
                  color: CustomTheme
                      .of(context)
                      .primaryColorLight,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  child:
                  // cancelOrder
                  //     ? CustomWidget(context: context).loadingIndicator(
                  //   CustomTheme.of(context).focusColor,
                  // )
                  //     :
                  NestedScrollView(
                    controller: controller,
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      //<-- headerSliverBuilder
                      return <Widget>[
                        SliverAppBar(automaticallyImplyLeading: false,
                          backgroundColor: CustomTheme
                              .of(context)
                              .primaryColorLight,
                          pinned: true,
                          //<-- pinned to true
                          floating: true,
                          //<-- floating to true
                          expandedHeight: 40.0,
                          forceElevated: innerBoxIsScrolled,
                          //<-- forceElevated to innerBoxIsScrolled
                          bottom: TabBar(
                            isScrollable: false,
                            labelColor: CustomTheme
                                .of(context)
                                .focusColor,
                            //<-- selected text color
                            unselectedLabelColor:
                            CustomTheme
                                .of(context)
                                .focusColor
                                .withOpacity(0.5),
                            // isScrollable: true,
                            indicatorPadding:
                            EdgeInsets.only(left: 10.0, right: 10.0),
                            indicatorColor: CustomTheme
                                .of(context)
                                .indicatorColor,
                            tabs: <Tab>[
                              Tab(
                                text: "Open Orders",
                              ),
                              Tab(
                                text: "Order History",
                              ),
                              Tab(
                                text: "Position",
                              ),
                            ],
                            controller: _tabController,
                          ),
                        ),
                      ];
                    },
                    body: Container(
                      color: CustomTheme
                          .of(context)
                          .primaryColorLight,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.9,
                      child: TabBarView(
                        children: <Widget>[
                          openOrdersUI(),
                          HistoryOrdersUI(ssetState),
                          HistoryPositionUI(ssetState),
                        ],
                        controller: _tabController,
                      ),
                    ),
                  ),
                );
              });
        });
  }
  showOrders() {
    showBarModalBottomSheet(
        expand: true,
        context: context,
        backgroundColor: CustomTheme
            .of(context)
            .primaryColorLight,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter ssetState) {
                return Container(
                  margin:EdgeInsets.only(top:MediaQuery
                      .of(context)
                      .size
                      .height*0.04) ,
                  color: CustomTheme
                      .of(context)
                      .primaryColorLight,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  child:
                  // cancelOrder
                  //     ? CustomWidget(context: context).loadingIndicator(
                  //   CustomTheme.of(context).focusColor,
                  // )
                  //     :
                  NestedScrollView(
                    controller: controller,
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      //<-- headerSliverBuilder
                      return <Widget>[
                        SliverAppBar(automaticallyImplyLeading: false,
                          backgroundColor: CustomTheme
                              .of(context)
                              .primaryColorLight,
                          pinned: true,
                          //<-- pinned to true
                          floating: true,
                          //<-- floating to true
                          expandedHeight: 40.0,
                          forceElevated: innerBoxIsScrolled,
                          //<-- forceElevated to innerBoxIsScrolled
                          bottom: TabBar(
                            isScrollable: false,
                            labelColor: CustomTheme
                                .of(context)
                                .focusColor,
                            //<-- selected text color
                            unselectedLabelColor:
                            CustomTheme
                                .of(context)
                                .focusColor
                                .withOpacity(0.5),
                            // isScrollable: true,
                            indicatorPadding:
                            EdgeInsets.only(left: 10.0, right: 10.0),
                            indicatorColor: CustomTheme
                                .of(context)
                                .indicatorColor,
                            tabs: <Tab>[
                              Tab(
                                text: "Open Orders",
                              ),
                              Tab(
                                text: "Order History",
                              ),
                            ],
                            controller: spottabController,
                          ),
                        ),
                      ];
                    },
                    body: Container(
                      color: CustomTheme
                          .of(context)
                          .primaryColorLight,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.9,
                      child: TabBarView(
                        children: <Widget>[
                          openOrdersUI(),
                          HistoryOrdersUI(ssetState),

                        ],
                        controller: spottabController,
                      ),
                    ),
                  ),
                );
              });
        });
  }

  Widget HistoryOrdersUI(StateSetter updateState) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          completedOrders.length > 0
              ? Container(
              color: Theme
                  .of(context)
                  .primaryColorLight,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.82,
              child: SingleChildScrollView(
                controller: controller,
                child: ListView.builder(
                  itemCount: completedOrders.length>0?completedOrders.length:0,
                  shrinkWrap: true,
                  controller: controller,
                  itemBuilder: (BuildContext context, int index) {
                    // Moment spiritRoverOnMars =
                    // Moment(completedOrders[index].createdAt!).toLocal();
                    return Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            key: PageStorageKey(index.toString()),

                            title:SizedBox(width: MediaQuery.of(context).size.width,child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   "Pair",
                                    //   style: CustomWidget(context: context)
                                    //       .CustomSizedTextStyle(
                                    //       12.0,
                                    //       Theme
                                    //           .of(context)
                                    //           .focusColor
                                    //           .withOpacity(0.5),
                                    //       FontWeight.w400,
                                    //       'FontRegular'),
                                    // ),
                                    Row(children: [Text(
                                      completedOrders[index]
                                          .pair
                                          .toString(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          16.0,
                                          Theme
                                              .of(context)
                                              .focusColor,
                                          FontWeight.w400,
                                          'FontRegular'),
                                    ),
                                      const SizedBox(width: 10,),
                                      Container(child:Text(
                                        completedOrders[index]
                                            .orderType
                                            .toString()+"-"+completedOrders[index]
                                            .tradeType
                                            .toString(),
                                        style: CustomWidget(
                                            context: context)
                                            .CustomSizedTextStyle(
                                            12.0,
                                            completedOrders[index]
                                                .tradeType
                                                .toString()
                                                .toLowerCase() ==
                                                "buy"
                                                ? CustomTheme
                                                .of(
                                                context)
                                                .indicatorColor
                                                : CustomTheme
                                                .of(
                                                context)
                                                .hoverColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                      ),padding: EdgeInsets.all(4),decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                                          color: completedOrders[index]
                                              .tradeType
                                              .toString()
                                              .toLowerCase() ==
                                              "buy"
                                              ? CustomTheme
                                              .of(
                                              context)
                                              .indicatorColor.withOpacity(0.2)
                                              : CustomTheme
                                              .of(
                                              context)
                                              .hoverColor.withOpacity(0.2), ),),
                                    ]),
                                    Text(
                                      completedOrders[index]
                                          .createdAt!
                                          .toString(),
                                      style: CustomWidget(
                                          context: context)
                                          .CustomSizedTextStyle(
                                          12.0,
                                          Theme
                                              .of(context)
                                              .focusColor,
                                          FontWeight.w400,
                                          'FontRegular'),
                                    ),

                                  ],
                                ),
                                // const SizedBox(
                                //   width: 50.0,
                                // ),

                                Flexible(flex: 2,child: Padding(padding: EdgeInsets.only(left:30),child: Icon(
                                  Icons.arrow_drop_down,
                                  color: Theme
                                      .of(context)
                                      .focusColor,
                                  size: 18.0,
                                ),),)
                              ],
                            ),),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          // Column(
                                          //   children: [
                                          //     Text(
                                          //       "Date",
                                          //       style: CustomWidget(
                                          //           context: context)
                                          //           .CustomSizedTextStyle(
                                          //           12.0,
                                          //           Theme
                                          //               .of(context)
                                          //               .focusColor
                                          //               .withOpacity(
                                          //               0.5),
                                          //           FontWeight.w400,
                                          //           'FontRegular'),
                                          //     ),
                                          //     Text(
                                          //       completedOrders[index]
                                          //           .createdAt!
                                          //           .toString(),
                                          //       style: CustomWidget(
                                          //           context: context)
                                          //           .CustomSizedTextStyle(
                                          //           12.0,
                                          //           Theme
                                          //               .of(context)
                                          //               .focusColor,
                                          //           FontWeight.w400,
                                          //           'FontRegular'),
                                          //     ),
                                          //   ],
                                          //   crossAxisAlignment:
                                          //   CrossAxisAlignment.start,
                                          // ),
                                          // Column(
                                          //   children: [
                                          //     Text(
                                          //       "Type",
                                          //       style: CustomWidget(
                                          //           context: context)
                                          //           .CustomSizedTextStyle(
                                          //           12.0,
                                          //           Theme
                                          //               .of(context)
                                          //               .focusColor
                                          //               .withOpacity(
                                          //               0.5),
                                          //           FontWeight.w400,
                                          //           'FontRegular'),
                                          //     ),
                                          //     Text(
                                          //       completedOrders[index]
                                          //           .tradeType
                                          //           .toString(),
                                          //       style: CustomWidget(
                                          //           context: context)
                                          //           .CustomSizedTextStyle(
                                          //           14.0,
                                          //           completedOrders[index]
                                          //               .tradeType
                                          //               .toString()
                                          //               .toLowerCase() ==
                                          //               "buy"
                                          //               ? CustomTheme
                                          //               .of(
                                          //               context)
                                          //               .indicatorColor
                                          //               : CustomTheme
                                          //               .of(
                                          //               context)
                                          //               .hoverColor,
                                          //           FontWeight.w500,
                                          //           'FontRegular'),
                                          //     ),
                                          //   ],
                                          // ),
                                          // Column(
                                          //   children: [
                                          //     Text(
                                          //       "Order Type",
                                          //       style: CustomWidget(
                                          //           context: context)
                                          //           .CustomSizedTextStyle(
                                          //           12.0,
                                          //           Theme
                                          //               .of(context)
                                          //               .focusColor
                                          //               .withOpacity(
                                          //               0.5),
                                          //           FontWeight.w400,
                                          //           'FontRegular'),
                                          //     ),
                                          //     Text(
                                          //       completedOrders[index]
                                          //           .orderType
                                          //           .toString(),
                                          //       style: CustomWidget(
                                          //           context: context)
                                          //           .CustomSizedTextStyle(
                                          //           12.0,
                                          //           Theme
                                          //               .of(context)
                                          //               .focusColor,
                                          //           FontWeight.w400,
                                          //           'FontRegular'),
                                          //     ),
                                          //   ],
                                          //   crossAxisAlignment:
                                          //   CrossAxisAlignment.end,
                                          // )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child:
                                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Price",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor
                                                        .withOpacity(
                                                        0.5),
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                              Text(
                                                completedOrders[index]
                                                    .price
                                                    .toString()=="null"?"0.0":completedOrders[index]
                                                    .price
                                                    .toString(),
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                            ],
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          ),),
                    Padding(
                    padding: EdgeInsets.only(
                    left: 10.0, right: 10.0),
                    child:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Fee",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor
                                                        .withOpacity(
                                                        0.5),
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                              Text(
                                                completedOrders[index]
                                                    .fees
                                                    .toString(),
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    14.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                            ],
                                          ),),
                    Padding(
                    padding: EdgeInsets.only(
                    left: 10.0, right: 10.0),
                    child:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Quantity",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor
                                                        .withOpacity(
                                                        0.5),
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                              Text(
                                                completedOrders[index]
                                                    .volume
                                                    .toString(),
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                            ],
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                          ),),
                                    // const SizedBox(
                                    //   height: 10.0,
                                    // ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child:
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Total",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor
                                                        .withOpacity(
                                                        0.5),
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                              Text(
                                                completedOrders[index]
                                                    .value
                                                    .toString(),
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                            ],
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          ),),

                                            Padding(
                    padding: EdgeInsets.only(
                    left: 10.0, right: 10.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Status",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor
                                                        .withOpacity(
                                                        0.5),
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                              Text(
                                                completedOrders[index]
                                                    .status
                                                    .toString(),
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    completedOrders[index]
                                                        .status
                                                        .toString() ==
                                                        "canceled"
                                                        ? Theme
                                                        .of(
                                                        context)
                                                        .scaffoldBackgroundColor
                                                        : Theme
                                                        .of(
                                                        context)
                                                        .unselectedWidgetColor,
                                                    FontWeight.w500,
                                                    'FontRegular'),
                                              ),
                                            ],
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          ),
                                          // InkWell(
                                          //   child: Container(
                                          //     width: 80,
                                          //     padding: const EdgeInsets.only(
                                          //         top: 3.0, bottom: 3.0),
                                          //     decoration: BoxDecoration(
                                          //       color: Colors.red,
                                          //       borderRadius:
                                          //       BorderRadius.circular(5),
                                          //     ),
                                          //     child: Align(
                                          //       alignment: Alignment.center,
                                          //       child: Text(
                                          //         "Cancel",
                                          //         style: CustomWidget(
                                          //             context: context)
                                          //             .CustomSizedTextStyle(
                                          //             12.0,
                                          //             Theme.of(context)
                                          //                 .focusColor,
                                          //             FontWeight.w400,
                                          //             'FontRegular'),
                                          //         textAlign: TextAlign.center,
                                          //       ),
                                          //     ),
                                          //   ),
                                          //   onTap: () {
                                          //     setState(() {
                                          //       loading = true;
                                          //       updatecancelOrder(
                                          //         AllopenOrders[index]
                                          //             .id
                                          //             .toString(),
                                          //       );
                                          //     });
                                          //   },
                                          // ),

                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                            ]),),],

                            trailing: Container(
                              width: 1.0,
                              height: 10.0,
                            ),
                    ),


                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          height: 1.0,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          color: Theme
                              .of(context)
                              .focusColor,
                        ),
                    ]);
                  },
                ),
              ))
              : Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.3,
            color: Theme
                .of(context)
                .primaryColorLight,
            child: Center(
              child: Text(
                "No Records Found..!",
                style: CustomWidget(context: context)
                    .CustomSizedTextStyle(
                    12.0,
                    Theme
                        .of(context)
                        .focusColor,
                    FontWeight.w400,
                    'FontRegular'),
              ),
            ),
          ),
          const SizedBox(
            height: 30.0,
          )
        ],
      ),
    );
  }
  Widget HistoryPositionUI(StateSetter updateState) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          positionList.length > 0
              ? Container(
              color: Theme
                  .of(context)
                  .primaryColorLight,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.82,
              child: SingleChildScrollView(
                controller: controller,
                child: ListView.builder(
                  itemCount: positionList.length>0?positionList.length:0,
                  shrinkWrap: true,
                  controller: controller,
                  itemBuilder: (BuildContext context, int index) {
                    // Moment spiritRoverOnMars =
                    // Moment(completedOrders[index].createdAt!).toLocal();
                    return Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              key: PageStorageKey(index.toString()),

                              title:SizedBox(width: MediaQuery.of(context).size.width,child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      // Text(
                                      //   "Pair",
                                      //   style: CustomWidget(context: context)
                                      //       .CustomSizedTextStyle(
                                      //       12.0,
                                      //       Theme
                                      //           .of(context)
                                      //           .focusColor
                                      //           .withOpacity(0.5),
                                      //       FontWeight.w400,
                                      //       'FontRegular'),
                                      // ),
                                      Row(children: [Text(
                                        positionList[index]
                                            .symbol
                                            .toString(),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            16.0,
                                            Theme
                                                .of(context)
                                                .focusColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                      ),
                                        const SizedBox(width: 10,),
                                        Container(child:Text(
                                          positionList[index]
                                              .tradeMode
                                              .toString()=="0"?"Cross":"Isolated",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              CustomTheme
                                                  .of(
                                                  context)
                                                  .focusColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                        ),padding: EdgeInsets.all(4),decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                                          color: CustomTheme
                                              .of(
                                              context)
                                              .dividerColor.withOpacity(0.8), ),),
                                      ]),
                                      Text(
                                        positionList[index]
                                            .createdTime!
                                            .toString(),
                                        style: CustomWidget(
                                            context: context)
                                            .CustomSizedTextStyle(
                                            12.0,
                                            Theme
                                                .of(context)
                                                .focusColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                      ),

                                    ],
                                  ),
                                  // const SizedBox(
                                  //   width: 50.0,
                                  // ),

                                  Flexible(flex: 2,child: Padding(padding: EdgeInsets.only(left:30),child: Icon(
                                    Icons.arrow_drop_down,
                                    color: Theme
                                        .of(context)
                                        .focusColor,
                                    size: 18.0,
                                  ),),)
                                ],
                              ),),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              // Column(
                                              //   children: [
                                              //     Text(
                                              //       "Date",
                                              //       style: CustomWidget(
                                              //           context: context)
                                              //           .CustomSizedTextStyle(
                                              //           12.0,
                                              //           Theme
                                              //               .of(context)
                                              //               .focusColor
                                              //               .withOpacity(
                                              //               0.5),
                                              //           FontWeight.w400,
                                              //           'FontRegular'),
                                              //     ),
                                              //     Text(
                                              //       completedOrders[index]
                                              //           .createdAt!
                                              //           .toString(),
                                              //       style: CustomWidget(
                                              //           context: context)
                                              //           .CustomSizedTextStyle(
                                              //           12.0,
                                              //           Theme
                                              //               .of(context)
                                              //               .focusColor,
                                              //           FontWeight.w400,
                                              //           'FontRegular'),
                                              //     ),
                                              //   ],
                                              //   crossAxisAlignment:
                                              //   CrossAxisAlignment.start,
                                              // ),
                                              // Column(
                                              //   children: [
                                              //     Text(
                                              //       "Type",
                                              //       style: CustomWidget(
                                              //           context: context)
                                              //           .CustomSizedTextStyle(
                                              //           12.0,
                                              //           Theme
                                              //               .of(context)
                                              //               .focusColor
                                              //               .withOpacity(
                                              //               0.5),
                                              //           FontWeight.w400,
                                              //           'FontRegular'),
                                              //     ),
                                              //     Text(
                                              //       completedOrders[index]
                                              //           .tradeType
                                              //           .toString(),
                                              //       style: CustomWidget(
                                              //           context: context)
                                              //           .CustomSizedTextStyle(
                                              //           14.0,
                                              //           completedOrders[index]
                                              //               .tradeType
                                              //               .toString()
                                              //               .toLowerCase() ==
                                              //               "buy"
                                              //               ? CustomTheme
                                              //               .of(
                                              //               context)
                                              //               .indicatorColor
                                              //               : CustomTheme
                                              //               .of(
                                              //               context)
                                              //               .hoverColor,
                                              //           FontWeight.w500,
                                              //           'FontRegular'),
                                              //     ),
                                              //   ],
                                              // ),
                                              // Column(
                                              //   children: [
                                              //     Text(
                                              //       "Order Type",
                                              //       style: CustomWidget(
                                              //           context: context)
                                              //           .CustomSizedTextStyle(
                                              //           12.0,
                                              //           Theme
                                              //               .of(context)
                                              //               .focusColor
                                              //               .withOpacity(
                                              //               0.5),
                                              //           FontWeight.w400,
                                              //           'FontRegular'),
                                              //     ),
                                              //     Text(
                                              //       completedOrders[index]
                                              //           .orderType
                                              //           .toString(),
                                              //       style: CustomWidget(
                                              //           context: context)
                                              //           .CustomSizedTextStyle(
                                              //           12.0,
                                              //           Theme
                                              //               .of(context)
                                              //               .focusColor,
                                              //           FontWeight.w400,
                                              //           'FontRegular'),
                                              //     ),
                                              //   ],
                                              //   crossAxisAlignment:
                                              //   CrossAxisAlignment.end,
                                              // )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child:
                                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Mark Price",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor
                                                        .withOpacity(
                                                        0.5),
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                              Text(
                                                positionList[index]
                                                    .markPrice
                                                    .toString(),
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                            ],
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          ),),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Liq Price",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor
                                                        .withOpacity(
                                                        0.5),
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                              Text(
                                                positionList[index]
                                                    .liqPrice
                                                    .toString()??"--",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    14.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                            ],
                                          ),),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "pnl %",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor
                                                        .withOpacity(
                                                        0.5),
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                              Text(
                                                positionList[index]
                                                    .curRealisedPnl
                                                    .toString(),
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                            ],
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                          ),),
                                        // const SizedBox(
                                        //   height: 10.0,
                                        // ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child:
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Margin",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor
                                                        .withOpacity(
                                                        0.5),
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                              Text(
                                                positionList[index]
                                                    .autoAddMargin
                                                    .toString(),
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                            ],
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          ),),

                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Entry price",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor
                                                        .withOpacity(
                                                        0.5),
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                              Text(
                                                positionList[index]
                                                    .avgPrice
                                                    .toString(),
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    completedOrders[index]
                                                        .status
                                                        .toString() ==
                                                        "canceled"
                                                        ? Theme
                                                        .of(
                                                        context)
                                                        .scaffoldBackgroundColor
                                                        : Theme
                                                        .of(
                                                        context)
                                                        .unselectedWidgetColor,
                                                    FontWeight.w500,
                                                    'FontRegular'),
                                              ),
                                            ],
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          ),
                                          // InkWell(
                                          //   child: Container(
                                          //     width: 80,
                                          //     padding: const EdgeInsets.only(
                                          //         top: 3.0, bottom: 3.0),
                                          //     decoration: BoxDecoration(
                                          //       color: Colors.red,
                                          //       borderRadius:
                                          //       BorderRadius.circular(5),
                                          //     ),
                                          //     child: Align(
                                          //       alignment: Alignment.center,
                                          //       child: Text(
                                          //         "Cancel",
                                          //         style: CustomWidget(
                                          //             context: context)
                                          //             .CustomSizedTextStyle(
                                          //             12.0,
                                          //             Theme.of(context)
                                          //                 .focusColor,
                                          //             FontWeight.w400,
                                          //             'FontRegular'),
                                          //         textAlign: TextAlign.center,
                                          //       ),
                                          //     ),
                                          //   ),
                                          //   onTap: () {
                                          //     setState(() {
                                          //       loading = true;
                                          //       updatecancelOrder(
                                          //         AllopenOrders[index]
                                          //             .id
                                          //             .toString(),
                                          //       );
                                          //     });
                                          //   },
                                          // ),

                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                      ]),),],

                              trailing: Container(
                                width: 1.0,
                                height: 10.0,
                              ),
                            ),


                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            height: 1.0,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            color: Theme
                                .of(context)
                                .focusColor,
                          ),
                        ]);
                  },
                ),
              ))
              : Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.3,
            color: Theme
                .of(context)
                .primaryColorLight,
            child: Center(
              child: Text(
                "No Records Found..!",
                style: CustomWidget(context: context)
                    .CustomSizedTextStyle(
                    12.0,
                    Theme
                        .of(context)
                        .focusColor,
                    FontWeight.w400,
                    'FontRegular'),
              ),
            ),
          ),
          const SizedBox(
            height: 30.0,
          )
        ],
      ),
    );
  }

  Widget openOrdersUI() {
    return SingleChildScrollView(
      child: Column(
        children: [
          openOrders.length > 0
              ? Container(
              color: Theme
                  .of(context)
                  .primaryColorLight,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.82,
              child: SingleChildScrollView(
                controller: controller,
                child: ListView.builder(
                  itemCount: openOrders.length>0?openOrders.length:0,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  controller: controller,
                  itemBuilder: (BuildContext context, int index) {
                    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(openOrders[index].createdTime.toString().isEmpty?"0":openOrders[index].createdTime.toString()));
                    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
                    // Moment spiritRoverOnMars =
                    // Moment(openOrders[index].createdAt!).toLocal();
                    return Column(
                      children: [
                        Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            key: PageStorageKey(index.toString()),
                            title: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Pair",
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          12.0,
                                          Theme
                                              .of(context)
                                              .focusColor
                                              .withOpacity(0.5),
                                          FontWeight.w400,
                                          'FontRegular'),
                                    ),
                                    Text(
                                      openOrders[index].symbol.toString(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          14.0,
                                          Theme
                                              .of(context)
                                              .focusColor,
                                          FontWeight.w400,
                                          'FontRegular'),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: Theme
                                      .of(context)
                                      .focusColor,
                                  size: 18.0,
                                )
                              ],
                            ),
                            trailing: Container(
                              width: 1.0,
                              height: 10.0,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Date",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor
                                                        .withOpacity(
                                                        0.5),
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                              Text(
                                                // spiritRoverOnMars
                                                //     .format(
                                                //     "YYYY MMMM Do - hh:mm:ssa")
                                                //     .toString(),
                                                formattedDate,
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Type",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor
                                                        .withOpacity(
                                                        0.5),
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                              Text(
                                                openOrders[index]
                                                    .side
                                                    .toString(),
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    14.0,
                                                    openOrders[index]
                                                        .side
                                                        .toString()
                                                        .toLowerCase() ==
                                                        "buy"
                                                        ? CustomTheme
                                                        .of(
                                                        context)
                                                        .indicatorColor
                                                        : CustomTheme
                                                        .of(
                                                        context)
                                                        .hoverColor,
                                                    FontWeight.w500,
                                                    'FontRegular'),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Order Type",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor
                                                        .withOpacity(
                                                        0.5),
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                              Text(
                                                openOrders[index]
                                                    .orderType
                                                    .toString(),
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Price",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor
                                                        .withOpacity(
                                                        0.5),
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                              Text(
                    openOrders[index]
                        .price
                        .toString()==null || openOrders[index]
                        .price
                        .toString()=="null" ?  openOrders[index]
                        .price
                        .toString(): openOrders[index]
                        .price
                        .toString(),
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Quantity",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor
                                                        .withOpacity(
                                                        0.5),
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                              Text(
                                                openOrders[index]
                                                    .qty
                                                    .toString(),
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Remain",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor
                                                        .withOpacity(
                                                        0.5),
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                              Text("0",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            child: Container(
                                              width: 80,
                                              padding:
                                              const EdgeInsets.only(
                                                  top: 3.0,
                                                  bottom: 3.0),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                BorderRadius.circular(
                                                    5),
                                              ),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Cancel",
                                                  style: CustomWidget(
                                                      context: context)
                                                      .CustomSizedTextStyle(
                                                      12.0,
                                                      Theme
                                                          .of(context)
                                                          .focusColor,
                                                      FontWeight.w400,
                                                      'FontRegular'),
                                                  textAlign:
                                                  TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                Navigator.pop(context);
                                                loading = true;
                                                updatecancelOrder(
                                                  marginOption||spotOption?"":"linear",
                                                  openOrders[index]
                                                      .orderId
                                                      .toString(),
                                                    openOrders[index].symbol.toString()

                                                );
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          height: 1.0,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          color: Theme
                              .of(context)
                              .focusColor,
                        ),
                      ],
                    );
                  },
                ),
              ))
              : Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.3,
            color: Theme
                .of(context)
                .cardColor,
            child: Center(
              child:Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                spotOption?Text(
                "Please deposit or buy crypto first",
                style: CustomWidget(context: context)
                    .CustomSizedTextStyle(
                    12.0,
                    Theme
                        .of(context)
                        .focusColor,
                    FontWeight.w400,
                    'FontRegular'),
              ):Text(
                  "No Result Found...",
                  style: CustomWidget(context: context)
                      .CustomSizedTextStyle(
                      12.0,
                      Theme
                          .of(context)
                          .focusColor,
                      FontWeight.w400,
                      'FontRegular'),
                ),
                const SizedBox(height: 20,),
                spotOption?Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                  InkWell(onTap: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => Deposit_Screen(coinList:),));
                  },child:Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width*0.40,
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: CustomTheme
                            .of(context)
                            .indicatorColor
                        ,
                      ),
                      child: Center(
                        child: Text(
                          'Deposit',
                          style: CustomWidget(context: context).CustomSizedTextStyle(
                              14.0,
                              Theme
                                  .of(context)
                                  .cardColor,
                              FontWeight.w500,
                              'FontRegular'),
                        ),
                      )),),
                  Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width*0.40,
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: CustomTheme
                            .of(context)
                            .hoverColor,
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.instance.text("loc_sell_trade_txt5"),
                          style: CustomWidget(context: context).CustomSizedTextStyle(
                              14.0,
                              Theme
                                  .of(context)
                                  .cardColor,
                              FontWeight.w500,
                              'FontRegular'),
                        ),
                      )),
                ],):Container()
              ],),
            ),
          ),
          const SizedBox(
            height: 30.0,
          )
        ],
      ),
    );
  }

  getDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      traderType = preferences.getString("trader_type").toString();
      print(traderType);
    });
  }

  tradeDetails() {
    apiUtils
        .tradeInfo(
        spotOption || marginOption
            ? selectPair!.symbol.toString()
            : futureselectPair!.symbol.toString(),
        spotOption ? "cash" :futureOption?futureselectedHistoryTradeType.toString():selectedHistoryTradeType.toString(),
        firstCoin.toString(),
        tleverageVal.toString(),
        buySell ? "Buy" : "sell",
        selectedTime.toString(),
        priceController.text.toString(),
        amountController.text.toString(),
        spotOption
            ? "spot"
            : marginOption
            ? "Margin"
            : futurelong ? "future-open-long" : "future-close-short",
        tpslCheck,
        tppriceController.text.toString(),
        slpriceController.text.toString())
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          // getCoinList();
          // getFutureCoinList();

          getTradeHistory(spotOption || marginOption
              ? selectPair!.symbol.toString()
              : futureselectPair!.symbol.toString(),);
          getOpenOrderHistory(spotOption || marginOption
              ? selectPair!.symbol.toString()
              : futureselectPair!.symbol.toString(), spotOption||marginOption?"spot":"linear");
          getBalance(spotOption || marginOption?buySell?firstCoin:secondCoin:buySell?"USDT":"USDT");
          loading = false;

          CustomWidget(context: context).showSuccessAlertDialog(
              "ImperialX", loginData.message.toString(), "success");
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "ImperialX", loginData.message.toString(), "error");
        });
      }
    }).catchError((Object error) {
      print(error);
    });
  }

  massTradeDetails() {
    apiUtils
        .masterTradeInfo(
        selectPair!.symbol.toString(),
        spotOption ? "cash" :futureOption?futureselectedHistoryTradeType.toString():selectedHistoryTradeType.toString(),
        firstCoin.toString(),
        tleverageVal.toString(),
        buySell ? "buy" : "sell",
        selectedTime.toString(),
        priceController.text.toString(),
        amountController.text.toString(),
        spotOption
            ? "spot"
            : marginOption
            ? "margin"
            : "future",
        tpslCheck,
        tppriceController.text.toString(),
        slpriceController.text.toString())
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          // getCoinList();
          // getFutureCoinList();
          loading = false;

          CustomWidget(context: context).showSuccessAlertDialog(
              "ImperialX", loginData.message.toString(), "success");
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "ImperialX", loginData.message.toString(), "error");
        });
      }
    }).catchError((Object error) {
      print(error);
    });
  }

  getCoinList(String selectedcoin) {
    apiUtils.spotAllPairs("SPOT").then((TradePairsSpotModel loginData) {
      if (loginData.success!) {
        setState(() {
          buyData = [];
          sellData = [];
          //     tradePair = loginData.result!;

          tradePairs = loginData.result!;
          Set<TradePairsSpot> remove_dup={};
          for (int m = 0; m < tradePairs.length; m++) {
           // if (tradePairs[m].symbol.toString().contains("USDT")) {
              if(remove_dup.add(tradePairs[m])) {
                tradePair.add(tradePairs[m]);
              }
              // livePrice = tradePairs[m].lastPrice.toString();
            //}
            // else if(tradePairs[m].symbol.toString().contains("USDC")) {
            //   tradePair.add(tradePairs[m]);
            //
            // } else if(tradePairs[m].symbol.toString().contains("EUR")) {
            //   tradePair.add(tradePairs[m]);
            //
            // } else if(tradePairs[m].symbol.toString().contains("BTC")) {
            //   tradePair.add(tradePairs[m]);
            //
            // } else if(tradePairs[m].symbol.toString().contains("ETH")) {
            //   tradePair.add(tradePairs[m]);
            //
            // } else if(tradePairs[m].symbol.toString().contains("DAI")) {
            //   tradePair.add(tradePairs[m]);
            //
            // }
          }
          searchPair = tradePair;
          if(selectedcoin.isNotEmpty || selectedcoin!=""){
            for(int i=0;i<tradePair.length;i++){
              if(selectedcoin.toLowerCase() == tradePair[i].symbol!.toLowerCase()){
                selectPair=tradePair[i];
              }
            }
          }
          else{
            selectPair = tradePair[0];
          }
          livePrice=selectPair!.lastPrice.toString();
          dlivePrice=selectPair!.lastPrice.toString();
          priceController.text=livePrice;

          //selectPair = tradePair[0];
          for(int i=0;i<marketAssetList.length;i++) {
            if (selectPair!.symbol.toString().endsWith(marketAssetList[i])) {
                      int lengths=marketAssetList[i].length;
                      secondCoin=selectPair!.symbol.toString().substring(0,selectPair!.symbol.toString().length-lengths);
                      firstCoin=marketAssetList[i];
                      break;
            }
          }

          selectedSymbol = selectPair?.symbol.toString() ?? "";
          print("sizeof ${favourite_sort.length}");
          Future.delayed(Duration(seconds: 0));

          getPairDetail(selectedSymbol);
          //getminimubuyDetail(selectedSymbol);
          //secondCoin = selectPair!.symbol.toString().split("USDT")[0];
          // secondCoin =selectPair!.symbol.toString();

          // print(coinName);
          // print("coinName");
          buySell?getBalance(firstCoin):getBalance(secondCoin);
          getTradeHistory(selectPair!.symbol.toString());
          getOpenOrderHistory(selectPair!.symbol.toString(),spotOption||marginOption?"spot":"linear");
          _loadWebViewUrl();
          arrChangeData.add("tickers." + selectPair!.symbol.toString());
          arrData.add("orderbook.50." + selectPair!.symbol.toString());
          arrPriceData.add("publicTrade." + selectPair!.symbol.toString());
          loading = false;
          // print(arrData);
          var messageChangeJSON = {
            "op": "subscribe",
            "args": arrChangeData,
          };
          var messageJSON = {
            "op": "subscribe",
            "args": arrData,
          };
          var messagePriceJSON = {
            "op": "subscribe",
            "args": arrPriceData,
          };

          channelOpenOrder = IOWebSocketChannel.connect(
            Uri.parse("wss://stream.bybit.com/v5/public/spot"),
          );
          channelOpenOrder!.sink.add(json.encode(messageChangeJSON));
          channelOpenOrder!.sink.add(json.encode(messageJSON));
          channelOpenOrder!.sink.add(json.encode(messagePriceJSON));
          // channelPriceOpenOrder!.sink.add(json.encode(messagePriceJSON));

          currentSymbol = selectPair!.symbol!.toString();
          // print("currentSymbol");
          // print(currentSymbol);
          socketData();
         // socketLivePriceData();
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
      loading = false;
    });
  }

  getFutureCoinList(String selectedcoin) {
    apiUtils.getFutureTradePairList("LINEAR").then((
        FutureTradePairListModel loginData) {
      if (loginData.success!) {
        setState(() {
          buyData = [];
          sellData = [];

          futuretradePair =loginData.result! ;

          futuresearchPair = futuretradePair;
          if(selectedcoin.isNotEmpty || selectedcoin!=""){
            spotOption=false;
            marginOption=false;
            futureOption=true;
            for(int i=0;i<futuretradePair.length;i++){
              if(selectedcoin.toLowerCase() == futuretradePair[i].symbol!.toLowerCase()){
                futureselectPair=futuretradePair[i];
              }
            }
          }
          else{
            futureselectPair = futuretradePair[0];
          }
          //futureselectPair = futuretradePair[0];
          Future.delayed(Duration(seconds: 0));
          for(int i=0;i<favourite_sort.length;i++){
            if(favourite_sort[i].symbol.toString()==futureselectPair!.symbol.toString()){
              setState(() {
                selectedfav=true;
              });
              break;
            }
            else{
              setState(() {
                selectedfav=false;
              });
            }
          }
          livePrice = futureselectPair!.markPrice.toString();
          priceController.text=livePrice;

          FuturefirstCoin = futureselectPair!.symbol.toString();
          getPairDetail(FuturefirstCoin);
          //getminimubuyDetail(FuturefirstCoin);
          FuturesecondCoin = futureselectPair!.symbol.toString();
          getBalance("USDT");


          arrFutureData.add(
              "orderbook.50." + futureselectPair!.symbol.toString());
          arrFuturePriceData.add(
              "publicTrade." + futureselectPair!.symbol.toString());
          loading = false;
          // print(arrData);
          var messageFutureJSON = {
            "op": "subscribe",
            "args": arrFutureData,
          };
          var messageFuturePriceJSON = {
            "op": "subscribe",
            "args": arrFuturePriceData,
          };

          channelOpenOrder = IOWebSocketChannel.connect(
            Uri.parse("wss://stream.bybit.com/v5/public/linear"),);

          channelOpenOrder!.sink.add(json.encode(messageFutureJSON));
          channelOpenOrder!.sink.add(json.encode(messageFuturePriceJSON));

          currentSymbol = futureselectPair!.symbol!.toString();
          // socketFutureData();
          socketData();
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
      loading = false;
    });
  }

  getTradeHistory(String pair) async {
    await apiUtils.getTradehistory(pair).then((
        TradeHistoryListModel loginData) {
      if (loginData.success!) {
        setState(() {
          AllopenOrders = loginData.result!;
          //openOrders=[];
          completedOrders=[];
          for (int m = 0; m < AllopenOrders.length; m++) {
            // if (AllopenOrders[m].status.toString() == "init" ||
            //     AllopenOrders[m].status.toString() == "partially_filled") {
            //   //openOrders.add(AllopenOrders[m]);
            //   //print("hoo ${openOrders[m]}");
            // } else {
              if(AllopenOrders[m].status.toString().isNotEmpty) {
                setState(() {
                  completedOrders.add(AllopenOrders[m]);
                });
              }
            }
          //}
          completedOrders=completedOrders.reversed.toList();


          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
    });
  }

  getOpenOrderHistory(String pair,String category) async {
    await apiUtils.getOpenOrderhistory(pair,category).then((
        OpenOrderHistoryModel loginData) {
      if (loginData.success!) {
        setState(() {
          openOrders=loginData.result!;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
    });
  }

  getTradePositionHistory() async {
    await apiUtils.getPositionTradehistory().then((
        PositionHistoryModel loginData) {
      if (loginData.success!) {
        setState(() {
          positionList=loginData.result!;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
    });
  }

  getPairDetail(String pair) async {
    await apiUtils.getPairDetails(pair,spotOption?"spot":"linear").then((
        PairDetailsModel loginData) {
      if (loginData.success!) {
        setState(() {
          if(spotOption||marginOption) {
            if (loginData.result![0].lotSizeFilter!.basePrecision.toString()
                .contains(".")) {
              decimal_val = int.parse(
                  loginData.result![0].lotSizeFilter!.basePrecision.toString()
                      .split(".")[1]
                      .toString()
                      .length
                      .toString());
              quote_pre= int.parse(
                  loginData.result![0].lotSizeFilter!.quotePrecision.toString()
                      .split(".")[1]
                      .toString()
                      .length
                      .toString());

              print("valss $decimal_val");
            }
            else {
              setState(() {
                decimal_val = 0;
                quote_pre = 0;

              });

            }
          }
          else{
            print("variya");
            setState(() {


            if (loginData.result![0].lotSizeFilter!.minOrderQty.toString()
                .contains(".")) {
              decimal_val = int.parse(
                  loginData.result![0].lotSizeFilter!.minOrderQty.toString()
                      .split(".")[1]
                      .toString()
                      .length
                      .toString());

              print("valss $decimal_val");
            }
            else {
              decimal_val = 0;

            }
            });
          }
          loading = false;

        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
    });
  }
  getminimubuyDetail(String pair) async {
    await apiUtils.getPairDetails(pair,spotOption?"spot":"linear").then((
        PairDetailsModel loginData) {
      if (loginData.success!) {
        setState(() {
          minimumbuy=loginData.result![0].lotSizeFilter!.minOrderQty.toString();
          print("minimum $minimumbuy");
          loading=false;
        });

      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
    });
  }

  addFutureFavourite(String add,String pair) async {
    await apiUtils.addFavFuturePairlist(add,pair).then((
        CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          CustomWidget(context: context).showSuccessAlertDialog(
              "Favourite", "${loginData.message}", "success");
          loading=false;
        });
      } else {
        setState(() {
          CustomWidget(context: context).showSuccessAlertDialog(
              "Favourite", "${loginData.message}", "error");
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
    });
  }

  updatecancelOrder(String category,String orderid,String pair) async {
    await apiUtils.doCancelTrade(category,orderid,pair).then((
        CommonModel loginData) {
      if (loginData.status!) {
        setState(() {

          loading = false;

          getOpenOrderHistory(pair, spotOption||marginOption?"spot":"linear");
          CustomWidget(context: context).showSuccessAlertDialog(
              "Trade", "${loginData.message}", "success");
          //getTradeHistory(pair);
        });

      } else {
        setState(() {
          loading = false;
          getOpenOrderHistory(pair, spotOption||marginOption?"spot":"linear");
          CustomWidget(context: context).showSuccessAlertDialog(
              "Trade", "${loginData.message}", "error");
          //getTradeHistory(pair);
        });

      }
    }).catchError((Object error) {
      print(error);
    });
  }

  getBalance(String coin) {
    apiUtils.getTradeBalance(coin).then((GetTradeBalanceModel loginData) {
      if (loginData.success!) {
        setState(() {
          String bal=loginData.result!.result!.list![0].coin![0].availableToWithdraw.toString() ?? "0.0";
          String avbal=loginData.result!.result!.list![0].coin![0].walletBalance.toString() ?? "0.0";
          Future.delayed(Duration(milliseconds: 200));
          balance=bal;
          tbalance=avbal;
          print("yess");
          print(coin+""+balance);
          loading=false;
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

  showSheeet() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates,) {
              return Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.9,
                color: Theme
                    .of(context)
                    .primaryColor,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Container(
                            height: 45.0,
                            padding: EdgeInsets.only(left: 20.0),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.8,
                            child:
                            TextField(
                              controller: searchController,
                              focusNode: searchFocus,
                              enabled: true,
                              onEditingComplete: () {
                                setStates(() {
                                  //searchPair=[];
                                  searchFocus.unfocus();
                                });
                              },
                              onChanged: (value) {

                                setStates(() {
                                  Set<String> removeDup={};
                                  buyData = [];
                                  sellData = [];
                                  searchPair = [];



                                  for (int m = 0; m < tradePair.length; m++) {
                                    if (tradePair[m].symbol.toString()
                                        .toLowerCase()
                                        .contains(
                                        value.toString().toLowerCase()) && tradePair[m].symbol.toString().endsWith(selectedMarketAsset)
                                    // ||
                                    // tradePair[m].symbol.toString().toUpperCase().contains(value.toString().toUpperCase()) ||
                                    // tradePair[m].marketAsset!.symbol.toString().toLowerCase().contains(value.toString().toLowerCase()) ||
                                    // tradePair[m].symbol.toString().toLowerCase().contains(value.toString().toLowerCase())
                                    ) {
                                      if(removeDup.add(tradePair[m].symbol.toString())) {
                                        searchPair.add(tradePair[m]);
                                      }
                                      else{
                                        continue;
                                      }
                                    }
                                    else{
                                      continue;
                                    }
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 12, right: 0, top: 8, bottom: 8),
                                hintText: "Search",
                                hintStyle: TextStyle(
                                    fontFamily: "FontRegular",
                                    color: Theme
                                        .of(context)
                                        .focusColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400),
                                filled: true,
                                fillColor: CustomTheme
                                    .of(context)
                                    .primaryColorLight
                                    .withOpacity(0.5),
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme
                                          .of(context)
                                          .focusColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme
                                          .of(context)
                                          .focusColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme
                                          .of(context)
                                          .focusColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme
                                          .of(context)
                                          .focusColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                  borderSide:
                                  BorderSide(color: Colors.red, width: 0.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Align(
                              child: InkWell(
                                onTap: () {

                                  setStates(() {
                                    searchController.clear();

                                    //searchPair=[];
                                    searchPair=tradePair;
                                    Navigator.pop(context);
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 20.0,
                                  color: Theme
                                      .of(context)
                                      .focusColor,
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 10.0,
                        )
                      ],
                    ),
                    // const SizedBox(
                    //   height: 10.0,
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(left: 20.0),
                    //   height: 30.0,
                    //   child: ListView.builder(
                    //     itemCount: marketAssetList.length,
                    //     scrollDirection: Axis.horizontal,
                    //     itemBuilder: (BuildContext context, int index) {
                    //       return Row(
                    //         children: [
                    //           InkWell(
                    //             onTap: () {
                    //               setStates(() {
                    //                 indexVal = index;
                    //                 selectedMarketAsset = marketAssetList[index];
                    //                 // searchController.clear();
                    //                 // searchPair.clear();
                    //                 searchPair = [];
                    //
                    //                 for (int m = 0; m < tradePair.length; m++) {
                    //                   if (tradePair[m].symbol.toString().toLowerCase() == selectedMarketAsset.toLowerCase()) {
                    //                   // if (tradePair[m].symbol.toString() == tradePair[m].symbol!.split(selectedMarketAsset)[0]) {
                    //                     print(selectedMarketAsset);
                    //                     searchPair.add(tradePair[m]);
                    //                   }
                    //                 }
                    //
                    //                 // searchPair = searchPair!.symbol.toString().split(selectedMarketAsset)[0];
                    //
                    //                 // if(indexVal == 0){
                    //                 //   loading = true;
                    //                 //   getCoinList();
                    //                 // } else if(indexVal == 1){
                    //                 //   loading = true;
                    //                 //   getCoinList();
                    //                 // }
                    //                 // else if(indexVal == 2){
                    //                 //   loading = true;
                    //                 //   getFutureCoinList();
                    //                 // }
                    //
                    //
                    //               });
                    //             },
                    //             child: Container(
                    //                 padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    //                 decoration: indexVal == index ?  BoxDecoration(
                    //                   borderRadius: BorderRadius.circular(6.0),
                    //                   color: Theme.of(context).canvasColor,
                    //                 ) : BoxDecoration(),
                    //                 // decoration: BoxDecoration(
                    //                 //   borderRadius: BorderRadius.circular(5.0),
                    //                 //   color: CustomTheme.of(context).disabledColor : CustomTheme.of(context).focusColor,
                    //                 // ),
                    //                 child: Center(
                    //                   child: Text(
                    //                     marketAssetList[index].toString(),
                    //                     style: CustomWidget(context: context)
                    //                         .CustomSizedTextStyle(
                    //                         12.0,
                    //                         indexVal == index
                    //                             ? Theme.of(context).disabledColor
                    //                             : Theme.of(context).focusColor.withOpacity(0.6),
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
                    // ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width-20,height: 50,child: ListView.builder(
                      itemCount: marketAssetList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(child:Padding(padding: EdgeInsets.all(8),child:
                        Container(padding: EdgeInsets.only(left: 8,right: 8,top: 8,bottom: 8),decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                            border:Border.all(color: Theme.of(context).indicatorColor),
                            color:selectedmarketindex==index ? Theme.of(context).indicatorColor: Theme.of(context).cardColor),child:
                        Text(marketAssetList[index],style:  TextStyle(
                            fontFamily: "FontRegular",
                            color: Theme
                                .of(context)
                                .focusColor,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400),textAlign: TextAlign.center,),)),onTap: () {
                          setStates(() {
                            selectedmarketindex=index;
                            selectedMarketAsset=marketAssetList[index];
                              Set<String> removeDup={};
                              buyData = [];
                              sellData = [];
                              searchPair = [];



                              for (int m = 0; m < tradePair.length; m++) {
                                if (tradePair[m].symbol.toString().endsWith(selectedMarketAsset)
                                // ||
                                // tradePair[m].symbol.toString().toUpperCase().contains(value.toString().toUpperCase()) ||
                                // tradePair[m].marketAsset!.symbol.toString().toLowerCase().contains(value.toString().toLowerCase()) ||
                                // tradePair[m].symbol.toString().toLowerCase().contains(value.toString().toLowerCase())
                                ) {
                                  if(removeDup.add(tradePair[m].symbol.toString())) {
                                    searchPair.add(tradePair[m]);
                                  }
                                  else{
                                    continue;
                                  }
                                }
                                else{
                                  continue;
                                }
                              }
                          });
                        },);
                      },),),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(padding: EdgeInsets.only(left: 15,right: 15),child:Container(
                        child: Row(

                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Pair",
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
                            Row(mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const SizedBox(width: 20,),
                                Text(
                                  "     Last Price",
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
                            Row(mainAxisAlignment: MainAxisAlignment.center,
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
                    ),),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                        child: ListView.builder(
                            controller: controller,
                            itemCount: searchPair.length,
                            itemBuilder: ((BuildContext context, int index) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        setState(() {
                                          loading=true;
                                          currentSymbol =
                                              selectPair!.symbol.toString();
                                          print(currentSymbol + "wel");
                                          loading=true;
                                          getPairDetail(selectPair!.symbol.toString());

                                          loading = true;
                                        });

                                        // chartload();
                                        buyData = [];
                                        buyData.clear();
                                        sellData.clear();

                                        sellData = [];
                                        selectPair = searchPair[index];
                                        livePrice = selectPair!.lastPrice.toString();
                                       // getminimubuyDetail(selectPair!.symbol.toString());
                                        //priceController.clear();
                                        amountController.clear();
                                        totalAmount = "0.00";
                                        _currentSliderValue = 0;
                                        for(int i=0;i<marketAssetList.length;i++) {
                                          if (selectPair!.symbol.toString().endsWith(marketAssetList[i])) {
                                            int lengths=marketAssetList[i].length;
                                            secondCoin=selectPair!.symbol.toString().substring(0,selectPair!.symbol.toString().length-lengths);
                                            firstCoin=marketAssetList[i];
                                            break;
                                          }
                                        }
                                        priceController.text=selectPair!.lastPrice.toString();
                                        // secondCoin =
                                        // selectPair!.symbol.toString().split(
                                        //     "USDT")[0];
                                        // secondCoin =selectPair!.symbol.toString();
                                        pair = firstCoin + "-" + secondCoin;
                                        for(int j=0;j<favourite_sort.length;j++){
                                          print("helooo");
                                          if(favourite_sort[j].symbol.toString()==selectPair!.symbol.toString()){
                                            print("hih");
                                            setState(() {
                                              selectedfav=true;
                                            });
                                            break;
                                          }
                                          else{
                                            setState(() {
                                              selectedfav=false;
                                            });
                                          }
                                        }
                                        getTradeHistory(
                                            selectPair!.symbol.toString());
                                        getOpenOrderHistory(selectPair!.symbol.toString(), spotOption||marginOption?"spot":"linear");
                                        getPairDetail(selectPair!.symbol.toString());

                                        arrData.clear();
                                        arrPriceData.clear();
                                        arrData = [];
                                        arrPriceData = [];
                                        arrData.add("orderbook.50." +
                                            selectPair!.symbol.toString());
                                        arrPriceData.add("publicTrade." +
                                            selectPair!.symbol.toString());
                                        _loadWebViewUrl();
                                        Navigator.pop(context);
                                        channelOpenOrder!.sink.close();
                                        channelOpenOrder =
                                            IOWebSocketChannel.connect(
                                                Uri.parse(
                                                    "wss://stream.bybit.com/v5/public/spot"),
                                                pingInterval: Duration(
                                                    seconds: 5));

                                        var messageJSON = {
                                          "op": "subscribe",
                                          "args": arrData,
                                        };
                                        var messagePriceJSON = {
                                          "op": "subscribe",
                                          "args": arrPriceData,
                                        };
                                        print(messageJSON);
                                        channelOpenOrder!.sink.add(
                                            json.encode(messageJSON));
                                        channelOpenOrder!.sink.add(
                                            json.encode(messagePriceJSON));
                                        socketData();
                                      });
                                      searchController.clear();
                                      _loadWebViewUrl();
                                      loading = false;
                                      //searchPair=[];

                                      if (buySell) {
                                        getBalance(firstCoin);
                                      } else {
                                        getBalance(secondCoin);
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: Column(
                                        children: [
                                          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                                            Flexible(flex: 2,child:Row(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Flexible(child:Text(
                                                  searchPair[index].symbol
                                                      .toString(),
                                                  style: CustomWidget(context: context)
                                                      .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor,
                                                    FontWeight.w500,
                                                    'FontRegular',
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),),
                                                //SizedBox(width: 10.0),
                                                Flexible(child:Text(
                                                  searchPair[index].lastPrice
                                                      .toString(),
                                                  style: CustomWidget(context: context)
                                                      .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme
                                                        .of(context)
                                                        .focusColor,
                                                    FontWeight.w500,
                                                    'FontRegular',
                                                  ),
                                                  textAlign: TextAlign.start,
                                                  maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                ),),
                                               // SizedBox(width: 2,),
                                              ],
                                            ),),
                                            // Text(
                                            // futuresearchPair[index].lastPrice
                                            //     .toString(),
                                            // style: CustomWidget(context: context)
                                            //     .CustomSizedTextStyle(
                                            // 10.0,
                                            // Theme
                                            //     .of(context)
                                            //     .focusColor,
                                            // FontWeight.w500,
                                            // 'FontRegular',
                                            // ),
                                            // ),
                                            // SizedBox(height: 5.0),
                                            Flexible(child: Row(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [

                                                SizedBox(width: 10.0),
                                                Container(width: MediaQuery.of(context).size.width*0.20,padding: EdgeInsets.only(top: 5,bottom: 5),child:
                                                Text(
                                                  searchPair[index].price24HPcnt.toString()+"%",
                                                  style: CustomWidget(context: context)
                                                      .CustomSizedTextStyle(
                                                    10.0,

                                                    Theme
                                                        .of(context)
                                                        .focusColor,
                                                    FontWeight.w500,
                                                    'FontRegular',
                                                  ),textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                ),decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                                                    color: double.parse(searchPair[index].price24HPcnt.toString())>0?Theme.of(context).indicatorColor:Theme.of(context).hoverColor),),
                                              ],
                                            ),)
                                          ]),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Container(
                                    height: 1.0,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    color:
                                    CustomTheme
                                        .of(context)
                                        .primaryColorLight,
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                ],
                              );
                            }))),
                  ],
                ),
              );
            },
          );
        });
  }

  void showFutureSheeet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStates) {
            return Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.9,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              color: Theme
                  .of(context)
                  .primaryColor,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Container(
                          height: 45.0,
                          padding: EdgeInsets.only(left: 20.0),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.8,
                          child: TextField(
                            controller: searchFutureController,
                            focusNode: searchFutureFocus,
                            enabled: true,
                            onEditingComplete: () {
                              setStates(() {
                                searchFutureFocus.unfocus();
                              });
                            },
                            onChanged: (value) {
                              print("hel0oo");

            setStates(() {
              futuresearchPair=[];
              Set<FutureTradePair> remove_dup={};

              print("length ${futuretradePair.length}");
              for (int m = 0; m < futuretradePair.length; m++) {
                if (futuretradePair[m].symbol.toString()
                    .toLowerCase()
                    .contains(value.toLowerCase())) {
                  // print("truess ${futuretradePair[m].symbol.toString()
                  //     .toLowerCase()}");
                  if(remove_dup.add(futuretradePair[m])) {
                    futuresearchPair.add(futuretradePair[m]);
                  }
                  // print(futuresearchPair[m]);
                }
                else{
                  // print("trew");
                }
              }
            });
                              setStates(() {
                               // futuresearchPair = newFutureSearchPair;
                                buyData = [];
                                sellData = [];
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  left: 12, right: 0, top: 8, bottom: 8),
                              hintText: "Search",
                              hintStyle: TextStyle(
                                fontFamily: "FontRegular",
                                color: Theme
                                    .of(context)
                                    .focusColor,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                              filled: true,
                              fillColor: CustomTheme
                                  .of(context)
                                  .primaryColorLight
                                  .withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5.0)),
                                borderSide: BorderSide(
                                  color: CustomTheme
                                      .of(context)
                                      .focusColor
                                      .withOpacity(0.5),
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5.0)),
                                borderSide: BorderSide(
                                  color: CustomTheme
                                      .of(context)
                                      .focusColor
                                      .withOpacity(0.5),
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5.0)),
                                borderSide: BorderSide(
                                  color: CustomTheme
                                      .of(context)
                                      .focusColor
                                      .withOpacity(0.5),
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        child: InkWell(
                          onTap: () {
                            setStates(() {
                              searchFutureController.clear();
                              futuresearchPair=futuretradePair;
                            });
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            size: 20.0,
                            color: Theme
                                .of(context)
                                .focusColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: futuresearchPair.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setStates(() {
                                  buyData = [];
                                  sellData = [];
                                  futureselectPair= futuresearchPair[index];

                                  //futureselectPair = futuresearchPair[index];
                                  //getminimubuyDetail(futureselectPair!.symbol.toString());

                                  priceController.clear();
                                  amountController.clear();
                                  totalAmount = "0.00";
                                  _currentSliderValue = 0;

                                  FuturefirstCoin =
                                      futureselectPair!.symbol.toString();
                                  priceController.text=futureselectPair!.lastPrice.toString();
                                  loading=true;
                                  for(int j=0;j<favourite_sort.length;j++){
                                    print("helooo");
                                    if(favourite_sort[j].symbol.toString()==futureselectPair!.symbol.toString()){
                                      print("hih");
                                      setState(() {
                                        selectedfav=true;
                                      });
                                      break;
                                    }
                                    else{
                                      setState(() {
                                        selectedfav=false;
                                      });
                                    }
                                  }
                                  loading=true;
                                  Future.delayed(Duration(seconds: 1));
                                  getPairDetail(futureselectPair!.symbol.toString());
                                  getFutureCoinList(futureselectPair!.symbol.toString());
                                  FuturesecondCoin =
                                      futureselectPair!.symbol.toString();
                                  arrFutureData=[];
                                  arrFuturePriceData=[];

                                  arrFutureData.add(
                                      "orderbook.50." + futureselectPair!.symbol.toString());
                                  arrFuturePriceData.add(
                                      "publicTrade." + futureselectPair!.symbol.toString());
                                  loading = false;
                                  // print(arrData);
                                  var messageFutureJSON = {
                                    "op": "subscribe",
                                    "args": arrFutureData,
                                  };
                                  var messageFuturePriceJSON = {
                                    "op": "subscribe",
                                    "args": arrFuturePriceData,
                                  };

                                  channelOpenOrder = IOWebSocketChannel.connect(
                                    Uri.parse("wss://stream.bybit.com/v5/public/linear"),);

                                  channelOpenOrder!.sink.add(json.encode(messageFutureJSON));
                                  channelOpenOrder!.sink.add(json.encode(messageFuturePriceJSON));
                                  socketData();

                                });

                                searchFutureController.clear();
                                livePrice = "0.00";

                                getTradeHistory(
                                    futureselectPair!.symbol.toString());
                                getOpenOrderHistory(futureselectPair!.symbol.toString(), spotOption||marginOption?"spot":"linear");
                                Navigator.pop(context);
                              },

                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14.0),
                                child: Column(
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                                    Flexible(flex: 3,child:Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        SizedBox(child:Text(
                                          futuresearchPair[index].symbol
                                              .toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                            12.0,
                                            Theme
                                                .of(context)
                                                .focusColor,
                                            FontWeight.w500,
                                            'FontRegular',
                                          ),overflow: TextOverflow.ellipsis,
                                        ),width: MediaQuery.of(context).size.width*0.30,),
                                        // /SizedBox(width: 10.0),
                                        Text(
                                          futuresearchPair[index].highPrice24H
                                              .toString()+"%",
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                            12.0,
                                            Theme
                                                .of(context)
                                                .focusColor,
                                            FontWeight.w500,
                                            'FontRegular',
                                          ),
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),),
                        // Text(
                        // futuresearchPair[index].lastPrice
                        //     .toString(),
                        // style: CustomWidget(context: context)
                        //     .CustomSizedTextStyle(
                        // 10.0,
                        // Theme
                        //     .of(context)
                        //     .focusColor,
                        // FontWeight.w500,
                        // 'FontRegular',
                        // ),
                        // ),
                                      SizedBox(width: 10.0),
                                     //SizedBox(height: 5.0),
                                    Flexible(flex: 1,child: Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [


                                        Container(width: MediaQuery.of(context).size.width*0.20,padding: EdgeInsets.only(top: 5,bottom: 5),child:
                                        Text(
                                          futuresearchPair[index].price24HPcnt
                                              .toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                            10.0,
                                            Theme
                                                .of(context)
                                                .focusColor,
                                            FontWeight.w500,
                                            'FontRegular',
                                          ),textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                                            color:double.parse(futuresearchPair[index].price24HPcnt
                                                .toString())>0?Theme.of(context).indicatorColor:Theme.of(context).hoverColor),),
                                      ],
                                    ),)
                        ]),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Divider(
                              color: CustomTheme
                                  .of(context)
                                  .primaryColorLight,
                              height: 1.0,
                              thickness: 1.0,
                            ),
                            SizedBox(height: 5.0),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double? trackLeft = offset.dx;
    final double? trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double? trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft!, trackTop!, trackWidth!, trackHeight);
  }
}

class BuySellData {
  String price;
  String quantity;

  BuySellData(this.price, this.quantity);
}

class LikeStatus {
  String id;
  bool status;

  LikeStatus(this.id, this.status);
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
// class Result{
//   String? imageurl;
//   String? id;
//   String? category;
//   String? symbol;
//   String? baseCoin;
//   String? quoteCoin;
//   String? status;
//   String? marginTrading;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//
//   Result({
//     this.imageurl,
//     this.id,
//     this.category,
//     this.symbol,
//     this.baseCoin,
//     this.quoteCoin,
//     this.status,
//     this.marginTrading,
//     this.createdAt,
//     this.updatedAt,
//   });
// }