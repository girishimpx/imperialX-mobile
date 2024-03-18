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
  var array_dta;

  APIUtils apiUtils = APIUtils();
  ScrollController controller = ScrollController();

  List<CoinList> tradePairListAll = [];
  String changes = "";
  List arrData = [];
  // String high24h = "";

  List<String> marketAseetList = ["All Assets"];
  String selectedmarketAseet = "";
  IOWebSocketChannel? channelOpenOrder;
  bool spot = false;
  bool margin = false;
  bool future = false;
  List<MarketDetailsList> marketList = [];
  List<MarketDetailsList> coinList = [];
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  int indexVal = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading=true;
    getCoinList();
    channelOpenOrder = IOWebSocketChannel.connect(
        Uri.parse("wss://ws.okex.com:8443/ws/v5/public?brokerId=197"),
        pingInterval: Duration(seconds: 30));

    spot = true;
  }

  socketData() {
    channelOpenOrder!.stream.listen(
      (data) {
        if (data != null || data != "null") {
          var decode = jsonDecode(data);
          if (mounted) {
            setState(() {
              String last = decode["data"][0]['last'].toString();
              String high24h = decode["data"][0]['high24h'].toString();
              String low24h = decode["data"][0]['low24h'].toString();
              String askPrice = decode["data"][0]['askPx'].toString();
              String bitPrice = decode["data"][0]['bidPx'].toString();
              double val = double.parse(last) - double.parse(high24h);
              double lastChangge = (val / double.parse(high24h)) * 100;
              for (int m = 0; m < marketList.length; m++) {
                if (marketList[m].name.toString().toLowerCase() ==
                    decode["data"][0]['instId'].toString().toLowerCase()) {
                  marketList[m].last = decode["data"][0]['last'];
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
        print(messageJSON);

        channelOpenOrder = IOWebSocketChannel.connect(
            Uri.parse("wss://ws.okex.com:8443/ws/v5/public?brokerId=197"),
            pingInterval: Duration(seconds: 30));

        channelOpenOrder!.sink.add(json.encode(messageJSON));
        channelOpenOrder!.sink.add(json.encode(messageJSON));
        socketData();
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            spot = true;
                            margin = false;
                            future = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                              left: 12.0, right: 12.0, top: 6.0, bottom: 8.0),
                          decoration: spot
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  color: Theme.of(context).canvasColor,
                                )
                              : BoxDecoration(),
                          child: Text(
                            "All Assets",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    14.0,
                                    spot
                                        ? Theme.of(context).disabledColor
                                        : Theme.of(context).dividerColor,
                                    spot ? FontWeight.w600 : FontWeight.w400,
                                    'FontRegular'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            spot = false;
                            margin = true;
                            future = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                              left: 12.0, right: 12.0, top: 6.0, bottom: 8.0),
                          decoration: margin
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  color: Theme.of(context).canvasColor,
                                )
                              : BoxDecoration(),
                          child: Text(
                            "Favorites",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    14.0,
                                    margin
                                        ? Theme.of(context).disabledColor
                                        : Theme.of(context).dividerColor,
                                    margin ? FontWeight.w600 : FontWeight.w400,
                                    'FontRegular'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            spot = false;
                            margin = false;
                            future = true;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                              left: 12.0, right: 12.0, top: 6.0, bottom: 8.0),
                          decoration: future
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  color: Theme.of(context).canvasColor,
                                )
                              : BoxDecoration(),
                          child: Text(
                            "Top Gainers",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    14.0,
                                    future
                                        ? Theme.of(context).disabledColor
                                        : Theme.of(context).dividerColor,
                                    future ? FontWeight.w600 : FontWeight.w400,
                                    'FontRegular'),
                          ),
                        ),
                      )
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
                              coinList = [];
                              for (int m = 0; m < marketList.length; m++) {
                                if (marketList[m].name.toString().toLowerCase().contains(value.toLowerCase()) ||
                                    marketList[m].name.toString().toLowerCase().contains(value.toLowerCase())) {
                                  coinList.add(marketList[m]);
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
                    height: 15.0,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.22),
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
                                                "\$" +
                                                    double.parse(coinList[index]
                                                        .last
                                                        .toString())
                                                        .toStringAsFixed(4),
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
                                                    double.parse(coinList[index]
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
                                                      coinList[index]
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
                    )
                  : Container(
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

  getCoinList() {
    apiUtils.allCoinList("SPOT").then((CoinListModel loginData) {
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
            var messageJSON = {
              "channel": "tickers",
              "instId": tradePairListAll[m].data!.instId.toString(),
            };
            arrData.add(messageJSON);
          }
          print("Mano");
          print(arrData);
          loading = false;
          var messageJSON = {
            "op": "subscribe",
            "args": arrData,
          };
          channelOpenOrder = IOWebSocketChannel.connect(
              Uri.parse("wss://ws.okex.com:8443/ws/v5/public?brokerId=197"),
              pingInterval: Duration(seconds: 30));
          channelOpenOrder!.sink.add(json.encode(messageJSON));

          socketData();
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
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
