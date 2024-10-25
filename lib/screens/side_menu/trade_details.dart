import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

import '../../common/custom_widget.dart';
import '../../common/localization/localizations.dart';
import '../../common/theme/custom_theme.dart';
import '../../data/api_utils.dart';
import '../../data/crypt_model/coin_list_model.dart';
import '../../data/crypt_model/common_model.dart';
import '../../data/crypt_model/future_trade_pair_model.dart';
import '../../data/crypt_model/getfavourites_model.dart';
import '../../data/crypt_model/getfavourites_model.dart' as favmodel;
import '../../data/crypt_model/trade_pairs_list_model.dart';
import '../market.dart';
import '../trade.dart';

class MarketTrade_Details extends StatefulWidget {
  final coinName;
  final coinPrice;
  final coinDiference;
  final coinhigh24h;
  final coinlow24l;
  final coinAskP;
  final coinBitP;
  var favtype;
  var tradetype;


   MarketTrade_Details({super.key, this.coinName, this.coinPrice, this.coinDiference, this.coinhigh24h, this.coinlow24l, this.coinAskP, this.coinBitP,this.favtype,this.tradetype});

  @override
  State<MarketTrade_Details> createState() => _MarketTrade_DetailsState();
}

class _MarketTrade_DetailsState extends State<MarketTrade_Details> {



  List<BuySellData> buyData = [];
  List<favmodel.Result> favourite_sort=[];
  List<BuySellData> sellData = [];
  bool buyOption = true;
  bool sellOption = true;
  TradePairsSpot? selectPair;
  String firstCoin = "";
  String FuturefirstCoin = "";
  String secondCoin = "";
  String FuturesecondCoin = "";
  String changePercentage = "0.00";

  String livePrice = "0.00";
  bool tpslCheck = false;
  bool socketLoader = false;
  String selectedDecimal = "";
  String selectedHistoryTradeType = "Cross";
  String futureselectedHistoryTradeType = "Cross";
  List arrData = [];
  List arrChangeData = [];
  List arrFutureData = [];
  List arrPriceData = [];
  List arrFuturePriceData = [];

  List<FutureTradePair> futuretradePair = [];
  List<FutureTradePair> futuresearchPair = [];
  FutureTradePair? futureselectPair;
  ScrollController controller = ScrollController();
  ///

  bool loading = false;
  bool info = false;
  bool earn = false;
  IOWebSocketChannel? channelOpenOrder,channelFutureOpenOrder;

  APIUtils apiUtils = APIUtils();
  ScrollController _controller = ScrollController();
  List<CoinList> tradePairListAll = [];
  InAppWebViewController? webViewController;
  String coinName="";
  String coinPrice="";
  String coinDiference="";
  String coinhigh24h="";
  String coinlow24l="";
  List<MarketDetailsList> marketList = [];
  String coinAskP="";
  String coinBitP="";
  String type="";
  String favtype="";
  int decimal_val=0;
  bool selectedfav=false;
  String traderType = "";
  List<TradePairsSpot> tradePair = [];
  List<TradePairsSpot> searchPair = [];
  // String currentSymbol = "ADA-USDT";
  // String pair="ADA-USDT";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading=true;
    //socketLoader=true;
    info = true;
    type=widget.tradetype.toString()=="linear"?"future":"spot";
    favtype=widget.favtype;
    coinName=widget.coinName;
    coinPrice=widget.coinPrice;
    coinDiference=widget.coinDiference;
    coinhigh24h=widget.coinhigh24h;
    coinlow24l=widget.coinlow24l;
    coinAskP=widget.coinAskP;
    coinBitP=widget.coinBitP;
    loading = true;
    getDetails();
    getFavList();

    loading = true;
    getCoinList(widget.coinName);
    loading = true;
    getFutureCoinList(widget.coinName);

    Future.delayed(Duration(seconds: 1));

    var message1JSON = {
      "channel": "tickers",
      "instId": widget.coinName,
    };
    arrData.add(message1JSON);

  //loading = false;
  var messageJSON = {
    "op": "subscribe",
    "args": arrData,
  };
    channelOpenOrder = IOWebSocketChannel.connect(Uri.parse("wss://stream.bybit.com/v5/public/spot"),);
    channelFutureOpenOrder = IOWebSocketChannel.connect(Uri.parse("wss://stream.bybit.com/v5/public/linear"),);

