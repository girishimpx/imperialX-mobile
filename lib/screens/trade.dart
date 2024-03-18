import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imperial/data/crypt_model/all_wallet_pairs.dart';
import 'package:imperial/data/crypt_model/common_model.dart';
import 'package:imperial/data/crypt_model/future_trade_pair_model.dart';
import 'package:imperial/data/crypt_model/trade_his_list_model.dart';
import 'package:imperial/data/crypt_model/trade_pair_model.dart';
import 'package:imperial/data/crypt_model/user_wallet_balance_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:web_socket_channel/io.dart';

//import 'package:webview_flutter/webview_flutter.dart';
import '../../../common/colors.dart';
import '../../../common/localization/localizations.dart';
import '../../../common/theme/custom_theme.dart';
import '../common/custom_widget.dart';
import '../data/api_utils.dart';

class TradeScreen extends StatefulWidget {
  const TradeScreen({Key? key}) : super(key: key);

  @override
  State<TradeScreen> createState() => _SellTradeScreenState();
}

class _SellTradeScreenState extends State<TradeScreen>
    with TickerProviderStateMixin {
  List<String> chartTime = ["Limit", "Market", "Stop-Limit"];

  List<String> tradeType = ["Cross", "Isolated"];
  String selectedTime = "";

  List<TradePairList> tradePair = [];
  List<TradePairList> searchPair = [];
  TradePairList? selectPair;
  final _formKey = GlobalKey<FormState>();
  List<TradeHistoryList> openOrders = [];
  List<TradeHistoryList> completedOrders = [];
  List<TradeHistoryList> AllopenOrders = [];

  bool buySell = true;

  late TabController _tabController, tradeTabController;
  bool spotOption = true;
  bool marginOption = false;

  bool futureOption = false;
  TextEditingController priceController = TextEditingController();
  TextEditingController stopPriceController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  APIUtils apiUtils = APIUtils();
  bool buyOption = true;
  bool sellOption = true;
  final List<String> _decimal = ["0.00000001", "0.0001", "0.01"];
  int decimalIndex = 8;

  ScrollController controller = ScrollController();
  bool loading = false;
  String pair = "ADA-USDT";

  InAppWebViewController? webViewController;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  TextEditingController searchFutureController = TextEditingController();
  FocusNode searchFutureFocus = FocusNode();
  bool enableTrade = false;
  bool enableStopLimit = false;
  bool enableLoan = true;
  bool leverageLoan = true;
  String balance = "0.00";
  String escrow = "0.00";
  String totalBalance = "0.00";
  String coinName = "";
  String coinTwoName = "";
  String totalAmount = "0.00";
  String price = "0.00";
  String stopPrice = "0.00";
  String tradeAmount = "0.00";
  String takerFee = "0.00";
  String takerFeeValue = "0.00";
  double _currentSliderValue = 0;

  int _tLevSliderValue = 0;

  bool favValue = false;

  String tleverageVal = "1";
  IOWebSocketChannel? channelOpenOrder;

  List<BuySellData> buyData = [];
  List<BuySellData> sellData = [];

  String firstCoin = "";
  String secondCoin = "";

  String livePrice = "0.00";

  bool socketLoader = false;
  String selectedDecimal = "";
  String selectedHistoryTradeType = "";
  List arrData = [];

  List<FutureTradePair> futuretradePair = [];
  List<FutureTradePair> futuresearchPair = [];
  FutureTradePair? futureselectPair;
  String currentSymbol = "ADA-USDT";

  bool futurelong = true;

  //late final WebViewController webcontroller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedTime = chartTime.first;
    selectedHistoryTradeType = tradeType.first;
    tradeTabController = TabController(vsync: this, length: 3);
    _tabController = TabController(vsync: this, length: 2);
    selectedDecimal = _decimal.first;
    loading = true;
    getCoinList();
    getFutureCoinList();

    channelOpenOrder = IOWebSocketChannel.connect(
        Uri.parse("wss://ws.okex.com:8443/ws/v5/public?brokerId=197"),
        pingInterval: Duration(seconds: 30));

    // if (Platform.isAndroid) {
    //   await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    //
    //   var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
    //       AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    //   var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
    //       AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);
    //
    //   if (swAvailable && swInterceptAvailable) {
    //     AndroidServiceWorkerController serviceWorkerController =
    //     AndroidServiceWorkerController.instance();
    //
    //     await serviceWorkerController
    //         .setServiceWorkerClient(AndroidServiceWorkerClient(
    //       shouldInterceptRequest: (request) async {
    //         print(request);
    //         return null;
    //       },
    //     ));
    //   }
    // }

    // if (Platform.isAndroid) {
    //   webcontroller = WebViewController()
    //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //     ..setBackgroundColor(const Color(0xFF242B48))
    //     ..setNavigationDelegate(
    //       NavigationDelegate(
    //         onProgress: (int progress) {
    //           print(progress);
    //           // Update loading bar.
    //         },
    //         onPageStarted: (String url) {
    //           print(url);
    //           print("test1");
    //         },
    //         onPageFinished: (String url) {
    //           print(url);
    //           setState(() {
    //             loading = false;
    //           });
    //         },
    //         onWebResourceError: (WebResourceError error) {
    //           print("test");
    //           print(error);
    //         },
    //       ),
    //     )
    //     ..loadRequest(Uri.parse('https://app.imperialx.exchange/chart/ADA-USDT'));
    // } else if (Platform.isIOS) {
    //   webcontroller = WebViewController()
    //     ..setBackgroundColor(const Color(0xFF242B48))
    //     ..setNavigationDelegate(
    //       NavigationDelegate(
    //         onProgress: (int progress) {
    //           // Update loading bar.
    //         },
    //         onPageStarted: (String url) {},
    //         onPageFinished: (String url) {
    //           setState(() {
    //             loading = false;
    //           });
    //         },
    //         onWebResourceError: (WebResourceError error) {
    //           print("test");
    //           print(error);
    //         },
    //       ),
    //     )
    //     ..loadRequest(Uri.parse('https://app.imperialx.exchange/chart/ADA-USDT'));
    // }
  }

  // chartload() {
  //   if (Platform.isAndroid) {
  //     webcontroller.loadRequest(Uri.parse('https://app.imperialx.exchange/chart/' +
  //         currentSymbol.toUpperCase()));
  //   } else if (Platform.isIOS) {
  //     webcontroller.loadRequest(Uri.parse('https://app.imperialx.exchange/chart/' +
  //         currentSymbol.toUpperCase()));
  //   }
  // }

  //solved with ssl error certificate code
  // chartload() {
  //   print(pair);
  //   webViewController?.loadUrl(urlRequest: URLRequest(
  //     url: Uri.parse("https://app.imperialx.exchange/chart/"+currentSymbol),
  //   ));
  // }

  socketData() {
    setState(() {
      // buyData.clear();
      // sellData.clear();
      // buyData = [];
      // sellData = [];
    });
    channelOpenOrder!.stream.listen(
      (data) {
        if (data != null || data != "null") {
          var decode = jsonDecode(data);

          if (mounted) {
            setState(() {
              if (decode["arg"]["instId"].toString() ==
                  selectPair!.tradepair.toString()) {
                if (decode["arg"]["channel"].toString() == "books") {
                  loading = false;

                  if (buyData.length > 20) {
                    buyData.clear();
                    sellData.clear();
                    buyData = [];
                    sellData = [];
                  }

                  var list1 = List<dynamic>.from(decode['data'][0]['bids']);
                  var list2 = List<dynamic>.from(decode['data'][0]['asks']);
                  //
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
                } else {
                  livePrice = decode['data'][0]['last'].toString();
                }
              }
            });
          }
        }
      },
      onDone: () async {
        await Future.delayed(Duration(seconds: 10));
        var messageJSON = {
          "channel": "tickers",
          "instId": selectPair!.tradepair.toString()
        };

        arrData.add(messageJSON);

        var messageLiveJSON = {
          "channel": "books",
          "instId": selectPair!.tradepair.toString()
        };
        arrData.add(messageLiveJSON);

        var finalJSON = {
          "op": "subscribe",
          "args": arrData,
        };
        channelOpenOrder!.sink.add(json.encode(finalJSON));
        socketData();
      },
      onError: (error) {
        print(error);
        print("Test");
      },
    );
  }

  Widget comingsoon() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          "Coming Soon..!",
          style: CustomWidget(context: context).CustomSizedTextStyle(16.0,
              Theme.of(context).focusColor, FontWeight.w400, 'FontRegular'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: CustomTheme.of(context).primaryColor,
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10.0),
            color: CustomTheme.of(context).primaryColor,
            child: Stack(
              children: [
                Container(
                    child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: CustomTheme.of(context).primaryColor,
                        ),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      spotOption = true;
                                      marginOption = false;
                                      enableStopLimit = false;

                                      futureOption = false;
                                      enableTrade = false;
                                      coinName =
                                          selectPair!.coinname1.toString();
                                      coinTwoName =
                                          selectPair!.coinname2.toString();

                                      firstCoin =
                                          selectPair!.coinname1.toString();
                                      livePrice = "0.000";
                                      secondCoin =
                                          selectPair!.coinname2.toString();
                                    });
                                    setState(() {
                                      buySell = true;
                                      selectPair = tradePair[0];
                                      _currentSliderValue = 0;
                                      totalAmount = "0.0";
                                      openOrders = [];

                                      spotOption = true;
                                      marginOption = false;
                                      enableStopLimit = false;
                                      priceController.clear();
                                      amountController.clear();
                                      stopPriceController.clear();

                                      coinName =
                                          selectPair!.coinname1.toString();
                                      coinTwoName =
                                          selectPair!.coinname2.toString();

                                      getTradeHistory(
                                          selectPair!.tradepair.toString());

                                      firstCoin =
                                          selectPair!.coinname1.toString();
                                      secondCoin =
                                          selectPair!.coinname2.toString();
                                      futureOption = false;
                                      getBalance(firstCoin);
                                      enableTrade = false;
                                      balance = "0.00";
                                      selectedTime = chartTime.first;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: spotOption
                                            ? CustomTheme.of(context)
                                                .canvasColor
                                            : CustomTheme.of(context)
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
                                            .text("loc_sell_trade_txt1"),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                                13.0,
                                                spotOption
                                                    ? CustomTheme.of(context)
                                                        .disabledColor
                                                    : CustomTheme.of(context)
                                                        .focusColor
                                                        .withOpacity(0.5),
                                                FontWeight.w500,
                                                'FontRegular'),
                                      ),
                                    )),
                                  ),
                                ),
                                flex: 1,
                              ),
                              Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      spotOption = false;
                                      marginOption = true;
                                      enableStopLimit = false;

                                      futureOption = false;
                                      enableTrade = false;
                                      selectPair = tradePair[0];
                                      coinName =
                                          selectPair!.coinname1.toString();
                                      coinTwoName =
                                          selectPair!.coinname2.toString();

                                      livePrice = "0.000";

                                      firstCoin =
                                          selectPair!.coinname1.toString();
                                      secondCoin =
                                          selectPair!.coinname2.toString();
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
                                      getTradeHistory(
                                          selectPair!.tradepair.toString());

                                      futureOption = false;
                                      priceController.clear();
                                      amountController.clear();
                                      stopPriceController.clear();

                                      enableTrade = false;
                                      selectedTime = chartTime.first;
                                      getBalance(firstCoin);
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: marginOption
                                            ? CustomTheme.of(context)
                                                .canvasColor
                                            : CustomTheme.of(context)
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
                                            .text("loc_sell_trade_txt2"),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                                13.0,
                                                marginOption
                                                    ? CustomTheme.of(context)
                                                        .disabledColor
                                                    : CustomTheme.of(context)
                                                        .focusColor
                                                        .withOpacity(0.5),
                                                FontWeight.w500,
                                                'FontRegular'),
                                      ),
                                    )),
                                  ),
                                ),
                                flex: 1,
                              ),
                              Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      buySell = true;
                                      spotOption = false;
                                      marginOption = false;

                                      livePrice = "0.000";
                                      enableStopLimit = false;
                                      futureOption = true;
                                      coinName = futureselectPair!.instId
                                          .toString()
                                          .split("-")[0];
                                      coinTwoName = futureselectPair!.instId
                                          .toString()
                                          .split("-")[1];

                                      // loading = true;
                                      firstCoin = futureselectPair!.instId
                                          .toString()
                                          .split("-")[0];
                                      secondCoin = futureselectPair!.instId
                                          .toString()
                                          .split("-")[1];
                                    });
                                    setState(() {
                                      buySell = true;
                                      selectPair = tradePair[0];
                                      _currentSliderValue = 0;
                                      tleverageVal = "1";
                                      spotOption = false;
                                      marginOption = false;
                                      enableStopLimit = false;
                                      priceController.clear();
                                      amountController.clear();

                                      getTradeHistory(
                                          futureselectPair!.instId.toString());
                                      futureOption = true;

                                      // getCoinList();
                                      // getFutureOpenOrder();
                                      enableTrade = false;
                                      selectedTime = chartTime.first;
                                      totalAmount = "0.0";
                                      balance = "0.00";
                                      getBalance(secondCoin);
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: futureOption
                                            ? CustomTheme.of(context)
                                                .canvasColor
                                            : CustomTheme.of(context)
                                                .primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    child: Center(
                                        child: Padding(
                                      padding: futureOption
                                          ? EdgeInsets.only(
                                              top: 10.0, bottom: 10.0)
                                          : EdgeInsets.only(
                                              top: 11.0, bottom: 11.0),
                                      child: Text(
                                        AppLocalizations.instance
                                            .text("loc_sell_trade_txt3"),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                                13.0,
                                                futureOption
                                                    ? CustomTheme.of(context)
                                                        .disabledColor
                                                    : CustomTheme.of(context)
                                                        .focusColor
                                                        .withOpacity(0.5),
                                                FontWeight.w500,
                                                'FontRegular'),
                                      ),
                                    )),
                                  ),
                                ),
                                flex: 1,
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
                        .loadingIndicator(CustomTheme.of(context).disabledColor)
                    : Container()
              ],
            ),
          ),
        ));
  }

  Widget spotUI() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    showSheeet();
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: InkWell(
                          child: Icon(
                            Icons.menu_rounded,
                            size: 22.0,
                            color: Theme.of(context).focusColor,
                          ),
                        ),
                      ),
                      tradePair.length > 0
                          ? Text(
                              selectPair!.tradepair.toString(),
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      16.0,
                                      Theme.of(context).focusColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ]),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: OrderWidget(),
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
          // const SizedBox(
          //   height: 15.0,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     Container(
          //       height: 35.0,
          //       padding: const EdgeInsets.only(
          //           left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(5.0),
          //         border: Border.all(
          //           width: 1.0,
          //           color: CustomTheme.of(context).focusColor.withOpacity(0.5),
          //         ),
          //         // color: CustomTheme.of(context).disabledColor,
          //       ),
          //       child: Center(
          //         child: Theme(
          //           data: Theme.of(context).copyWith(
          //             canvasColor: CustomTheme.of(context).canvasColor,
          //           ),
          //           child: DropdownButtonHideUnderline(
          //             child: DropdownButton(
          //               items: _decimal
          //                   .map((value) => DropdownMenuItem(
          //                         child: Text(
          //                           value,
          //                           style: CustomWidget(context: context)
          //                               .CustomSizedTextStyle(
          //                                   12.0,
          //                                   Theme.of(context).focusColor,
          //                                   FontWeight.w500,
          //                                   'FontRegular'),
          //                         ),
          //                         value: value,
          //                       ))
          //                   .toList(),
          //               onChanged: (value) {
          //                 setState(() {
          //                   selectedDecimal = value.toString();
          //                   for (int m = 0; m < _decimal.length; m++) {
          //                     if (value == _decimal[m]) {
          //                       if (m == 0) {
          //                         decimalIndex = 8;
          //                       } else if (m == 1) {
          //                         decimalIndex = 4;
          //                       } else {
          //                         decimalIndex = 2;
          //                       }
          //                     }
          //                   }
          //                 });
          //               },
          //               isExpanded: false,
          //               value: selectedDecimal,
          //               icon: Icon(
          //                 Icons.arrow_drop_down,
          //                 color: CustomTheme.of(context).focusColor,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     InkWell(
          //       onTap: () {
          //         showSuccessAlertDialog();
          //       },
          //       child: Container(
          //         padding: EdgeInsets.all(3.0),
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(10.0),
          //           // color: CustomTheme.of(context).disabledColor,
          //         ),
          //         child: Icon(
          //           Icons.settings,
          //           color: Theme.of(context).disabledColor,
          //           size: 20.0,
          //         ),
          //       ),
          //     )
          //   ],
          // ),
          // const SizedBox(
          //   height: 10.0,
          // ),
          // Column(
          //   children: [
          //     Row(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           "Live Price",
          //           style: CustomWidget(context: context).CustomSizedTextStyle(
          //               12.0,
          //               Theme.of(context).focusColor,
          //               FontWeight.bold,
          //               'FontRegular'),
          //         ),
          //         Text(
          //           livePrice +
          //               " " +
          //               (futureOption
          //                   ? coinTwoName
          //                   : (buySell ? coinTwoName : coinName)),
          //           style: CustomWidget(context: context).CustomSizedTextStyle(
          //               11.5,
          //               Theme.of(context).focusColor,
          //               FontWeight.w500,
          //               'FontRegular'),
          //         ),
          //       ],
          //     ),
          //     SizedBox(
          //       height: 5.0,
          //     ),
          //
          //     SizedBox(
          //       height: 5.0,
          //     ),
          //     Row(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           "Total Asset",
          //           style: CustomWidget(context: context).CustomSizedTextStyle(
          //               12.0,
          //               Theme.of(context).focusColor.withOpacity(0.5),
          //               FontWeight.w500,
          //               'FontRegular'),
          //         ),
          //         Text(
          //           totalBalance +
          //               " " +
          //               (futureOption
          //                   ? coinTwoName
          //                   : (buySell ? coinTwoName : coinName)),
          //           style: CustomWidget(context: context).CustomSizedTextStyle(
          //               11.5,
          //               Theme.of(context).focusColor,
          //               FontWeight.w500,
          //               'FontRegular'),
          //         ),
          //       ],
          //     ),
          //     SizedBox(
          //       height: 5.0,
          //     ),
          //   ],
          // ),
          const SizedBox(
            height: 10.0,
          ),
          InkWell(
            onTap: () {
              showOrders();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Open Orders ( " + (openOrders.length.toString()) + " )",
                    style: CustomWidget(context: context).CustomTextStyle(
                        Theme.of(context).focusColor.withOpacity(0.5),
                        FontWeight.w400,
                        'FontRegular'),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    children: [
                      Text(
                        "Show all",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                12.0,
                                Theme.of(context).focusColor.withOpacity(0.5),
                                FontWeight.w500,
                                'FontRegular'),
                        textAlign: TextAlign.center,
                      ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Theme.of(context).focusColor.withOpacity(0.5),
                        size: 10.0,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          openOrdersUIS(),
        ],
      ),
    );
  }

  Widget futureUI() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    showFutureSheeet();
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: InkWell(
                          child: Icon(
                            Icons.menu_rounded,
                            size: 22.0,
                            color: Theme.of(context).focusColor,
                          ),
                        ),
                      ),
                      futuretradePair.length > 0
                          ? Text(
                              futureselectPair!.instId.toString(),
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      16.0,
                                      Theme.of(context).focusColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ]),
          const SizedBox(
            height: 10.0,
          ),
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
                    color: CustomTheme.of(context).focusColor.withOpacity(0.5),
                  ),
                  // color: CustomTheme.of(context).disabledColor,
                ),
                child: Center(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: CustomTheme.of(context).canvasColor,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        items: _decimal
                            .map((value) => DropdownMenuItem(
                                  child: Text(
                                    value,
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            12.0,
                                            Theme.of(context).focusColor,
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
                          color: CustomTheme.of(context).focusColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
                    color: Theme.of(context).disabledColor,
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
                        Theme.of(context).focusColor,
                        FontWeight.bold,
                        'FontRegular'),
                  ),
                  Text(
                    livePrice +
                        " " +
                        (futureOption
                            ? coinTwoName
                            : (buySell ? coinName : coinTwoName)),
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        11.5,
                        Theme.of(context).focusColor,
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
                        Theme.of(context).focusColor.withOpacity(0.5),
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                  Text(
                    balance + " " + (futureOption ? coinTwoName : coinName),
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        11.5,
                        Theme.of(context).focusColor,
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
                    "Live Price",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme.of(context).focusColor,
                        FontWeight.bold,
                        'FontRegular'),
                  ),
                  Text(
                    livePrice + " " + (futureOption ? coinTwoName : coinName),
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        11.5,
                        Theme.of(context).focusColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Frozen amount",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme.of(context).focusColor.withOpacity(0.5),
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                  Text(
                    escrow + " " + (futureOption ? coinTwoName : coinName),
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        11.5,
                        Theme.of(context).focusColor,
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
                        Theme.of(context).focusColor.withOpacity(0.5),
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                  Text(
                    totalBalance +
                        " " +
                        (futureOption ? coinTwoName : coinName),
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        11.5,
                        Theme.of(context).focusColor,
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
          InkWell(
            onTap: () {
              // futureOption ? showFutureOrders() : showOrders();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Open Orders ( " + (openOrders.length.toString()) + " )",
                    style: CustomWidget(context: context).CustomTextStyle(
                        Theme.of(context).focusColor.withOpacity(0.5),
                        FontWeight.w400,
                        'FontRegular'),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    children: [
                      Text(
                        "Show all",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                12.0,
                                Theme.of(context).focusColor.withOpacity(0.5),
                                FontWeight.w500,
                                'FontRegular'),
                        textAlign: TextAlign.center,
                      ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Theme.of(context).focusColor.withOpacity(0.5),
                        size: 10.0,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          openOrdersUIS(),
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
                AppLocalizations.instance.text("loc_sell_trade_price") +
                    "\n(" +
                    secondCoin +
                    ")",
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    12.0,
                    Theme.of(context).focusColor.withOpacity(0.5),
                    FontWeight.w500,
                    'FontRegular'),
              ),
            ),
            Expanded(
              child: Text(
                AppLocalizations.instance.text("loc_sell_trade_Qty") +
                    "\n(" +
                    firstCoin +
                    ")",
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    12.0,
                    Theme.of(context).focusColor.withOpacity(0.5),
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
                height: MediaQuery.of(context).size.height * 0.4,
                child: CustomWidget(context: context)
                    .loadingIndicator(CustomTheme.of(context).focusColor),
              )
            : buyData.length > 0 && sellData.length > 0
                ? Column(
                    children: [
                      sellOption
                          ? SizedBox(
                              height: !buyOption
                                  ? MediaQuery.of(context).size.height * 0.4
                                  : MediaQuery.of(context).size.height * 0.2,
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
                                                  buySell = true;
                                                  priceController.text =
                                                      sellData[index]
                                                          .price
                                                          .toString()
                                                          .replaceAll(",", "");
                                                  amountController.text =
                                                      sellData[index]
                                                          .quantity
                                                          .toString()
                                                          .replaceAll(",", "");
                                                  totalAmount = (double.parse(
                                                              amountController
                                                                  .text
                                                                  .toString()) *
                                                          double.parse(
                                                              priceController
                                                                  .text
                                                                  .toString()))
                                                      .toStringAsFixed(4);
                                                  coinName = selectPair!
                                                      .coinname1
                                                      .toString();
                                                  coinTwoName = selectPair!
                                                      .coinname2
                                                      .toString();
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
                                                  Text(
                                                    double.parse(sellData[index]
                                                            .price
                                                            .toString())
                                                        .toStringAsFixed(
                                                            decimalIndex),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            10.0,
                                                            Theme.of(context)
                                                                .indicatorColor,
                                                            FontWeight.w500,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
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
                                                            10.0,
                                                            Theme.of(context)
                                                                .focusColor,
                                                            FontWeight.w500,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      }))
                                  : Container(
                                      height: !buyOption
                                          ? MediaQuery.of(context).size.height *
                                              0.32
                                          : MediaQuery.of(context).size.height *
                                              0.16,
                                      color:
                                          CustomTheme.of(context).primaryColor,
                                      child: Center(
                                        child: Text(
                                          " No Data Found..!",
                                          style: TextStyle(
                                            fontFamily: "FontRegular",
                                            color: CustomTheme.of(context)
                                                .focusColor,
                                          ),
                                        ),
                                      ),
                                    ),
                            )
                          : Container(
                              color: Colors.white,
                            ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      buyOption
                          ? SizedBox(
                              height: !sellOption
                                  ? MediaQuery.of(context).size.height * 0.40
                                  : MediaQuery.of(context).size.height * 0.20,
                              child: buyData.length > 0
                                  ? ListView.builder(
                                      controller: controller,
                                      itemCount: buyData.length,
                                      itemBuilder:
                                          ((BuildContext context, int index) {
                                        return InkWell(
                                            onTap: () {
                                              setState(() {
                                                buySell = false;
                                                priceController.text =
                                                    buyData[index]
                                                        .price
                                                        .toString()
                                                        .replaceAll(",", "");
                                                amountController.text =
                                                    buyData[index]
                                                        .quantity
                                                        .toString()
                                                        .replaceAll(",", "");

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
                                                    .toStringAsFixed(4);
                                                totalAmount = ((double.parse(
                                                            priceController
                                                                .text) *
                                                        double.parse(
                                                            amountController
                                                                .text)))
                                                    .toStringAsFixed(4);
                                                if (futureOption) {
                                                  firstCoin = futureselectPair!
                                                      .instId
                                                      .toString()
                                                      .split("-")[0];
                                                  secondCoin = futureselectPair!
                                                      .instId
                                                      .toString()
                                                      .split("-")[1];

                                                  coinName = futureselectPair!
                                                      .instId
                                                      .toString()
                                                      .split("-")[0];
                                                  coinTwoName =
                                                      futureselectPair!.instId
                                                          .toString()
                                                          .split("-")[1];
                                                } else {
                                                  coinName = selectPair!
                                                      .coinname1
                                                      .toString();
                                                  coinTwoName = selectPair!
                                                      .coinname2
                                                      .toString();
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
                                                Text(
                                                  double.parse(buyData[index]
                                                          .price
                                                          .toString())
                                                      .toStringAsFixed(
                                                          decimalIndex),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          10.0,
                                                          Theme.of(context)
                                                              .hoverColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                ),
                                                Text(
                                                  double.parse(buyData[index]
                                                          .quantity
                                                          .toString()
                                                          .replaceAll(",", ""))
                                                      .toStringAsFixed(
                                                          decimalIndex),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          10.0,
                                                          Theme.of(context)
                                                              .focusColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                ),
                                              ],
                                            ));
                                      }))
                                  : Container(
                                      height: !sellOption
                                          ? MediaQuery.of(context).size.height *
                                              0.40
                                          : MediaQuery.of(context).size.height *
                                              0.20,
                                      color:
                                          CustomTheme.of(context).primaryColor,
                                      child: Center(
                                        child: Text(
                                          " No Data Found..!",
                                          style: TextStyle(
                                            fontFamily: "FontRegular",
                                            color: CustomTheme.of(context)
                                                .focusColor,
                                          ),
                                        ),
                                      ),
                                    ))
                          : Container(),
                    ],
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.30,
                    color: CustomTheme.of(context).primaryColor,
                    child: Center(
                      child: Text(
                        " No Data Found..!",
                        style: TextStyle(
                          fontFamily: "FontRegular",
                          color: CustomTheme.of(context).focusColor,
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

  Widget openOrdersUIS() {
    return Column(
      children: [
        openOrders.length > 0
            ? Container(
                color: Theme.of(context).backgroundColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                child: ListView.builder(
                  itemCount: openOrders.length,
                  shrinkWrap: true,
                  controller: controller,
                  itemBuilder: (BuildContext context, int index) {
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
                                              Theme.of(context)
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
                                              Theme.of(context).focusColor,
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
                                  color: Theme.of(context).focusColor,
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
                                                        Theme.of(context)
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
                                                "20.20.2023",
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
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
                                                        Theme.of(context)
                                                            .focusColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                              Text(
                                                openOrders[index]
                                                    .tradeType
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        14.0,
                                                        openOrders[index]
                                                                    .tradeType
                                                                    .toString()
                                                                    .toLowerCase() ==
                                                                "buy"
                                                            ? CustomTheme.of(
                                                                    context)
                                                                .indicatorColor
                                                            : CustomTheme.of(
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
                                                        Theme.of(context)
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
                                                        Theme.of(context)
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
                                                        Theme.of(context)
                                                            .focusColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                              Text(
                                                openOrders[index]
                                                    .price
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
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
                                                        Theme.of(context)
                                                            .focusColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                              Text(
                                                openOrders[index]
                                                    .volume
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
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
                                                "Total",
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .focusColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                              Text(
                                                openOrders[index]
                                                    .value
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
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
                                                          Theme.of(context)
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
                                                // updatecancelOrder(
                                                //     openOrders[index]
                                                //         .id
                                                //         .toString());
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
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).focusColor,
                        ),
                      ],
                    );
                  },
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height * 0.3,
                color: Theme.of(context).backgroundColor,
                child: Center(
                  child: Text(
                    "No Records Found..!",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme.of(context).focusColor,
                        FontWeight.w400,
                        'FontRegular'),
                  ),
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
            alignment: const Alignment(0, 1),
            child: Material(
              color: CustomTheme.of(context).backgroundColor,
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
                            Theme.of(context).focusColor,
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
                            Theme.of(context).focusColor,
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
                            Theme.of(context).focusColor,
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
                        priceController.clear();
                        stopPriceController.clear();
                        totalAmount = "0.0";
                        _currentSliderValue = 0;
                        tleverageVal = "1";
                        balance = "0.00";

                        // getCoinDetailsList(selectPair!.id.toString());
                        coinName = selectPair!.coinname1.toString();
                        coinTwoName = selectPair!.coinname2.toString();
                        print(coinName);
                        getBalance(coinName);
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          child: SvgPicture.asset(
                            'assets/icons/buy.svg',
                            color: buySell
                                ? CustomTheme.of(context).indicatorColor
                                : CustomTheme.of(context)
                                    .focusColor
                                    .withOpacity(0.2),
                            fit: BoxFit.fill,
                          ),
                          height: 34.0,
                        ),
                        Container(
                            child: Center(
                                child: Padding(
                          padding: EdgeInsets.only(top: 7.0, bottom: 0.0),
                          child: Text(
                            AppLocalizations.instance
                                .text("loc_sell_trade_txt5"),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    13.0,
                                    buySell
                                        ? CustomTheme.of(context).focusColor
                                        : CustomTheme.of(context)
                                            .focusColor
                                            .withOpacity(0.5),
                                    FontWeight.w500,
                                    'FontRegular'),
                          ),
                        ))),
                      ],
                    )),
              ),
              Flexible(
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          buySell = false;
                          balance = "0.00";
                        });
                        print("Test");
                        setState(() {
                          buySell = false;
                          amountController.clear();
                          priceController.clear();
                          stopPriceController.clear();
                          totalAmount = "0.0";
                          _currentSliderValue = 0;
                          tleverageVal = "1";
                          // getCoinDetailsList(selectPair!.id.toString());
                          coinName = selectPair!.coinname1.toString();
                          coinTwoName = selectPair!.coinname2.toString();
                          getBalance(coinTwoName);
                        });
                      },
                      child: Stack(
                        children: [
                          Container(
                            child: SvgPicture.asset(
                              'assets/icons/sell.svg',
                              color: !buySell
                                  ? CustomTheme.of(context).hoverColor
                                  : CustomTheme.of(context)
                                      .focusColor
                                      .withOpacity(0.2),
                              fit: BoxFit.fill,
                            ),
                            height: 34.0,
                          ),
                          Container(
                              child: Center(
                                  child: Padding(
                            padding: EdgeInsets.only(top: 7.0, bottom: 0.0),
                            child: Text(
                              AppLocalizations.instance
                                  .text("loc_sell_trade_txt6"),
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      13.0,
                                      !buySell
                                          ? CustomTheme.of(context).focusColor
                                          : CustomTheme.of(context)
                                              .focusColor
                                              .withOpacity(0.5),
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
          width: MediaQuery.of(context).size.width,
          height: 35.0,
          padding: EdgeInsets.fromLTRB(5, 0.0, 5, 0.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: CustomTheme.of(context).focusColor.withOpacity(0.5),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: CustomTheme.of(context).backgroundColor,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                menuMaxHeight: MediaQuery.of(context).size.height * 0.7,
                items: !futureOption
                    ? chartTime
                        .map((value) => DropdownMenuItem(
                              child: Text(
                                value.toString(),
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        10.0,
                                        Theme.of(context).errorColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                              ),
                              value: value,
                            ))
                        .toList()
                    : chartTime
                        .map((value) => DropdownMenuItem(
                              child: Text(
                                value.toString(),
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        10.0,
                                        Theme.of(context).errorColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                              ),
                              value: value,
                            ))
                        .toList(),
                onChanged: (value) async {
                  setState(() {
                    selectedTime = value.toString();
                    if (selectedTime == "Limit Order") {
                      enableTrade = false;
                      _currentSliderValue = 0;
                      tleverageVal = "1";
                      enableStopLimit = false;
                      priceController.clear();
                      amountController.clear();
                      totalAmount = "0.00";
                    } else if (selectedTime == "Market Order") {
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
                      Theme.of(context).errorColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
                isExpanded: true,
                value: selectedTime,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context).focusColor,
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
                width: MediaQuery.of(context).size.width,
                height: 35.0,
                padding: EdgeInsets.fromLTRB(5, 0.0, 5, 0.0),
                decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          CustomTheme.of(context).focusColor.withOpacity(0.5),
                      width: 1.0),
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.transparent,
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: CustomTheme.of(context).backgroundColor,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      menuMaxHeight: MediaQuery.of(context).size.height * 0.7,
                      items: !futureOption
                          ? tradeType
                              .map((value) => DropdownMenuItem(
                                    child: Text(
                                      value.toString(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              10.0,
                                              Theme.of(context).errorColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                    ),
                                    value: value,
                                  ))
                              .toList()
                          : tradeType
                              .map((value) => DropdownMenuItem(
                                    child: Text(
                                      value.toString(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              10.0,
                                              Theme.of(context).errorColor,
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
                                Theme.of(context).errorColor,
                                FontWeight.w500,
                                'FontRegular'),
                      ),
                      isExpanded: true,
                      value: selectedHistoryTradeType,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).focusColor,
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
                    ? Theme.of(context).focusColor.withOpacity(0.1)
                    : CustomTheme.of(context).focusColor.withOpacity(0.5),
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
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      13.0,
                      Theme.of(context).focusColor,
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
                            if ((double.parse(priceController.text.toString()) >
                                double.parse(
                                    stopPriceController.text.toString()))) {
                              takerFee = ((double.parse(
                                              priceController.text.toString()) *
                                          double.parse(amountController.text
                                              .toString()) *
                                          double.parse(
                                              takerFeeValue.toString())) /
                                      100)
                                  .toStringAsFixed(4);

                              totalAmount = (double.parse(
                                          amountController.text.toString()) *
                                      double.parse(
                                          priceController.text.toString()))
                                  .toStringAsFixed(4);
                              /*  totalAmount = ((double.parse(
                                    priceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
                            } else {
                              takerFee = ((double.parse(stopPriceController.text
                                              .toString()) *
                                          double.parse(amountController.text
                                              .toString()) *
                                          double.parse(
                                              takerFeeValue.toString())) /
                                      100)
                                  .toStringAsFixed(4);

                              totalAmount = (double.parse(
                                          amountController.text.toString()) *
                                      double.parse(
                                          stopPriceController.text.toString()))
                                  .toStringAsFixed(4);

                              /*totalAmount = ((double.parse(
                                    stopPriceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
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
                                  .toStringAsFixed(4);

                              totalAmount = (double.parse(
                                          amountController.text.toString()) *
                                      double.parse(
                                          priceController.text.toString()))
                                  .toStringAsFixed(4);
                            } else {
                              totalAmount = (double.parse(
                                          amountController.text.toString()) *
                                      double.parse(
                                          priceController.text.toString()))
                                  .toStringAsFixed(4);
                            }
                          }
                        }
                        /* if (!buySell) {
                              takerFee = ((amount *
                                  double.parse(amountController.text
                                      .toString()) *
                                  double.parse(
                                      takerFeeValue.toString())) /
                                  100)
                                  .toStringAsFixed(4);

                              totalAmount = ((double.parse(amountController.text
                                  .toString()) *
                                  double.parse(priceController.text
                                      .toString())) -
                                  double.parse(takerFee))
                                  .toStringAsFixed(4);
                            } else {*/
                        /* totalAmount = (double.parse(
                                  amountController.text.toString()) *
                                  double.parse(
                                      priceController.text.toString()))
                                  .toStringAsFixed(4);*/
                        // }
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
                              Theme.of(context).focusColor.withOpacity(0.5),
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
              //                           .toStringAsFixed(4);
              //
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(
              //                               priceController.text.toString()))
              //                       .toStringAsFixed(4);
              //                   /*  totalAmount = ((double.parse(
              //                       priceController.text
              //                           .toString()) *
              //                       double.parse(amountController
              //                           .text
              //                           .toString())) -
              //                       double.parse(takerFee))
              //                       .toStringAsFixed(4);*/
              //                 } else {
              //                   takerFee = ((double.parse(stopPriceController
              //                                   .text
              //                                   .toString()) *
              //                               double.parse(amountController.text
              //                                   .toString()) *
              //                               double.parse(
              //                                   takerFeeValue.toString())) /
              //                           100)
              //                       .toStringAsFixed(4);
              //
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(livePrice))
              //                       .toStringAsFixed(4);
              //
              //                   /*totalAmount = ((double.parse(
              //                       stopPriceController.text
              //                           .toString()) *
              //                       double.parse(amountController
              //                           .text
              //                           .toString())) -
              //                       double.parse(takerFee))
              //                       .toStringAsFixed(4);*/
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
              //                       .toStringAsFixed(4);
              //
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(
              //                               priceController.text.toString()))
              //                       .toStringAsFixed(4);
              //                 } else {
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(
              //                               priceController.text.toString()))
              //                       .toStringAsFixed(4);
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
              //                           .toStringAsFixed(4);
              //
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(
              //                               priceController.text.toString()))
              //                       .toStringAsFixed(4);
              //                   /*  totalAmount = ((double.parse(
              //                       priceController.text
              //                           .toString()) *
              //                       double.parse(amountController
              //                           .text
              //                           .toString())) -
              //                       double.parse(takerFee))
              //                       .toStringAsFixed(4);*/
              //                 } else {
              //                   takerFee = ((double.parse(stopPriceController
              //                                   .text
              //                                   .toString()) *
              //                               double.parse(amountController.text
              //                                   .toString()) *
              //                               double.parse(
              //                                   takerFeeValue.toString())) /
              //                           100)
              //                       .toStringAsFixed(4);
              //
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(livePrice))
              //                       .toStringAsFixed(4);
              //
              //                   /*totalAmount = ((double.parse(
              //                       stopPriceController.text
              //                           .toString()) *
              //                       double.parse(amountController
              //                           .text
              //                           .toString())) -
              //                       double.parse(takerFee))
              //                       .toStringAsFixed(4);*/
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
              //                       .toStringAsFixed(4);
              //
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(
              //                               priceController.text.toString()))
              //                       .toStringAsFixed(4);
              //                 } else {
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(
              //                               priceController.text.toString()))
              //                       .toStringAsFixed(4);
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
          height: 15.0,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: CustomTheme.of(context).focusColor.withOpacity(0.5),
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
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      13.0,
                      Theme.of(context).focusColor,
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
                              (double.parse(amountController.text.toString()) *
                                      double.parse(livePrice))
                                  .toStringAsFixed(4);
                        }
                      } else {
                        if (amountController.text.isNotEmpty) {
                          double amount = double.parse(amountController.text);
                          if (amount >= 0) {
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
                                                  double.parse(takerFeeValue
                                                      .toString())) /
                                              100)
                                          .toStringAsFixed(4);

                                  totalAmount = (double.parse(amountController
                                              .text
                                              .toString()) *
                                          double.parse(
                                              priceController.text.toString()))
                                      .toStringAsFixed(4);
                                  /*  totalAmount = ((double.parse(
                                    priceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
                                } else {
                                  takerFee = ((double.parse(stopPriceController
                                                  .text
                                                  .toString()) *
                                              double.parse(amountController.text
                                                  .toString()) *
                                              double.parse(
                                                  takerFeeValue.toString())) /
                                          100)
                                      .toStringAsFixed(4);

                                  totalAmount = (double.parse(amountController
                                              .text
                                              .toString()) *
                                          double.parse(livePrice))
                                      .toStringAsFixed(4);

                                  /*totalAmount = ((double.parse(
                                    stopPriceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
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
                                      .toStringAsFixed(4);

                                  totalAmount = (double.parse(amountController
                                              .text
                                              .toString()) *
                                          double.parse(
                                              priceController.text.toString()))
                                      .toStringAsFixed(4);
                                } else {
                                  totalAmount = (double.parse(amountController
                                              .text
                                              .toString()) *
                                          double.parse(
                                              priceController.text.toString()))
                                      .toStringAsFixed(4);
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
                              Theme.of(context).focusColor.withOpacity(0.5),
                              FontWeight.w500,
                              'FontRegular'),
                      border: InputBorder.none),
                  textAlign: TextAlign.start,
                ),
              )),
              Text(
                (futureOption
                    ? coinTwoName
                    : (!buySell ? coinTwoName : coinName)),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    11.5,
                    Theme.of(context).focusColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
              // InkWell(
              //   onTap: () {
              //     setState(() {
              //       tradeAmount = "0.0";
              //       totalAmount = "0.0";
              //       if (enableTrade) {
              //         if (amountController.text.isNotEmpty) {
              //           double amount = double.parse(amountController.text);
              //           if (amount > 0) {
              //             amount = amount - 0.01;
              //             amountController.text = amount.toStringAsFixed(2);
              //             tradeAmount = amountController.text;
              //             totalAmount =
              //                 (double.parse(amountController.text.toString()) *
              //                         double.parse(livePrice))
              //                     .toStringAsFixed(4);
              //           }
              //         } else {
              //           totalAmount = "0.00";
              //         }
              //       } else {
              //         if (amountController.text.isNotEmpty) {
              //           double amount = double.parse(amountController.text);
              //           if (amount > 0) {
              //             amount = amount - 0.01;
              //             amountController.text = amount.toStringAsFixed(2);
              //             tradeAmount = amountController.text;
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
              //                           .toStringAsFixed(4);
              //
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(
              //                               priceController.text.toString()))
              //                       .toStringAsFixed(4);
              //                   /*  totalAmount = ((double.parse(
              //                       priceController.text
              //                           .toString()) *
              //                       double.parse(amountController
              //                           .text
              //                           .toString())) -
              //                       double.parse(takerFee))
              //                       .toStringAsFixed(4);*/
              //                 } else {
              //                   takerFee = ((double.parse(stopPriceController
              //                                   .text
              //                                   .toString()) *
              //                               double.parse(amountController.text
              //                                   .toString()) *
              //                               double.parse(
              //                                   takerFeeValue.toString())) /
              //                           100)
              //                       .toStringAsFixed(4);
              //
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(livePrice))
              //                       .toStringAsFixed(4);
              //
              //                   /*totalAmount = ((double.parse(
              //                       stopPriceController.text
              //                           .toString()) *
              //                       double.parse(amountController
              //                           .text
              //                           .toString())) -
              //                       double.parse(takerFee))
              //                       .toStringAsFixed(4);*/
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
              //                       .toStringAsFixed(4);
              //
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(
              //                               priceController.text.toString()))
              //                       .toStringAsFixed(4);
              //                 } else {
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(
              //                               priceController.text.toString()))
              //                       .toStringAsFixed(4);
              //                 }
              //               }
              //             }
              //           }
              //         } else {
              //           amountController.text = "0.01";
              //           tradeAmount = amountController.text;
              //           totalAmount = "0.000";
              //         }
              //       }
              //     });
              //   },
              //   child: Container(
              //       height: 40.0,
              //       width: 35.0,
              //       padding: const EdgeInsets.only(
              //         left: 10.0,
              //         right: 10.0,
              //       ),
              //       decoration: BoxDecoration(
              //         color: CustomTheme.of(context).cardColor,
              //         borderRadius: BorderRadius.circular(2),
              //       ),
              //       child: Center(
              //         child: Text(
              //           "-",
              //           style: CustomWidget(context: context)
              //               .CustomSizedTextStyle(
              //                   20.0,
              //                   Theme.of(context).focusColor,
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
              //     setState(() {
              //       totalAmount = "0.000";
              //       if (enableTrade) {
              //         if (amountController.text.isNotEmpty) {
              //           double amount = double.parse(amountController.text);
              //           if (amount > 0) {
              //             amount = amount + 0.01;
              //             amountController.text = amount.toStringAsFixed(2);
              //             tradeAmount = amountController.text;
              //             totalAmount =
              //                 (double.parse(amountController.text.toString()) *
              //                         double.parse(livePrice))
              //                     .toStringAsFixed(4);
              //           }
              //         } else {
              //           totalAmount = "0.00";
              //         }
              //       } else {
              //         if (amountController.text.isNotEmpty) {
              //           double amount = double.parse(amountController.text);
              //           if (amount >= 0) {
              //             amount = amount + 0.01;
              //             amountController.text = amount.toStringAsFixed(2);
              //             tradeAmount = amountController.text;
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
              //                           .toStringAsFixed(4);
              //
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(
              //                               priceController.text.toString()))
              //                       .toStringAsFixed(4);
              //                   /*  totalAmount = ((double.parse(
              //                       priceController.text
              //                           .toString()) *
              //                       double.parse(amountController
              //                           .text
              //                           .toString())) -
              //                       double.parse(takerFee))
              //                       .toStringAsFixed(4);*/
              //                 } else {
              //                   takerFee = ((double.parse(stopPriceController
              //                                   .text
              //                                   .toString()) *
              //                               double.parse(amountController.text
              //                                   .toString()) *
              //                               double.parse(
              //                                   takerFeeValue.toString())) /
              //                           100)
              //                       .toStringAsFixed(4);
              //
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(livePrice))
              //                       .toStringAsFixed(4);
              //
              //                   /*totalAmount = ((double.parse(
              //                       stopPriceController.text
              //                           .toString()) *
              //                       double.parse(amountController
              //                           .text
              //                           .toString())) -
              //                       double.parse(takerFee))
              //                       .toStringAsFixed(4);*/
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
              //                       .toStringAsFixed(4);
              //
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(
              //                               priceController.text.toString()))
              //                       .toStringAsFixed(4);
              //                 } else {
              //                   totalAmount = (double.parse(
              //                               amountController.text.toString()) *
              //                           double.parse(
              //                               priceController.text.toString()))
              //                       .toStringAsFixed(4);
              //                 }
              //               }
              //             }
              //           }
              //         } else {
              //           amountController.text = "0.01";
              //           tradeAmount = amountController.text;
              //           totalAmount = "0.000";
              //         }
              //       }
              //     });
              //   },
              //   child: Container(
              //       height: 40.0,
              //       width: 35.0,
              //       padding: const EdgeInsets.only(
              //         left: 10.0,
              //         right: 10.0,
              //       ),
              //       decoration: BoxDecoration(
              //         color: CustomTheme.of(context).cardColor,
              //         borderRadius: BorderRadius.circular(2),
              //       ),
              //       child: Center(
              //         child: Text(
              //           "+",
              //           style: CustomWidget(context: context)
              //               .CustomSizedTextStyle(
              //                   20.0,
              //                   Theme.of(context).focusColor,
              //                   FontWeight.w500,
              //                   'FontRegular'),
              //         ),
              //       )),
              // ),
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
                          ? Theme.of(context).focusColor.withOpacity(0.1)
                          : CustomTheme.of(context).focusColor.withOpacity(0.5),
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
                                Theme.of(context).focusColor,
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
                                            .toStringAsFixed(4);

                                    totalAmount = (double.parse(priceController
                                                .text
                                                .toString()) *
                                            double.parse(amountController.text
                                                .toString()))
                                        .toStringAsFixed(4);
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
                                        .toStringAsFixed(4);

                                    totalAmount = (double.parse(
                                                stopPriceController.text
                                                    .toString()) *
                                            double.parse(amountController.text
                                                .toString()))
                                        .toStringAsFixed(4);
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
                                            .toStringAsFixed(4);

                                    totalAmount = (double.parse(priceController
                                                .text
                                                .toString()) *
                                            double.parse(amountController.text
                                                .toString()))
                                        .toStringAsFixed(4);
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
                                        .toStringAsFixed(4);

                                    totalAmount = (double.parse(
                                                stopPriceController.text
                                                    .toString()) *
                                            double.parse(amountController.text
                                                .toString()))
                                        .toStringAsFixed(4);
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
                                    Theme.of(context)
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
                        if (enableTrade) {
                        } else {
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
                                      .toStringAsFixed(4);

                                  totalAmount = (double.parse(
                                              stopPriceController.text
                                                  .toString()) *
                                          double.parse(
                                              amountController.text.toString()))
                                      .toStringAsFixed(4);
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
                                ? Theme.of(context).cardColor.withOpacity(0.2)
                                : CustomTheme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Center(
                            child: Text(
                              "-",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      20.0,
                                      enableTrade
                                          ? Theme.of(context)
                                              .cardColor
                                              .withOpacity(0.5)
                                          : Theme.of(context).focusColor,
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
                        if (enableTrade) {
                        } else {
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
                                      .toStringAsFixed(4);

                                  totalAmount = (double.parse(
                                              stopPriceController.text
                                                  .toString()) *
                                          double.parse(
                                              amountController.text.toString()))
                                      .toStringAsFixed(4);
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
                                ? Theme.of(context).cardColor.withOpacity(0.2)
                                : CustomTheme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Center(
                            child: Text(
                              "+",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      20.0,
                                      enableTrade
                                          ? Theme.of(context)
                                              .cardColor
                                              .withOpacity(0.2)
                                          : Theme.of(context).focusColor,
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
              valueIndicatorColor: CustomTheme.of(context).indicatorColor,
              trackHeight: 10.0,
              activeTickMarkColor: CustomTheme.of(context).focusColor,
              inactiveTickMarkColor:
                  CustomTheme.of(context).focusColor.withOpacity(0.5),
              tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 5.0),
              trackShape: CustomTrackShape(),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
            ),
            child: Slider(
              value: _currentSliderValue,
              max: 100,
              divisions: 4,
              label: tleverageVal,
              inactiveColor: CustomTheme.of(context).focusColor,
              activeColor: buySell
                  ? CustomTheme.of(context).indicatorColor
                  : CustomTheme.of(context).hoverColor,
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                  if (_currentSliderValue > 0) {
                    _tLevSliderValue = _currentSliderValue.toInt();
                    print(_tLevSliderValue);
                    setState(() {
                      if (_tLevSliderValue == 25) {
                        tleverageVal = "1";
                      } else if (_tLevSliderValue == 50) {
                        tleverageVal = "10";
                      } else if (_tLevSliderValue == 75) {
                        tleverageVal = "50";
                      } else {
                        tleverageVal = "75";
                      }
                    });
                    int val = _currentSliderValue.toInt();
                    setState(() {
                      priceController.clear();
                      amountController.clear();
                      if (spotOption) {
                        if (!enableTrade) {
                          priceController.text = livePrice;
                        }
                        if (double.parse(livePrice) > 0) {
                          if (buySell) {
                            double perce = ((double.parse(balance) * val) /
                                    double.parse(priceController.text)) /
                                100;

                            amountController.text =
                                double.parse(perce.toString())
                                    .toStringAsFixed(4);
                            double a = double.parse(perce
                                .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                            double b = double.parse(livePrice);
                            totalAmount = double.parse((a * b).toString())
                                .toStringAsFixed(4);
                          } else {
                            double perce = (double.parse(balance) * val) / 100;

                            amountController.text =
                                double.parse(perce.toString())
                                    .toStringAsFixed(4);
                            double a = double.parse(perce
                                .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                            double b = double.parse(livePrice);
                            totalAmount = double.parse((a * b).toString())
                                .toStringAsFixed(4);
                          }
                        }
                      }
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Available",
              style: CustomWidget(context: context).CustomSizedTextStyle(
                  12.0,
                  Theme.of(context).focusColor.withOpacity(0.5),
                  FontWeight.w500,
                  'FontRegular'),
            ),
            Text(
              double.parse(balance).toStringAsFixed(4) +
                  " " +
                  (buySell ? coinName : coinTwoName),
              style: CustomWidget(context: context).CustomSizedTextStyle(11.5,
                  Theme.of(context).focusColor, FontWeight.w500, 'FontRegular'),
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
              "Live Price",
              style: CustomWidget(context: context).CustomSizedTextStyle(12.0,
                  Theme.of(context).focusColor, FontWeight.bold, 'FontRegular'),
            ),
            Text(
              livePrice + " " + (buySell ? coinName : coinTwoName),
              style: CustomWidget(context: context).CustomSizedTextStyle(11.5,
                  Theme.of(context).focusColor, FontWeight.w500, 'FontRegular'),
            ),
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: CustomTheme.of(context).focusColor.withOpacity(0.5),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              child: Text(
                totalAmount + " " + (buySell ? coinName : coinTwoName),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    13.0,
                    Theme.of(context).focusColor,
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
                    loading = true;
                    tradeDetails();
                  } else {
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
                    if (double.parse(balance) >= double.parse(totalAmount)) {
                      tradeDetails();
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
          },
          child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35.0),
                color: buySell
                    ? CustomTheme.of(context).indicatorColor
                    : CustomTheme.of(context).hoverColor,
              ),
              child: Center(
                child: Text(
                  buySell
                      ? AppLocalizations.instance.text("loc_sell_trade_txt5")
                      : AppLocalizations.instance.text("loc_sell_trade_txt6"),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      14.0,
                      Theme.of(context).focusColor,
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

  Widget FutureOrderWidget() {
    return Column(
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
                      futurelong = true;
                    });
                    setState(() {
                      amountController.clear();
                      priceController.clear();
                      stopPriceController.clear();
                      totalAmount = "0.0";
                      _currentSliderValue = 0;
                      tleverageVal = "1";
                      coinName =
                          futureselectPair!.instId.toString().split("-")[0];
                      coinTwoName =
                          futureselectPair!.instId.toString().split("-")[1];

                      // loading = true;
                      firstCoin =
                          futureselectPair!.instId.toString().split("-")[0];
                      secondCoin =
                          futureselectPair!.instId.toString().split("-")[1];
                      getBalance(coinTwoName);
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
                              ? CustomTheme.of(context).indicatorColor
                              : Colors.transparent),
                      child: Center(
                          child: Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Text(
                          "Open",
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                                  13.0,
                                  buySell
                                      ? CustomTheme.of(context).focusColor
                                      : CustomTheme.of(context)
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
                  print("Test");
                  setState(() {
                    buySell = false;
                    amountController.clear();
                    priceController.clear();
                    stopPriceController.clear();
                    totalAmount = "0.0";
                    _currentSliderValue = 0;
                    tleverageVal = "1";
                    coinName =
                        futureselectPair!.instId.toString().split("-")[0];
                    coinTwoName =
                        futureselectPair!.instId.toString().split("-")[1];

                    // loading = true;
                    firstCoin =
                        futureselectPair!.instId.toString().split("-")[0];
                    secondCoin =
                        futureselectPair!.instId.toString().split("-")[1];
                    getBalance(coinName);
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
                            ? CustomTheme.of(context).hoverColor
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
                                    ? CustomTheme.of(context).focusColor
                                    : CustomTheme.of(context)
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
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          color: futurelong
                              ? CustomTheme.of(context).indicatorColor
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
                                      ? CustomTheme.of(context).focusColor
                                      : CustomTheme.of(context)
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
                    coinName =
                        futureselectPair!.instId.toString().split("-")[0];
                    coinTwoName =
                        futureselectPair!.instId.toString().split("-")[1];

                    // loading = true;
                    firstCoin =
                        futureselectPair!.instId.toString().split("-")[0];
                    secondCoin =
                        futureselectPair!.instId.toString().split("-")[1];
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
                            ? CustomTheme.of(context).hoverColor
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
                                    ? CustomTheme.of(context).focusColor
                                    : CustomTheme.of(context)
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
          width: MediaQuery.of(context).size.width,
          height: 35.0,
          padding: EdgeInsets.fromLTRB(5, 0.0, 5, 0.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: CustomTheme.of(context).focusColor.withOpacity(0.5),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: CustomTheme.of(context).backgroundColor,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                menuMaxHeight: MediaQuery.of(context).size.height * 0.7,
                items: !futureOption
                    ? chartTime
                        .map((value) => DropdownMenuItem(
                              child: Text(
                                value.toString(),
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        10.0,
                                        Theme.of(context).errorColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                              ),
                              value: value,
                            ))
                        .toList()
                    : chartTime
                        .map((value) => DropdownMenuItem(
                              child: Text(
                                value.toString(),
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        10.0,
                                        Theme.of(context).errorColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                              ),
                              value: value,
                            ))
                        .toList(),
                onChanged: (value) async {
                  setState(() {
                    selectedTime = value.toString();
                    if (selectedTime == "Limit Order") {
                      enableTrade = false;
                      _currentSliderValue = 0;
                      tleverageVal = "1";
                      enableStopLimit = false;
                      priceController.clear();
                      amountController.clear();
                      totalAmount = "0.00";
                    } else if (selectedTime == "Market Order") {
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
                      Theme.of(context).errorColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
                isExpanded: true,
                value: selectedTime,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context).focusColor,
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
                    ? Theme.of(context).focusColor.withOpacity(0.1)
                    : CustomTheme.of(context).focusColor.withOpacity(0.5),
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
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      13.0,
                      Theme.of(context).focusColor,
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
                            if ((double.parse(priceController.text.toString()) >
                                double.parse(
                                    stopPriceController.text.toString()))) {
                              takerFee = ((double.parse(
                                              priceController.text.toString()) *
                                          double.parse(amountController.text
                                              .toString()) *
                                          double.parse(
                                              takerFeeValue.toString())) /
                                      100)
                                  .toStringAsFixed(4);

                              totalAmount = (double.parse(
                                          amountController.text.toString()) *
                                      double.parse(
                                          priceController.text.toString()))
                                  .toStringAsFixed(4);
                              /*  totalAmount = ((double.parse(
                                    priceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
                            } else {
                              takerFee = ((double.parse(stopPriceController.text
                                              .toString()) *
                                          double.parse(amountController.text
                                              .toString()) *
                                          double.parse(
                                              takerFeeValue.toString())) /
                                      100)
                                  .toStringAsFixed(4);

                              totalAmount = (double.parse(
                                          amountController.text.toString()) *
                                      double.parse(
                                          stopPriceController.text.toString()))
                                  .toStringAsFixed(4);

                              /*totalAmount = ((double.parse(
                                    stopPriceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
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
                                  .toStringAsFixed(4);

                              totalAmount = (double.parse(
                                          amountController.text.toString()) *
                                      double.parse(
                                          priceController.text.toString()))
                                  .toStringAsFixed(4);
                            } else {
                              totalAmount = (double.parse(
                                          amountController.text.toString()) *
                                      double.parse(
                                          priceController.text.toString()))
                                  .toStringAsFixed(4);
                            }
                          }
                        }
                        /* if (!buySell) {
                              takerFee = ((amount *
                                  double.parse(amountController.text
                                      .toString()) *
                                  double.parse(
                                      takerFeeValue.toString())) /
                                  100)
                                  .toStringAsFixed(4);

                              totalAmount = ((double.parse(amountController.text
                                  .toString()) *
                                  double.parse(priceController.text
                                      .toString())) -
                                  double.parse(takerFee))
                                  .toStringAsFixed(4);
                            } else {*/
                        /* totalAmount = (double.parse(
                                  amountController.text.toString()) *
                                  double.parse(
                                      priceController.text.toString()))
                                  .toStringAsFixed(4);*/
                        // }
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
                              Theme.of(context).focusColor.withOpacity(0.5),
                              FontWeight.w500,
                              'FontRegular'),
                      border: InputBorder.none),
                  textAlign: TextAlign.start,
                ),
              )),
              InkWell(
                onTap: () {
                  if (enableTrade) {
                  } else {
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
                                        .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
                                /*  totalAmount = ((double.parse(
                                    priceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
                              } else {
                                takerFee = ((double.parse(stopPriceController
                                                .text
                                                .toString()) *
                                            double.parse(amountController.text
                                                .toString()) *
                                            double.parse(
                                                takerFeeValue.toString())) /
                                        100)
                                    .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(livePrice))
                                    .toStringAsFixed(4);

                                /*totalAmount = ((double.parse(
                                    stopPriceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
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
                                    .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
                              } else {
                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
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
                          ? Theme.of(context).cardColor.withOpacity(0.2)
                          : CustomTheme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Text(
                        "-",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                20.0,
                                enableTrade
                                    ? Theme.of(context)
                                        .cardColor
                                        .withOpacity(0.5)
                                    : Theme.of(context).focusColor,
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
                  if (enableTrade) {
                  } else {
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
                                        .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
                                /*  totalAmount = ((double.parse(
                                    priceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
                              } else {
                                takerFee = ((double.parse(stopPriceController
                                                .text
                                                .toString()) *
                                            double.parse(amountController.text
                                                .toString()) *
                                            double.parse(
                                                takerFeeValue.toString())) /
                                        100)
                                    .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(livePrice))
                                    .toStringAsFixed(4);

                                /*totalAmount = ((double.parse(
                                    stopPriceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
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
                                    .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
                              } else {
                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
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
                          ? Theme.of(context).cardColor.withOpacity(0.2)
                          : CustomTheme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Text(
                        "+",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                20.0,
                                enableTrade
                                    ? Theme.of(context)
                                        .cardColor
                                        .withOpacity(0.2)
                                    : Theme.of(context).focusColor,
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
                color: CustomTheme.of(context).focusColor.withOpacity(0.5),
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
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      13.0,
                      Theme.of(context).focusColor,
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
                              (double.parse(amountController.text.toString()) *
                                      double.parse(livePrice))
                                  .toStringAsFixed(4);
                        }
                      } else {
                        if (amountController.text.isNotEmpty) {
                          double amount = double.parse(amountController.text);
                          if (amount >= 0) {
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
                                                  double.parse(takerFeeValue
                                                      .toString())) /
                                              100)
                                          .toStringAsFixed(4);

                                  totalAmount = (double.parse(amountController
                                              .text
                                              .toString()) *
                                          double.parse(
                                              priceController.text.toString()))
                                      .toStringAsFixed(4);
                                  /*  totalAmount = ((double.parse(
                                    priceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
                                } else {
                                  takerFee = ((double.parse(stopPriceController
                                                  .text
                                                  .toString()) *
                                              double.parse(amountController.text
                                                  .toString()) *
                                              double.parse(
                                                  takerFeeValue.toString())) /
                                          100)
                                      .toStringAsFixed(4);

                                  totalAmount = (double.parse(amountController
                                              .text
                                              .toString()) *
                                          double.parse(livePrice))
                                      .toStringAsFixed(4);

                                  /*totalAmount = ((double.parse(
                                    stopPriceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
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
                                      .toStringAsFixed(4);

                                  totalAmount = (double.parse(amountController
                                              .text
                                              .toString()) *
                                          double.parse(
                                              priceController.text.toString()))
                                      .toStringAsFixed(4);
                                } else {
                                  totalAmount = (double.parse(amountController
                                              .text
                                              .toString()) *
                                          double.parse(
                                              priceController.text.toString()))
                                      .toStringAsFixed(4);
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
                              Theme.of(context).focusColor.withOpacity(0.5),
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
                                  .toStringAsFixed(4);
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
                                        .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
                                /*  totalAmount = ((double.parse(
                                    priceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
                              } else {
                                takerFee = ((double.parse(stopPriceController
                                                .text
                                                .toString()) *
                                            double.parse(amountController.text
                                                .toString()) *
                                            double.parse(
                                                takerFeeValue.toString())) /
                                        100)
                                    .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(livePrice))
                                    .toStringAsFixed(4);

                                /*totalAmount = ((double.parse(
                                    stopPriceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
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
                                    .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
                              } else {
                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
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
                      color: CustomTheme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Text(
                        "-",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                20.0,
                                Theme.of(context).focusColor,
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
                                  .toStringAsFixed(4);
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
                                        .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
                                /*  totalAmount = ((double.parse(
                                    priceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
                              } else {
                                takerFee = ((double.parse(stopPriceController
                                                .text
                                                .toString()) *
                                            double.parse(amountController.text
                                                .toString()) *
                                            double.parse(
                                                takerFeeValue.toString())) /
                                        100)
                                    .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(livePrice))
                                    .toStringAsFixed(4);

                                /*totalAmount = ((double.parse(
                                    stopPriceController.text
                                        .toString()) *
                                    double.parse(amountController
                                        .text
                                        .toString())) -
                                    double.parse(takerFee))
                                    .toStringAsFixed(4);*/
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
                                    .toStringAsFixed(4);

                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
                              } else {
                                totalAmount = (double.parse(
                                            amountController.text.toString()) *
                                        double.parse(
                                            priceController.text.toString()))
                                    .toStringAsFixed(4);
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
                      color: CustomTheme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Text(
                        "+",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                20.0,
                                Theme.of(context).focusColor,
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
                          ? Theme.of(context).focusColor.withOpacity(0.1)
                          : CustomTheme.of(context).focusColor.withOpacity(0.5),
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
                                Theme.of(context).focusColor,
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
                                            .toStringAsFixed(4);

                                    totalAmount = (double.parse(priceController
                                                .text
                                                .toString()) *
                                            double.parse(amountController.text
                                                .toString()))
                                        .toStringAsFixed(4);
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
                                        .toStringAsFixed(4);

                                    totalAmount = (double.parse(
                                                stopPriceController.text
                                                    .toString()) *
                                            double.parse(amountController.text
                                                .toString()))
                                        .toStringAsFixed(4);
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
                                            .toStringAsFixed(4);

                                    totalAmount = (double.parse(priceController
                                                .text
                                                .toString()) *
                                            double.parse(amountController.text
                                                .toString()))
                                        .toStringAsFixed(4);
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
                                        .toStringAsFixed(4);

                                    totalAmount = (double.parse(
                                                stopPriceController.text
                                                    .toString()) *
                                            double.parse(amountController.text
                                                .toString()))
                                        .toStringAsFixed(4);
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
                                    Theme.of(context)
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
                        if (enableTrade) {
                        } else {
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
                                      .toStringAsFixed(4);

                                  totalAmount = (double.parse(
                                              stopPriceController.text
                                                  .toString()) *
                                          double.parse(
                                              amountController.text.toString()))
                                      .toStringAsFixed(4);
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
                                ? Theme.of(context).cardColor.withOpacity(0.2)
                                : CustomTheme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Center(
                            child: Text(
                              "-",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      20.0,
                                      enableTrade
                                          ? Theme.of(context)
                                              .cardColor
                                              .withOpacity(0.5)
                                          : Theme.of(context).focusColor,
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
                        if (enableTrade) {
                        } else {
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
                                      .toStringAsFixed(4);

                                  totalAmount = (double.parse(
                                              stopPriceController.text
                                                  .toString()) *
                                          double.parse(
                                              amountController.text.toString()))
                                      .toStringAsFixed(4);
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
                                ? Theme.of(context).cardColor.withOpacity(0.2)
                                : CustomTheme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Center(
                            child: Text(
                              "+",
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      20.0,
                                      enableTrade
                                          ? Theme.of(context)
                                              .cardColor
                                              .withOpacity(0.2)
                                          : Theme.of(context).focusColor,
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
              valueIndicatorColor: CustomTheme.of(context).indicatorColor,
              trackHeight: 10.0,
              activeTickMarkColor: CustomTheme.of(context).focusColor,
              inactiveTickMarkColor:
                  CustomTheme.of(context).focusColor.withOpacity(0.5),
              tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 5.0),
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
                  CustomTheme.of(context).focusColor.withOpacity(0.5),
              activeColor: buySell
                  ? CustomTheme.of(context).indicatorColor
                  : CustomTheme.of(context).hoverColor,
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                  if (_currentSliderValue > 0) {
                    _tLevSliderValue = _currentSliderValue.toInt();
                    print(_tLevSliderValue);
                    setState(() {
                      if (_tLevSliderValue == 25) {
                        tleverageVal = "1";
                      } else if (_tLevSliderValue == 50) {
                        tleverageVal = "10";
                      } else if (_tLevSliderValue == 75) {
                        tleverageVal = "50";
                      } else {
                        tleverageVal = "75";
                      }
                    });
                    int val = _currentSliderValue.toInt();
                    setState(() {
                      priceController.clear();
                      amountController.clear();
                      if (spotOption) {
                        if (!enableTrade) {
                          priceController.text = livePrice;
                        }
                        if (double.parse(livePrice) > 0) {
                          if (buySell) {
                            double perce = ((double.parse(balance) * val) /
                                    double.parse(priceController.text)) /
                                100;

                            amountController.text =
                                double.parse(perce.toString())
                                    .toStringAsFixed(4);
                            double a = double.parse(perce
                                .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                            double b = double.parse(livePrice);
                            totalAmount = double.parse((a * b).toString())
                                .toStringAsFixed(4);
                          } else {
                            double perce = (double.parse(balance) * val) / 100;

                            amountController.text =
                                double.parse(perce.toString())
                                    .toStringAsFixed(4);
                            double a = double.parse(perce
                                .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                            double b = double.parse(livePrice);
                            totalAmount = double.parse((a * b).toString())
                                .toStringAsFixed(4);
                          }
                        }
                      }
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
        Container(
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: CustomTheme.of(context).focusColor.withOpacity(0.5),
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.transparent,
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              child: Text(
                totalAmount + " " + (futureOption ? coinTwoName : coinName),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    13.0,
                    Theme.of(context).focusColor,
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
                    loading = true;
                    tradeDetails();
                  } else {
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
                    if (double.parse(balance) >= double.parse(totalAmount)) {
                      tradeDetails();
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
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: buySell
                    ? CustomTheme.of(context).indicatorColor
                    : CustomTheme.of(context).hoverColor,
              ),
              child: Center(
                child: Text(
                  futurelong ? "Long" : "Short",
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      14.0,
                      Theme.of(context).focusColor,
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

  showOrders() {
    showBarModalBottomSheet(
        expand: true,
        context: context,
        backgroundColor: CustomTheme.of(context).backgroundColor,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter ssetState) {
            return Container(
              color: CustomTheme.of(context).backgroundColor,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
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
                    SliverAppBar(
                      backgroundColor: CustomTheme.of(context).backgroundColor,
                      pinned: true,
                      //<-- pinned to true
                      floating: true,
                      //<-- floating to true
                      expandedHeight: 40.0,
                      forceElevated: innerBoxIsScrolled,
                      //<-- forceElevated to innerBoxIsScrolled
                      bottom: TabBar(
                        isScrollable: false,
                        labelColor: CustomTheme.of(context).focusColor,
                        //<-- selected text color
                        unselectedLabelColor:
                            CustomTheme.of(context).focusColor.withOpacity(0.5),
                        // isScrollable: true,
                        indicatorPadding:
                            EdgeInsets.only(left: 10.0, right: 10.0),
                        indicatorColor: CustomTheme.of(context).cardColor,
                        tabs: <Tab>[
                          Tab(
                            text: "Open Orders",
                          ),
                          Tab(
                            text: "Order History",
                          ),
                        ],
                        controller: _tabController,
                      ),
                    ),
                  ];
                },
                body: Container(
                  color: CustomTheme.of(context).backgroundColor,
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: TabBarView(
                    children: <Widget>[
                      openOrdersUI(),
                      HistoryOrdersUI(ssetState)
                    ],
                    controller: _tabController,
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
                  color: Theme.of(context).backgroundColor,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.82,
                  child: SingleChildScrollView(
                    controller: controller,
                    child: ListView.builder(
                      itemCount: completedOrders.length,
                      shrinkWrap: true,
                      controller: controller,
                      itemBuilder: (BuildContext context, int index) {
                        // Moment spiritRoverOnMars =
                        // Moment(completedOrders[index].createdAt!).toLocal();
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
                                                  Theme.of(context)
                                                      .focusColor
                                                      .withOpacity(0.5),
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                        ),
                                        Text(
                                          completedOrders[index]
                                              .symbol
                                              .toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  14.0,
                                                  Theme.of(context).focusColor,
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
                                      color: Theme.of(context).focusColor,
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
                                                            Theme.of(context)
                                                                .focusColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    completedOrders[index]
                                                        .createdAt!
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
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
                                                            Theme.of(context)
                                                                .focusColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    completedOrders[index]
                                                        .tradeType
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            14.0,
                                                            completedOrders[index]
                                                                        .tradeType
                                                                        .toString()
                                                                        .toLowerCase() ==
                                                                    "buy"
                                                                ? CustomTheme.of(
                                                                        context)
                                                                    .indicatorColor
                                                                : CustomTheme.of(
                                                                        context)
                                                                    .scaffoldBackgroundColor,
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
                                                            Theme.of(context)
                                                                .focusColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    completedOrders[index]
                                                        .orderType
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
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
                                                            Theme.of(context)
                                                                .focusColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    completedOrders[index]
                                                        .price
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .focusColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Fee",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
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
                                                            Theme.of(context)
                                                                .focusColor,
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Quantity",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
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
                                                            Theme.of(context)
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
                                                    "Total",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
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
                                                            Theme.of(context)
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
                                                    "Status",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
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
                                                                ? Theme.of(
                                                                        context)
                                                                    .scaffoldBackgroundColor
                                                                : Theme.of(
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
                              width: MediaQuery.of(context).size.width,
                              color: Theme.of(context).focusColor,
                            ),
                          ],
                        );
                      },
                    ),
                  ))
              : Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: Theme.of(context).backgroundColor,
                  child: Center(
                    child: Text(
                      "No Records Found..!",
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              12.0,
                              Theme.of(context).focusColor,
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
                  color: Theme.of(context).backgroundColor,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.82,
                  child: SingleChildScrollView(
                    controller: controller,
                    child: ListView.builder(
                      itemCount: openOrders.length,
                      shrinkWrap: true,
                      controller: controller,
                      itemBuilder: (BuildContext context, int index) {
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
                                                  Theme.of(context)
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
                                                  Theme.of(context).focusColor,
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
                                      color: Theme.of(context).focusColor,
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
                                                            Theme.of(context)
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
                                                    "22.02.2023",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
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
                                                            Theme.of(context)
                                                                .focusColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    openOrders[index]
                                                        .tradeType
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            14.0,
                                                            openOrders[index]
                                                                        .tradeType
                                                                        .toString()
                                                                        .toLowerCase() ==
                                                                    "buy"
                                                                ? CustomTheme.of(
                                                                        context)
                                                                    .indicatorColor
                                                                : CustomTheme.of(
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
                                                            Theme.of(context)
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
                                                            Theme.of(context)
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
                                                            Theme.of(context)
                                                                .focusColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    openOrders[index]
                                                        .price
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
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
                                                            Theme.of(context)
                                                                .focusColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    openOrders[index]
                                                        .volume
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
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
                                                    "Total",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .focusColor
                                                                .withOpacity(
                                                                    0.5),
                                                            FontWeight.w400,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    openOrders[index]
                                                        .value
                                                        .toString(),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
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
                                                              Theme.of(context)
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
                                                    // Navigator.pop(context);
                                                    // loading = true;
                                                    // updatecancelOrder(
                                                    //   openOrders[index]
                                                    //       .id
                                                    //       .toString(),
                                                    // );
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
                              width: MediaQuery.of(context).size.width,
                              color: Theme.of(context).focusColor,
                            ),
                          ],
                        );
                      },
                    ),
                  ))
              : Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: Theme.of(context).backgroundColor,
                  child: Center(
                    child: Text(
                      "No Records Found..!",
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              12.0,
                              Theme.of(context).focusColor,
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

  tradeDetails() {
    apiUtils
        .tradeInfo(
            selectPair!.tradepair.toString(),
            spotOption ? "cash" : selectedHistoryTradeType.toString(),
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
                    : "future")
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          getCoinList();
          getFutureCoinList();

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

  getCoinList() {
    apiUtils.getTradePairList().then((TradePairListModel loginData) {
      if (loginData.success!) {
        setState(() {
          buyData = [];
          sellData = [];

          tradePair = loginData.result!;

          searchPair = tradePair;
          selectPair = tradePair[0];

          coinName = selectPair!.coinname1.toString();
          coinTwoName = selectPair!.coinname2.toString();

          firstCoin = selectPair!.coinname1.toString();
          secondCoin = selectPair!.coinname2.toString();

          getBalance(firstCoin);

          var messageJSON = {
            "channel": "tickers",
            "instId": selectPair!.tradepair.toString()
          };

          arrData.add(messageJSON);

          var messageLiveJSON = {
            "channel": "books",
            "instId": selectPair!.tradepair.toString()
          };
          arrData.add(messageLiveJSON);

          var finalJSON = {
            "op": "subscribe",
            "args": arrData,
          };
          print(finalJSON);
          channelOpenOrder!.sink.add(json.encode(finalJSON));

          currentSymbol = selectPair!.tradepair!.toString();

          socketData();

          loading = false;
        });
      } else {
        setState(() {
          //loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
    });
  }

  getFutureCoinList() {
    apiUtils
        .getFutureTradePairList()
        .then((FutureTradePairListModel loginData) {
      if (loginData.success!) {
        setState(() {
          buyData = [];
          sellData = [];

          futuretradePair = loginData.result![0].data!;

          futuresearchPair = futuretradePair;
          futureselectPair = futuretradePair[0];

          loading = false;
        });
      } else {
        setState(() {
          //loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
    });
  }

  getTradeHistory(String pair) {
    apiUtils.getTradehistory(pair).then((TradeHistoryListModel loginData) {
      if (loginData.success!) {
        setState(() {
          AllopenOrders = loginData.result!;

          for (int m = 0; m < AllopenOrders.length; m++) {
            if (AllopenOrders[m].status.toString() == "init" ||
                AllopenOrders[m].status.toString() == "partially_filled") {
              openOrders.add(AllopenOrders[m]);
            } else {
              completedOrders.add(AllopenOrders[m]);
            }
          }

          loading = false;
        });
      } else {
        setState(() {
          //loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
    });
  }

  getBalance(String coin) {
    apiUtils.getWalletList().then((GetWalletAllPairsModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          List<GetWalletAll> walletPair = loginData.result!;
          for (int m = 0; m < walletPair.length; m++) {
            if (coin.toLowerCase() ==
                walletPair[m].assetId!.symbol.toString().toLowerCase()) {
              balance = walletPair[m].balance.toString();
            }
          }
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
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.9,
                color: Theme.of(context).primaryColor,
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
                            width: MediaQuery.of(context).size.width * 0.8,
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
                                setStates(() {
                                  buyData = [];
                                  sellData = [];
                                  searchPair = [];

                                  for (int m = 0; m < tradePair.length; m++) {
                                    if (tradePair[m]
                                            .coinname1
                                            .toString()
                                            .toLowerCase()
                                            .contains(value
                                                .toString()
                                                .toLowerCase()) ||
                                        tradePair[m]
                                            .tradepair
                                            .toString()
                                            .toUpperCase()
                                            .contains(value
                                                .toString()
                                                .toUpperCase()) ||
                                        // tradePair[m].marketAsset!.symbol.toString().toLowerCase().contains(value.toString().toLowerCase()) ||
                                        tradePair[m]
                                            .coinname2
                                            .toString()
                                            .toLowerCase()
                                            .contains(value
                                                .toString()
                                                .toLowerCase())) {
                                      searchPair.add(tradePair[m]);
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
                                    color: Theme.of(context).focusColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400),
                                filled: true,
                                fillColor: CustomTheme.of(context)
                                    .backgroundColor
                                    .withOpacity(0.5),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .focusColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .focusColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .focusColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
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
                              Navigator.pop(context);
                              setState(() {
                                searchController.clear();
                                searchPair.addAll(tradePair);
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 20.0,
                              color: Theme.of(context).focusColor,
                            ),
                          )),
                        ),
                        const SizedBox(
                          width: 10.0,
                        )
                      ],
                    ),
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
                                          currentSymbol =
                                              selectPair!.tradepair.toString();
                                          print(currentSymbol + "wel");
                                        });

                                        // chartload();
                                        // buyData = [];
                                        //
                                        // sellData = [];
                                        selectPair = searchPair[index];
                                        priceController.clear();
                                        amountController.clear();
                                        totalAmount = "0.00";
                                        _currentSliderValue = 0;
                                        coinName =
                                            selectPair!.coinname1.toString();
                                        coinTwoName =
                                            selectPair!.coinname2.toString();

                                        // loading = true;
                                        firstCoin =
                                            selectPair!.coinname1.toString();
                                        secondCoin =
                                            selectPair!.coinname2.toString();
                                        pair = firstCoin + "-" + secondCoin;
                                        Navigator.pop(context);
                                        channelOpenOrder!.sink.close();
                                        channelOpenOrder =
                                            IOWebSocketChannel.connect(
                                                Uri.parse(
                                                    "wss://ws.okex.com:8443/ws/v5/public?brokerId=197"),
                                                pingInterval:
                                                    Duration(seconds: 5));
                                        var messageJSON = {
                                          "channel": "tickers",
                                          "instId":
                                              selectPair!.tradepair.toString()
                                        };

                                        arrData.add(messageJSON);

                                        var messageLiveJSON = {
                                          "channel": "books",
                                          "instId":
                                              selectPair!.tradepair.toString()
                                        };
                                        arrData.add(messageLiveJSON);

                                        var finalJSON = {
                                          "op": "subscribe",
                                          "args": arrData,
                                        };
                                        channelOpenOrder!.sink
                                            .add(json.encode(finalJSON));
                                        socketData();
                                      });
                                      searchController.clear();

                                      if (buySell) {
                                        getBalance(coinName);
                                      } else {
                                        getBalance(coinTwoName);
                                      }

                                      getTradeHistory(
                                          selectPair!.tradepair.toString());
                                    },
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20.0,
                                        ),
                                        // Container(
                                        //   height: 25.0,
                                        //   width: 25.0,
                                        //   child: Image.network(
                                        //     searchPair[index].image.toString(),
                                        //     fit: BoxFit.cover,
                                        //   ),
                                        // ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          searchPair[index]
                                              .tradepair
                                              .toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  16.0,
                                                  Theme.of(context).focusColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Container(
                                    height: 1.0,
                                    width: MediaQuery.of(context).size.width,
                                    color:
                                        CustomTheme.of(context).backgroundColor,
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

  showFutureSheeet() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColor,
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
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextField(
                              controller: searchFutureController,
                              focusNode: searchFutureFocus,
                              enabled: true,
                              onEditingComplete: () {
                                setState(() {
                                  searchFutureFocus.unfocus();
                                });
                              },
                              onChanged: (value) {
                                setState(() {
                                  setState(() {
                                    buyData = [];

                                    sellData = [];

                                    searchPair = [];

                                    for (int m = 0;
                                        m < futuretradePair.length;
                                        m++) {
                                      if (futuretradePair[m]
                                          .instId
                                          .toString()
                                          .toLowerCase()
                                          .contains(
                                              value.toString().toLowerCase())) {
                                        futuresearchPair
                                            .add(futuretradePair[m]);
                                      }
                                    }
                                  });
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 12, right: 0, top: 8, bottom: 8),
                                hintText: "Search",
                                hintStyle: TextStyle(
                                    fontFamily: "FontRegular",
                                    color: Theme.of(context).focusColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400),
                                filled: true,
                                fillColor: CustomTheme.of(context)
                                    .backgroundColor
                                    .withOpacity(0.5),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .focusColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .focusColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .focusColor
                                          .withOpacity(0.5),
                                      width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
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
                              Navigator.pop(context);
                              setState(() {
                                searchFutureController.clear();
                                futuresearchPair.addAll(futuretradePair);
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 20.0,
                              color: Theme.of(context).focusColor,
                            ),
                          )),
                        ),
                        const SizedBox(
                          width: 10.0,
                        )
                      ],
                    ),
                    Expanded(
                        child: ListView.builder(
                            controller: controller,
                            itemCount: futuresearchPair.length,
                            itemBuilder: ((BuildContext context, int index) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        buyData = [];

                                        sellData = [];
                                        futureselectPair =
                                            futuresearchPair[index];
                                        priceController.clear();
                                        amountController.clear();
                                        totalAmount = "0.00";
                                        _currentSliderValue = 0;

                                        coinName = futureselectPair!.instId
                                            .toString()
                                            .split("-")[0];
                                        coinTwoName = futureselectPair!.instId
                                            .toString()
                                            .split("-")[1];

                                        // loading = true;
                                        firstCoin = futureselectPair!.instId
                                            .toString()
                                            .split("-")[0];
                                        secondCoin = futureselectPair!.instId
                                            .toString()
                                            .split("-")[1];
                                        Navigator.pop(context);
                                        channelOpenOrder!.sink.close();
                                        channelOpenOrder =
                                            IOWebSocketChannel.connect(
                                                Uri.parse(
                                                    "wss://ws.okex.com:8443/ws/v5/public?brokerId=197"),
                                                pingInterval:
                                                    Duration(seconds: 5));
                                        var messageJSON = {
                                          "channel": "tickers",
                                          "instId": futureselectPair!.instId
                                              .toString()
                                        };

                                        arrData.add(messageJSON);

                                        var messageLiveJSON = {
                                          "channel": "books",
                                          "instId": futureselectPair!.instId
                                              .toString()
                                        };
                                        arrData.add(messageLiveJSON);

                                        var finalJSON = {
                                          "op": "subscribe",
                                          "args": arrData,
                                        };
                                        channelOpenOrder!.sink
                                            .add(json.encode(finalJSON));
                                        socketData();
                                      });
                                      searchFutureController.clear();
                                      livePrice = "0.00";

                                      getTradeHistory(
                                          futureselectPair!.instId.toString());
                                    },
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20.0,
                                        ),
                                        Container(
                                          height: 25.0,
                                          width: 25.0,
                                          child: Image.network(
                                            futuresearchPair[index]
                                                .image
                                                .toString(),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          futuresearchPair[index]
                                              .instId
                                              .toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  16.0,
                                                  Theme.of(context).focusColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Container(
                                    height: 1.0,
                                    width: MediaQuery.of(context).size.width,
                                    color:
                                        CustomTheme.of(context).backgroundColor,
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