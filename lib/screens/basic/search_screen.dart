import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imperial/common/custom_widget.dart';
import 'package:imperial/common/theme/custom_theme.dart';
import 'package:imperial/data/api_utils.dart';
import 'package:imperial/data/crypt_model/coin_list_model.dart';
import 'package:imperial/data/crypt_model/user_wallet_balance_model.dart';
import 'package:web_socket_channel/io.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  APIUtils apiUtils = APIUtils();
  List<UserWalletResult> coinList= [];

  CoinList? details;
  IOWebSocketChannel? channelOpenOrder;

  bool loading = false;
  ScrollController controller = ScrollController();
  List arrData = [];

  List<CoinList> tradePairListAll = [];
  List<MarketDetailsList> marketList = [];
  List<MarketDetailsList> coinLists = [];
  int count = 10;
  int countN = 0;
  var seen = Set<String>();
  Timer? timer,timerS;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loading = true;

    channelOpenOrder = IOWebSocketChannel.connect(Uri.parse("wss://stream.bybit.com/v5/public/spot"),);
    // getCoinListDta();

    getCoinList();
  }

  socketData() {
    channelOpenOrder!.stream.listen(
          (data) {
        if (data != null || data != "null") {
          var decode = jsonDecode(data);

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
        channelOpenOrder!.sink.add(json.encode(messageJSON));
        socketData();
      },
      onError: (error) => print("Err" + error),
    );
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


    print(count.toString()+"textM"+countN.toString());
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

  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: Theme.of(context).cardColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0.0,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor:Colors.transparent,
              focusColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Icon(
                  Icons.arrow_back,
                  size: 25.0,
                  color: CustomTheme.of(context).focusColor,
                ),
              ),
            ),
            centerTitle: true,
            title: Text(
             "Search",
              style: TextStyle(
                fontFamily: 'FontSpecial',
                color: CustomTheme
                    .of(context)
                    .focusColor,
                fontWeight: FontWeight.w500,
                fontSize: 17.0,
              ),
            ),
          ),
          body: Container(
              margin: EdgeInsets.only(left: 0, right: 0, bottom: 0.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                 color: Theme.of(context).cardColor,),
              child: loading
                  ? CustomWidget(context: context).loadingIndicator(
                      CustomTheme.of(context).disabledColor,
                    )
                  : Padding(
                    padding: EdgeInsets.only(
                      top: 5.0,
                      bottom: 10.0,
                      right: 15.0,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 45.0,
                          padding: EdgeInsets.only(left: 10.0),
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            controller: searchController,
                            focusNode: searchFocus,
                            style: TextStyle(
                              fontFamily: 'FontSpecial',
                              color: CustomTheme.of(context).focusColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0,
                            ),
                            enabled: true,
                            onEditingComplete: () {
                              setState(() {
                                searchFocus.unfocus();
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                coinLists = [];
                                for (int m = 0; m < marketList.length; m++) {
                                  if (marketList[m]
                                          .name
                                          .toString()
                                          .toLowerCase()
                                          .contains(value.toLowerCase()) ||
                                      marketList[m]
                                          .name
                                          .toString()
                                          .toLowerCase()
                                          .contains(value.toLowerCase())) {
                                    coinLists.add(marketList[m]);
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
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400),
                              filled: true,
                              fillColor: CustomTheme.of(context).canvasColor,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: CustomTheme.of(context)
                                        .primaryColorLight
                                        .withOpacity(0.5),
                                    width: 1.0),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: CustomTheme.of(context)
                                        .primaryColorLight
                                        .withOpacity(0.5),
                                    width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: CustomTheme.of(context)
                                        .primaryColorLight
                                        .withOpacity(0.5),
                                    width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: CustomTheme.of(context)
                                        .primaryColorLight
                                        .withOpacity(0.5),
                                    width: 1.0),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 0.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: coinLists.length,
                            shrinkWrap: true,
                            controller: controller,
                            itemBuilder: (BuildContext context, int index) {
                              // double data =
                              // double.parse(tradePairList[index].hrExchange.toString());
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: 10.0, left: 15.0),
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.24,
                                                        child: Text(
                                                          coinLists[index]
                                                              .name
                                                              .toString(),
                                                          style: CustomWidget(
                                                                  context:
                                                                      context)
                                                              .CustomSizedTextStyle(
                                                                  14.0,
                                                                  Theme.of(
                                                                          context)
                                                                      .focusColor,
                                                                  FontWeight
                                                                      .w500,
                                                                  'FontRegular'),
                                                          textAlign:
                                                              TextAlign.start,
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                                                      double.parse(
                                                              coinLists[index]
                                                                  .last
                                                                  .toString())
                                                          .toStringAsFixed(4),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          14.0,
                                                          Theme.of(context)
                                                              .focusColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Container(
                                                  width: 70,
                                                  child: Center(
                                                    child: Text(
                                                      double.parse(coinLists[
                                                                      index]
                                                                  .change
                                                                  .toString())
                                                              .toStringAsFixed(
                                                                  2) +
                                                          " %",
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomSizedTextStyle(
                                                              12,
                                                              Theme.of(context)
                                                                  .focusColor,
                                                              FontWeight.w400,
                                                              'FontRegular'),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    color: double.parse(coinLists[
                                                                    index]
                                                                .change
                                                                .toString()) >=
                                                            0
                                                        ? Theme.of(context)
                                                            .indicatorColor
                                                        : Theme.of(context)
                                                            .hoverColor,
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      top: 7.0, bottom: 7.0),
                                                )
                                              ],
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                            )),
                                            flex: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),),
        ));
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
            coinLists = marketList;


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
          channelOpenOrder = IOWebSocketChannel.connect(
            Uri.parse("wss://stream.bybit.com/v5/public/spot"),
          );
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