    socketData();
    socketFutureData();
    webViewController?.loadUrl(urlRequest: URLRequest(url: Uri.parse("https://app.imperialx.exchange/chart/${widget.coinName}"),));

  }
  getDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      traderType = preferences.getString("trader_type").toString();
      print(traderType);
    });
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

  getCoinList(String selectedcoin) {
    apiUtils.spotAllPairs("SPOT").then((TradePairsSpotModel loginData) {
      if (loginData.success!) {
        setState(() {
          buyData = [];
          sellData = [];
          //     tradePair = loginData.result!;

          List<TradePairsSpot> tradePairs = loginData.result!;
          Set<TradePairsSpot> remove_dup={};
          for (int m = 0; m < tradePairs.length; m++) {
            if (tradePairs[m].symbol.toString().contains("USDT")) {
              if(remove_dup.add(tradePairs[m])) {
                tradePair.add(tradePairs[m]);
              }
              // livePrice = tradePairs[m].lastPrice.toString();
            }
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
          coinhigh24h=selectPair!.highPrice24H.toString();
          //priceController.text=livePrice;
          print("length ${favourite_sort.length}");
          Future.delayed(Duration(seconds: 1));
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

          //selectPair = tradePair[0];

          firstCoin = selectPair!.symbol.toString().substring(selectPair!
              .symbol
              .toString()
              .length - 4);
         // selectedSymbol = selectPair?.symbol.toString() ?? "";
          //getPairDetail(selectedSymbol);
          //getminimubuyDetail(selectedSymbol);
          secondCoin = selectPair!.symbol.toString().split("USDT")[0];
          // secondCoin =selectPair!.symbol.toString();

          // print(coinName);
          // print("coinName");
         // getBalance(firstCoin);
          //(selectPair!.symbol.toString());
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

          //currentSymbol = selectPair!.symbol!.toString();
          // print("currentSymbol");
          // print(currentSymbol);
          socketData();
          socketLivePriceData();
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
  void _loadWebViewUrl() {
    final urls = "https://app.imperialx.exchange/chart/" +
        (selectPair?.symbol?.toString() ?? "");
    webViewController?.loadUrl(urlRequest: URLRequest(url: Uri.parse(urls)));
  }
  socketLivePriceData() {
    channelOpenOrder!.stream.listen(
          (data) {
        if (data != null || data != "null") {
          var decode = jsonDecode(data);

          if (mounted) {
            setState(() {
              String last = decode["data"]['lastPrice'].toString();
              String high24h = decode["data"]['highPrice24h'].toString();
              String valueCh = decode["data"]['price24hPcnt'].toString();

              double val = double.parse(last) - double.parse(high24h);
              double lastChangge = (val / double.parse(high24h)) * 100;

              for (int m = 0; m < marketList.length; m++) {
                if (marketList[m].name.toString().toLowerCase() ==
                    decode["data"]['symbol'].toString().toLowerCase()) {
                  marketList[m].last = last;
                  marketList[m].high=high24h.toString();
                  marketList[m].change = lastChangge;
                  changePercentage = marketList[m].change.toString();
                }
              }
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
            // spotOption=false;
            // marginOption=false;
            // futureOption=true;
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
          livePrice = futuretradePair[0].markPrice.toString();
          //priceController.text=livePrice;

          FuturefirstCoin = futureselectPair!.symbol.toString();
          // getPairDetail(FuturefirstCoin);
          // getminimubuyDetail(FuturefirstCoin);
          FuturesecondCoin = futureselectPair!.symbol.toString();
          //getBalance(FuturefirstCoin);


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

          //currentSymbol = futureselectPair!.symbol!.toString();
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
  socketData() {
    channelOpenOrder!.stream.listen(
          (data) {
        if (data != null || data != "null") {
          var decode = jsonDecode(data);
          print(decode);
          if (mounted) {
            setState(() {
              if (decode['type'].toString() == "snapshot") {
                if (type=="spot") {
                  if (decode["data"][0]["s"].toString() ==
                      selectPair!.symbol.toString()) {
                    livePrice = decode['data'][0]['p'].toString();
                    print(decode['data'][0]['p']);

                    //priceController.text=livePrice;
                    print("livePrice");
                    print(selectPair!.symbol.toString());
                    print(livePrice);
                  }
                } else if (decode["data"][0]["s"].toString() ==
                    futureselectPair!.symbol.toString()) {
                  livePrice = decode['data'][0]['p'].toString();
                  //priceController.text=livePrice;
                  print("Future livePrice");
                  print(futureselectPair!.symbol.toString());
                  print(livePrice);
                }
              } else {
                if (type=="spot") {
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
      },
      onError: (error) => print("Err" + error),
    );
  }

  // socketData() {
  //   channelOpenOrder!.stream.listen(
  //         (data) {
  //       if (data != null || data != "null") {
  //         print("helooo");
  //         var decode = jsonDecode(data);
  //         // print(decode);
  //         if (mounted) {
  //           setState(() {
  //             socketLoader=false;
  //             if (decode['type'].toString() == "snapshot") {
  //               // if (spotOption || marginOption) {
  //                 if (decode["data"][0]["s"].toString() ==
  //                     selectPair!.symbol.toString()) {
  //                   livePrice = decode['data'][0]['p'].toString();
  //                   // priceController.text=livePrice;
  //                   print("livePrice");
  //                   //print(selectPair!.symbol.toString());
  //                   print(livePrice);
  //                 }
  //                else if (decode["data"][0]["s"].toString() ==
  //                   futureselectPair!.symbol.toString()) {
  //                 livePrice = decode['data'][0]['p'].toString();
  //                 //priceController.text=livePrice;
  //                 print("Future livePrice");
  //                 print(futureselectPair!.symbol.toString());
  //                 print(livePrice);
  //               }
  //             } else {
  //               // if (spotOption || marginOption) {
  //                 if (decode["data"]["s"].toString() ==
  //                     selectPair!.symbol.toString()) {
  //                   if (buyData.length > 30) {
  //                     buyData.removeRange(1, 15);
  //                     sellData.removeRange(1, 15);
  //                     // buyData.clear();
  //                     // sellData.clear();
  //                     // buyData = [];
  //                     // sellData = [];
  //                   }
  //                   //
  //                   var list1 = List<dynamic>.from(decode['data']['b']);
  //                   var list2 = List<dynamic>.from(decode['data']['a']);
  //                   for (int m = 0; m < list1.length; m++) {
  //                     if (double.parse(list1[m][1].toString()) > 0) {
  //                       buyData.add(BuySellData(
  //                         list1[m][0].toString(),
  //                         list1[m][1].toString(),
  //                       ));
  //                     }
  //                   }
  //                   for (int m = 0; m < list2.length; m++) {
  //                     if (list2[m].toString() != null ||
  //                         list2[m].toString() != "null") {
  //                       if (double.parse(list2[m][1].toString()) > 0) {
  //                         sellData.add(BuySellData(
  //                           list2[m][0].toString(),
  //                           list2[m][1].toString(),
  //                         ));
  //                       }
  //                     }
  //                   }
  //                 }
  //               //}
  //               else if (decode["data"]["s"].toString() ==
  //                   futureselectPair!.symbol.toString()) {
  //                 if (buyData.length > 30) {
  //                   buyData.removeRange(1, 15);
  //                   sellData.removeRange(1, 15);
  //                   // buyData.clear();
  //                   // sellData.clear();
  //                   // buyData = [];
  //                   // sellData = [];
  //                 }
  //                 //
  //                 var list1 = List<dynamic>.from(decode['data']['b']);
  //                 var list2 = List<dynamic>.from(decode['data']['a']);
  //                 for (int m = 0; m < list1.length; m++) {
  //                   if (double.parse(list1[m][1].toString()) > 0) {
  //                     buyData.add(BuySellData(
  //                       list1[m][0].toString(),
  //                       list1[m][1].toString(),
  //                     ));
  //                   }
  //                 }
  //                 for (int m = 0; m < list2.length; m++) {
  //                   if (list2[m].toString() != null ||
  //                       list2[m].toString() != "null") {
  //                     if (double.parse(list2[m][1].toString()) > 0) {
  //                       sellData.add(BuySellData(
  //                         list2[m][0].toString(),
  //                         list2[m][1].toString(),
  //                       ));
  //                     }
  //                   }
  //                 }
  //               }
  //             }
  //           });
  //         }
  //
  //         // print("Mano");
  //       }
  //     },
  //     onDone: () async {
  //       await Future.delayed(Duration(seconds: 10));
  //       var messageJSON;
  //       messageJSON = {
  //         "op": "subscribe",
  //         "args": arrData
  //       };
  //       channelOpenOrder = IOWebSocketChannel.connect(
  //         Uri.parse("wss://stream.bybit.com/v5/public/spot"),);
  //
  //       channelOpenOrder!.sink.add(json.encode(messageJSON));
  //       socketData();
  //     },
  //     onError: (error) => print("Err" + error),
  //   );
  // }

  socketFutureData() {
    channelFutureOpenOrder!.stream.listen(
          (data) {
        if (data != null || data != "null") {
          var decode = jsonDecode(data);
          // print(decode);
          if (mounted) {
            setState(() {
              socketLoader=false;
              coinPrice = decode["data"]['lastPrice'].toString();
              coinhigh24h = decode["data"]['highPrice24h'].toString();
              coinlow24l = decode["data"]['lowPrice24h'].toString();
              coinAskP = decode["data"]['turnover24h'].toString();
              coinBitP = decode["data"]['volume24h'].toString();
              double val = double.parse(coinPrice) - double.parse(coinhigh24h);
              double lastChangge = (val / double.parse(coinhigh24h)) * 100;
              // for (int m = 0; m < marketFutureList.length; m++) {
              //   if (marketFutureList[m].name.toString().toLowerCase() ==
              //       decode["data"]['symbol'].toString().toLowerCase()) {
              //     marketFutureList[m].last = last;
              //     marketFutureList[m].change = lastChangge;
              //     marketFutureList[m].high = high24h;
              //     marketFutureList[m].low = low24h;
              //     marketFutureList[m].askP = askPrice;
              //     marketFutureList[m].bitP = bitPrice;
              //   }
              // }
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

  dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
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
            "Details",
            style: CustomWidget(context: context)
                .CustomSizedTextStyle(
                18.0,
                Theme.of(context).focusColor,
                FontWeight.w600,
                'FontRegular'),
          ),
          centerTitle: true,
          // actions: [
          //   Container(
          //     padding: EdgeInsets.only(right: 10.0),
          //     child:  Row(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //
          //         const SizedBox(width: 10.0,),
          //         InkWell(
          //           child: Icon(
          //             Icons.info_outline,
          //             size: 20.0,
          //             color: Theme.of(context).focusColor,
          //           ),
          //         ),
          //       ],
          //     ),
          //   )
          // ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 0.0),
            child: SingleChildScrollView(
              controller: _controller,
              physics: ScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Container(
                            //     padding: EdgeInsets.all(1.0),
                            //     decoration: BoxDecoration(
                            //       shape: BoxShape.circle,
                            //     ),
                            //     child: Image.asset(
                            //       // marketList[index].image.toString(),
                            //       "assets/icons/btc.svg",
                            //       height: 35.0,
                            //       width: 20,
                            //       // color: Theme.of(context).disabledColor,
                            //     ),
                            //   ),
                            //   const SizedBox(
                            //     width: 10.0,
                            //   ),
                            Text(
                              widget.coinName.toString(),
                              style: CustomWidget(context: context).CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).focusColor,
                                  FontWeight.w700,
                                  'FontRegular'),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(width: 5.0,),
                            GestureDetector(child: selectedfav==true?Icon(Icons.star,color: Colors.orangeAccent,size: 22,):Icon(Icons.star_outline_sharp,color: Colors.orangeAccent,size: 22,),onTap: () {
                              setState(() {
                                selectedfav=!selectedfav;
                                loading=true;
                                if(widget.tradetype=="linear"){
                                  addFutureFavourite(selectedfav.toString(), futureselectPair!.symbol.toString()??"");
                                }
                                else{
                                  addFavourite(selectedfav.toString(), selectPair!.symbol.toString()??"");
                                }


                              });
                            },),
                            Container(padding: EdgeInsets.all(4),decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                                color:  double.parse(widget.coinDiference.toString())>0?
                                Theme.of(context).indicatorColor.withOpacity(0.3):Theme.of(context).hoverColor.withOpacity(0.3)),child:Text(
                              double.parse(widget.coinDiference.toString()).toStringAsFixed(2)+"%",
                              style: CustomWidget(context: context).CustomSizedTextStyle(
                                  10.0,
                                  double.parse(widget.coinDiference.toString())>0?
                                  Theme.of(context).indicatorColor:Theme.of(context).hoverColor,
                                  FontWeight.w700,
                                  'FontRegular'),
                              textAlign: TextAlign.start,
                            ) ,)


                          ],
                        ),
                        const SizedBox(height: 5.0,),
                        Text(
                          "\$" + double.parse(livePrice.toString()??"0.0").toStringAsFixed(4),
                          style: CustomWidget(context: context).CustomSizedTextStyle(
                              16.0,
                              Theme.of(context).focusColor,
                              FontWeight.w700,
                              'FontRegular'),
                          textAlign: TextAlign.start,
                        ),
                        ],),
                          Column(children: [
                          RichText(text: TextSpan(children: [
                            TextSpan(text: "24h High",style:CustomWidget(context: context).CustomSizedTextStyle(
                                12.0,
                                Theme.of(context).focusColor.withOpacity(0.5),
                                FontWeight.w600,
                                'FontRegular'),),
                            TextSpan(text:"    ",style:CustomWidget(context: context).CustomSizedTextStyle(
                                11.0,
                                Theme.of(context).focusColor,
                                FontWeight.w600,
                                'FontRegular'),),
                TextSpan(text:"\$" + double.parse(coinhigh24h.toString()??"0.0").toStringAsFixed(4),style:CustomWidget(context: context).CustomSizedTextStyle(
                    11.0,
                    Theme.of(context).focusColor,
                    FontWeight.w600,
                    'FontRegular'),),
              ]),),
                            const SizedBox(height: 5.0,),
                          RichText(text: TextSpan(children: [
                              TextSpan(text: "24h Low",style:CustomWidget(context: context).CustomSizedTextStyle(
                                  12.0,
                                  Theme.of(context).focusColor.withOpacity(0.5),
                                  FontWeight.w600,
                                  'FontRegular'),),
                              TextSpan(text:"    ",style:CustomWidget(context: context).CustomSizedTextStyle(
                                  11.0,
                                  Theme.of(context).focusColor,
                                  FontWeight.w600,
                                  'FontRegular'),),
                              TextSpan(text: "\$" + double.parse(coinlow24l.toString()??"0.0").toStringAsFixed(4),style:CustomWidget(context: context).CustomSizedTextStyle(
                                  11.0,
                                  Theme.of(context).focusColor,
                                  FontWeight.w600,
                                  'FontRegular'),),
                            ]),),
                          ],)
                        ],),
                        // const SizedBox(height: 5.0,),
                        // Text(
                        //   double.parse(coinDiference.toString()??"0.0").toStringAsFixed(2)+ " %",
                        //   style: CustomWidget(context: context).CustomSizedTextStyle(
                        //       12.0,
                        //       double.parse(coinDiference.toString()) >= 0
                        //           ? Theme.of(context)
                        //           .indicatorColor
                        //           : Theme.of(context).hoverColor,
                        //       FontWeight.w700,
                        //       'FontRegular'),
                        //   textAlign: TextAlign.start,
                        // ),
                        const SizedBox(height: 20.0,),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.60,
                            child: InAppWebView(
                              initialUrlRequest: URLRequest(
                                  url: Uri.parse(
                                      "https://app.imperialx.exchange/chart/"+widget.coinName)),

                              onWebViewCreated: (controller){
                                webViewController = controller;
                              },
                              initialOptions: InAppWebViewGroupOptions(
                                crossPlatform: InAppWebViewOptions(
                                  supportZoom: true,  // Enable zoom
                                  javaScriptEnabled: true,  // Enable JavaScript
                                  useOnDownloadStart: true,  // Enable download start event
                                ),
                                android: AndroidInAppWebViewOptions(
                                  builtInZoomControls: true,  // Show zoom controls
                                  displayZoomControls: true,  // Display zoom controls on screen
                                ),
                              ),
                              onReceivedServerTrustAuthRequest: (controller, challenge) async {
                                print(challenge);
                                return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
                              },
                            )
                          // child: WebViewWidget(controller: webcontroller),
                        ),
                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   height: MediaQuery.of(context).size.height * 0.4,
                        //   decoration: BoxDecoration(
                        //     image: DecorationImage(
                        //       image: AssetImage('assets/menu/chart.png'),
                        //       fit: BoxFit.fill,
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 20.0,),
                        // Container(
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         children: [
                        //           InkWell(
                        //             onTap: (){
                        //               setState(() {
                        //                 info = true;
                        //                 earn = false;
                        //               });
                        //             },
                        //             child:  Container(
                        //               alignment: Alignment.center,
                        //               padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 8.0),
                        //               decoration: info ? BoxDecoration(
                        //                 borderRadius: BorderRadius.circular(6.0),
                        //                 color: Theme.of(context).canvasColor,
                        //               ) : BoxDecoration(),
                        //               child:  Text(
                        //                 "Info",
                        //                 style: CustomWidget(context: context)
                        //                     .CustomSizedTextStyle(
                        //                     14.0,
                        //                     info ? Theme.of(context).disabledColor: Theme.of(context).dividerColor,
                        //                     info ? FontWeight.w600 : FontWeight.w400,
                        //                     'FontRegular'),
                        //               ),
                        //             ),
                        //           ),
                        //           const SizedBox(width: 15.0,),
                        //           InkWell(
                        //             onTap: (){
                        //               setState(() {
                        //                 info = false;
                        //                 earn = true;
                        //               });
                        //             },
                        //             child: Container(
                        //               alignment: Alignment.center,
                        //               padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 8.0),
                        //               decoration: earn?  BoxDecoration(
                        //                 borderRadius: BorderRadius.circular(6.0),
                        //                 color: Theme.of(context).canvasColor,
                        //               ): BoxDecoration(),
                        //               child:  Text(
                        //                 "Earn",
                        //                 style: CustomWidget(context: context)
                        //                     .CustomSizedTextStyle(
                        //                     14.0,
                        //                     earn? Theme.of(context).disabledColor : Theme.of(context).dividerColor,
                        //                     earn?  FontWeight.w600 : FontWeight.w400,
                        //                     'FontRegular'),
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //       const SizedBox(height: 20.0,),
                        //       info ? Container(
                        //         padding: EdgeInsets.only(right: 10.0, left: 10.0),
                        //         child: Column(
                        //           children: [
                        //             Row(
                        //               crossAxisAlignment: CrossAxisAlignment.center,
                        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 Column(
                        //                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                   children: [
                        //                     Text(
                        //                       "Best ask price",
                        //                       style: CustomWidget(context: context).CustomSizedTextStyle(
                        //                           12.0,
                        //                           Theme.of(context).focusColor.withOpacity(0.6),
                        //                           FontWeight.w700,
                        //                           'FontRegular'),
                        //                       textAlign: TextAlign.start,
                        //                     ),
                        //                     const SizedBox(height: 5.0,),
                        //                     Text(
                        //                       "\$ "+double.parse(coinAskP.toString()).toStringAsFixed(2),
                        //                       style: CustomWidget(context: context).CustomSizedTextStyle(
                        //                           12.0,
                        //                           Theme.of(context).focusColor,
                        //                           FontWeight.w700,
                        //                           'FontRegular'),
                        //                       textAlign: TextAlign.start,
                        //                     ),
                        //                   ],
                        //                 ),
                        //                 Column(
                        //                   crossAxisAlignment: CrossAxisAlignment.end,
                        //                   children: [
                        //                     Text(
                        //                       "Best bid price",
                        //                       style: CustomWidget(context: context).CustomSizedTextStyle(
                        //                           12.0,
                        //                           Theme.of(context).focusColor.withOpacity(0.6),
                        //                           FontWeight.w700,
                        //                           'FontRegular'),
                        //                       textAlign: TextAlign.start,
                        //                     ),
                        //                     const SizedBox(height: 5.0,),
                        //                     Text(
                        //                       "\$ "+double.parse(coinBitP.toString()).toStringAsFixed(2),
                        //                       style: CustomWidget(context: context).CustomSizedTextStyle(
                        //                           12.0,
                        //                           Theme.of(context).focusColor,
                        //                           FontWeight.w700,
                        //                           'FontRegular'),
                        //                       textAlign: TextAlign.start,
                        //                     ),
                        //                   ],
                        //                 ),
                        //
                        //               ],
                        //             ),
                        //             const SizedBox(height: 15.0,),
                        //             Row(
                        //               crossAxisAlignment: CrossAxisAlignment.center,
                        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 Column(
                        //                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                   children: [
                        //                     Text(
                        //                       "24h volume",
                        //                       style: CustomWidget(context: context).CustomSizedTextStyle(
                        //                           12.0,
                        //                           Theme.of(context).focusColor.withOpacity(0.6),
                        //                           FontWeight.w700,
                        //                           'FontRegular'),
                        //                       textAlign: TextAlign.start,
                        //                     ),
                        //                     const SizedBox(height: 5.0,),
                        //                     Text(
                        //                       "\$ "+double.parse(coinhigh24h.toString()).toStringAsFixed(2),
                        //                       style: CustomWidget(context: context).CustomSizedTextStyle(
                        //                           12.0,
                        //                           Theme.of(context).focusColor,
                        //                           FontWeight.w700,
                        //                           'FontRegular'),
                        //                       textAlign: TextAlign.start,
                        //                     ),
                        //                   ],
                        //                 ),
                        //                 Column(
                        //                   crossAxisAlignment: CrossAxisAlignment.end,
                        //                   children: [
                        //                     Text(
                        //                       "24l volume",
                        //                       style: CustomWidget(context: context).CustomSizedTextStyle(
                        //                           12.0,
                        //                           Theme.of(context).focusColor.withOpacity(0.6),
                        //                           FontWeight.w700,
                        //                           'FontRegular'),
                        //                       textAlign: TextAlign.start,
                        //                     ),
                        //                     const SizedBox(height: 5.0,),
                        //                     Text(
                        //                       // "\$328.37",
                        //                       "\$ "+double.parse(coinlow24l.toString()).toStringAsFixed(2),
                        //                       style: CustomWidget(context: context).CustomSizedTextStyle(
                        //                           12.0,
                        //                           Theme.of(context).focusColor,
                        //                           FontWeight.w700,
                        //                           'FontRegular'),
                        //                       textAlign: TextAlign.start,
                        //                     ),
                        //                   ],
                        //                 ),
                        //
                        //               ],
                        //             )
                        //           ],
                        //         ),
                        //       ) : Container(
                        //         height: MediaQuery.of(context).size.height * 0.15,
                        //         decoration: BoxDecoration(
                        //           color: Theme.of(context).primaryColor,
                        //         ),
                        //         child: Center(
                        //           child: Text(
                        //             " No records Found..!",
                        //             style: TextStyle(
                        //               fontFamily: "FontRegular",
                        //               color: Theme.of(context).focusColor,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                      ],
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.end,children: [
                    GestureDetector(onTap: () {
                      print("taps $coinName");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TradeScreen(selectedcoin: coinName,fromtype: type,)));
                    },child:Container(width: MediaQuery.of(context).size.width*0.30,padding: EdgeInsets.all(10),decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Theme.of(context).indicatorColor),
                      child: Center(child: Text(
                      "Buy",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          16.0,
                          Theme.of(context).focusColor,
                          FontWeight.w700,
                          'FontRegular'),
                      textAlign: TextAlign.start,
                    ),),),),
                    const SizedBox(width: 10,),
                    GestureDetector(onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TradeScreen(selectedcoin: coinName,fromtype: type,)));
                    },child:Container(width: MediaQuery.of(context).size.width*0.30,padding: EdgeInsets.all(10),decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Theme.of(context).hoverColor),
                      child: Center(child: Text(
                        "Sell",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            16.0,
                            Theme.of(context).focusColor,
                            FontWeight.w700,
                            'FontRegular'),
                        textAlign: TextAlign.start,
                      ),),),),
                  ],),
                  const SizedBox(height: 10.0,),
                  marketWidget(),
                  const SizedBox(height: 20.0,),

                  loading
                      ? CustomWidget(context: context).loadingIndicator(
                    Theme.of(context).disabledColor,
                  )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
  addFavourite(String add,String pair) async {
    await apiUtils.addFavPairlist(add,pair).then((
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
  Widget marketWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment. spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(width: MediaQuery.of(context).size.width*0.40,child: Column(children: [
          socketLoader
              ? Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.2,
            child: CustomWidget(context: context)
                .loadingIndicator(CustomTheme
                .of(context)
                .focusColor),
          )
              : buyData.length > 0 && sellData.length > 0
              ?Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: type=="spot"?Text(
                  AppLocalizations.instance.text(
                      "loc_sell_trade_price") +
                      "\n(" +
                      secondCoin +
                      ")",
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      12.0,
                      Theme
                          .of(context)
                          .focusColor
                          .withOpacity(0.5),
                      FontWeight.w500,
                      'FontRegular'),
                ):Text(
                  AppLocalizations.instance.text(
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

                child: type=="spot"?Text(
                  AppLocalizations.instance.text(
                      "loc_sell_trade_Qty") +
                      "\n(" +
                      firstCoin +
                      ")",
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      12.0,
                      Theme
                          .of(context)
                          .focusColor
                          .withOpacity(0.5),
                      FontWeight.w500,
                      'FontRegular'),
                  textAlign: TextAlign.end,
                ):Text(
                  AppLocalizations.instance.text(
                      "loc_sell_trade_Qty"),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      12.0,
                      Theme
                          .of(context)
                          .focusColor
                          .withOpacity(0.5),
                      FontWeight.w500,
                      'FontRegular'),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 5.0,
          ),
          buyOption
              ? SizedBox(
              height: !sellOption
                  ? MediaQuery
                  .of(context)
                  .size
                  .height * 0.40
                  : MediaQuery
                  .of(context)
                  .size
                  .height * 0.23,
              child: buyData.length > 0
                  ? ListView.builder(
                  controller: controller,
                  itemCount: buyData.length,

                  itemBuilder:
                  ((BuildContext context, int index) {
                    return InkWell(
                        onTap: () {
                          setState(() {


                            // if (futureOption) {
                            //   FuturefirstCoin = futureselectPair!
                            //       .symbol
                            //       .toString();
                            //   FuturesecondCoin = futureselectPair!
                            //       .symbol
                            //       .toString();
                            // } else {
                            //
                            // }
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
                                  4),
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
                                  4),
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
                    : MediaQuery
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
          ],):Container(
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

        ],),),
        SizedBox(width: MediaQuery.of(context).size.width*0.40,child: Column(children: [
          socketLoader
              ? Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.2,
            child: CustomWidget(context: context)
                .loadingIndicator(CustomTheme
                .of(context)
                .focusColor),
          )
              : buyData.length > 0 && sellData.length > 0
              ?Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child:type=="spot"? Text(
                    AppLocalizations.instance.text(
                        "loc_sell_trade_price") +
                        "\n(" +
                        secondCoin +
                        ")",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme
                            .of(context)
                            .focusColor
                            .withOpacity(0.5),
                        FontWeight.w500,
                        'FontRegular'),
                  ):Text(
                    AppLocalizations.instance.text(
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

                  child: type=="spot"?Text(
                    AppLocalizations.instance.text(
                        "loc_sell_trade_Qty") +
                        "\n(" +
                        firstCoin +
                        ")",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme
                            .of(context)
                            .focusColor
                            .withOpacity(0.5),
                        FontWeight.w500,
                        'FontRegular'),
                    textAlign: TextAlign.end,
                  ):Text(
                    AppLocalizations.instance.text(
                        "loc_sell_trade_Qty"),
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        12.0,
                        Theme
                            .of(context)
                            .focusColor
                            .withOpacity(0.5),
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 5.0,
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
                                    2),
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
                                    2),
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
              //color: Colors.white,
            ),

          ],):Container(
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

        ],),),
      ],
    );
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
