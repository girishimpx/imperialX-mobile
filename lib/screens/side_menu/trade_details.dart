import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:web_socket_channel/io.dart';

import '../../common/custom_widget.dart';
import '../../data/api_utils.dart';
import '../../data/crypt_model/coin_list_model.dart';
import '../market.dart';

class MarketTrade_Details extends StatefulWidget {
  final coinName;
  final coinPrice;
  final coinDiference;
  final coinhigh24h;
  final coinlow24l;
  final coinAskP;
  final coinBitP;

  const MarketTrade_Details({super.key, this.coinName, this.coinPrice, this.coinDiference, this.coinhigh24h, this.coinlow24l, this.coinAskP, this.coinBitP});

  @override
  State<MarketTrade_Details> createState() => _MarketTrade_DetailsState();
}

class _MarketTrade_DetailsState extends State<MarketTrade_Details> {

  bool loading = false;
  bool info = false;
  bool earn = false;
  IOWebSocketChannel? channelOpenOrder,channelFutureOpenOrder;

  APIUtils apiUtils = APIUtils();
  ScrollController _controller = ScrollController();
  List arrData = [];
  List arrFutureData = [];
  List<CoinList> tradePairListAll = [];
  InAppWebViewController? webViewController;
  String coinName="";
  String coinPrice="";
  String coinDiference="";
  String coinhigh24h="";
  String coinlow24l="";
  String coinAskP="";
  String coinBitP="";
  // String currentSymbol = "ADA-USDT";
  // String pair="ADA-USDT";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading=true;
    info = true;

    coinName=widget.coinName;
    coinPrice=widget.coinPrice;
    coinDiference=widget.coinDiference;
    coinhigh24h=widget.coinhigh24h;
    coinlow24l=widget.coinlow24l;
    coinAskP=widget.coinAskP;
    coinBitP=widget.coinBitP;

    var message1JSON = {
      "channel": "tickers",
      "instId": widget.coinName,
    };
    arrData.add(message1JSON);

  loading = false;
  var messageJSON = {
    "op": "subscribe",
    "args": arrData,
  };
    channelOpenOrder = IOWebSocketChannel.connect(Uri.parse("wss://stream.bybit.com/v5/public/spot"),);
    channelFutureOpenOrder = IOWebSocketChannel.connect(Uri.parse("wss://stream.bybit.com/v5/public/linear"),);

    socketData();
    socketFutureData();
    webViewController?.loadUrl(urlRequest: URLRequest(url: Uri.parse("https://app.imperialx.exchange/chart/"+widget.coinName),));

  }

  socketData() {
    channelOpenOrder!.stream.listen(
          (data) {
        if (data != null || data != "null") {
          print(data);
          var decode = jsonDecode(data);
          if (mounted) {
            setState(() {
               coinPrice = decode["data"][0]['last'].toString();
               coinhigh24h = decode["data"][0]['high24h'].toString();
               coinlow24l = decode["data"][0]['low24h'].toString();
               coinAskP = decode["data"][0]['askPx'].toString();
               coinBitP = decode["data"][0]['bidPx'].toString();
              double val = double.parse(coinPrice) - double.parse(coinhigh24h);
              double lastChangge = (val / double.parse(coinhigh24h)) * 100;
               coinDiference=lastChangge.toString();

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
        print(messageJSON);

        channelOpenOrder = IOWebSocketChannel.connect(
            Uri.parse("wss://stream.bybit.com/v5/public/spot"),
            pingInterval: Duration(seconds: 30));

        channelOpenOrder!.sink.add(json.encode(messageJSON));
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
          actions: [
            Container(
              padding: EdgeInsets.only(right: 10.0),
              child:  Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    child: Icon(
                      Icons.star_border_outlined,
                      size: 20.0,
                      color: Theme.of(context).focusColor,
                    ),
                  ),
                  const SizedBox(width: 10.0,),
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 0.0),
            child: SingleChildScrollView(
              controller: _controller,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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

                          ],
                        ),
                        const SizedBox(height: 5.0,),
                        Text(
                          "\$" + double.parse(coinPrice.toString()).toStringAsFixed(4),
                          style: CustomWidget(context: context).CustomSizedTextStyle(
                              18.0,
                              Theme.of(context).focusColor,
                              FontWeight.w700,
                              'FontRegular'),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 5.0,),
                        Text(
                          double.parse(coinDiference.toString()).toStringAsFixed(2)+ " %",
                          style: CustomWidget(context: context).CustomSizedTextStyle(
                              12.0,
                              double.parse(coinDiference.toString()) >= 0
                                  ? Theme.of(context)
                                  .indicatorColor
                                  : Theme.of(context).hoverColor,
                              FontWeight.w700,
                              'FontRegular'),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 20.0,),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: InAppWebView(
                              initialUrlRequest: URLRequest(
                                  url: Uri.parse(
                                      "https://app.imperialx.exchange/chart/"+widget.coinName)),
                              onWebViewCreated: (controller){
                                webViewController = controller;
                              },
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
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        info = true;
                                        earn = false;
                                      });
                                    },
                                    child:  Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 8.0),
                                      decoration: info ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(6.0),
                                        color: Theme.of(context).canvasColor,
                                      ) : BoxDecoration(),
                                      child:  Text(
                                        "Info",
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            14.0,
                                            info ? Theme.of(context).disabledColor: Theme.of(context).dividerColor,
                                            info ? FontWeight.w600 : FontWeight.w400,
                                            'FontRegular'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15.0,),
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        info = false;
                                        earn = true;
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 8.0),
                                      decoration: earn?  BoxDecoration(
                                        borderRadius: BorderRadius.circular(6.0),
                                        color: Theme.of(context).canvasColor,
                                      ): BoxDecoration(),
                                      child:  Text(
                                        "Earn",
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            14.0,
                                            earn? Theme.of(context).disabledColor : Theme.of(context).dividerColor,
                                            earn?  FontWeight.w600 : FontWeight.w400,
                                            'FontRegular'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0,),
                              info ? Container(
                                padding: EdgeInsets.only(right: 10.0, left: 10.0),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Best ask price",
                                              style: CustomWidget(context: context).CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context).focusColor.withOpacity(0.6),
                                                  FontWeight.w700,
                                                  'FontRegular'),
                                              textAlign: TextAlign.start,
                                            ),
                                            const SizedBox(height: 5.0,),
                                            Text(
                                              "\$ "+double.parse(coinAskP.toString()).toStringAsFixed(2),
                                              style: CustomWidget(context: context).CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context).focusColor,
                                                  FontWeight.w700,
                                                  'FontRegular'),
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Best bid price",
                                              style: CustomWidget(context: context).CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context).focusColor.withOpacity(0.6),
                                                  FontWeight.w700,
                                                  'FontRegular'),
                                              textAlign: TextAlign.start,
                                            ),
                                            const SizedBox(height: 5.0,),
                                            Text(
                                              "\$ "+double.parse(coinBitP.toString()).toStringAsFixed(2),
                                              style: CustomWidget(context: context).CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context).focusColor,
                                                  FontWeight.w700,
                                                  'FontRegular'),
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                    const SizedBox(height: 15.0,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "24h volume",
                                              style: CustomWidget(context: context).CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context).focusColor.withOpacity(0.6),
                                                  FontWeight.w700,
                                                  'FontRegular'),
                                              textAlign: TextAlign.start,
                                            ),
                                            const SizedBox(height: 5.0,),
                                            Text(
                                              "\$ "+double.parse(coinhigh24h.toString()).toStringAsFixed(2),
                                              style: CustomWidget(context: context).CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context).focusColor,
                                                  FontWeight.w700,
                                                  'FontRegular'),
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "24l volume",
                                              style: CustomWidget(context: context).CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context).focusColor.withOpacity(0.6),
                                                  FontWeight.w700,
                                                  'FontRegular'),
                                              textAlign: TextAlign.start,
                                            ),
                                            const SizedBox(height: 5.0,),
                                            Text(
                                              // "\$328.37",
                                              "\$ "+double.parse(coinlow24l.toString()).toStringAsFixed(2),
                                              style: CustomWidget(context: context).CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context).focusColor,
                                                  FontWeight.w700,
                                                  'FontRegular'),
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),

                                      ],
                                    )
                                  ],
                                ),
                              ) : Container(
                                height: MediaQuery.of(context).size.height * 0.15,
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

                      ],
                    ),
                  ),

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
