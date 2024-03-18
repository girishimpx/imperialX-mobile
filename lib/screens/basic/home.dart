import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imperial/common/bottom/curved_bar/curved_action_bar.dart';
import 'package:imperial/common/bottom/fab_bar/fab_bottom_app_bar_item.dart';
import 'package:imperial/common/bottom/flutter_curved_bottom_nav_bar.dart';
import 'package:imperial/common/custom_widget.dart';
import 'package:imperial/data/crypt_model/common_model.dart';
import 'package:imperial/screens/basic/analytics.dart';
import 'package:imperial/screens/basic/profile_setting.dart';
import 'package:imperial/screens/basic/referral.dart';
import 'package:imperial/screens/basic/subscription.dart';
import 'package:imperial/screens/market.dart';
import 'package:imperial/screens/side_menu/side_menu.dart';
import 'package:web_socket_channel/io.dart';

import '../../common/card/constants.dart';
import '../../common/card/data.dart';
import '../../common/card/cool_swiper.dart';
import '../../common/theme/custom_theme.dart';
import '../../data/api_utils.dart';
import '../../data/crypt_model/coin_list_model.dart';
import '../../data/crypt_model/profile_model.dart';
import '../../data/crypt_model/trade_pair_model.dart';
import '../copy_trade.dart';
import '../copy_trade_history.dart';
import '../trade.dart';
import '../wallet.dart';
import 'account.dart';
import 'notification.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({Key? key}) : super(key: key);

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  final PageStorageBucket bucket = PageStorageBucket();
  int currentIndex = 0;
  int selectedIndex = 0;
  bool dashview = true;
  bool loading = false;
  Widget screen = Container();
  InAppWebViewController? webViewController;
  List<Widget> bottomPage = [
    Container(),
    Container(),
    Container(),
    Container()
  ];
  List<String> titleText = [
    "loc_side_home",
    "loc_side_market",
    "loc_side_trade",
    "loc_side_copy",
    "loc_side_profile"
  ];
  ScrollController controller = ScrollController();
  ScrollController _scrollController = ScrollController();
  PageController _pageController = PageController();

  List grid_name = [
    "Account",
    "Analytics",
    "Subscription",
    "History",
    "Referral",
    "Feed",
    "Support",
    "Settings"
  ];
  List grid_names = [
    "Bitcoin",
    "Ethereum",
  ];
  String coinname="BTC-USDT";

  List grid_img = [
    "assets/icons/user.svg",
    "assets/images/analytics.svg",
    "assets/images/subs.svg",
    "assets/images/his.svg",
    "assets/images/add_user.svg",
    "assets/images/feed.svg",
    "assets/images/speaker.svg",
    "assets/images/setting.svg",
  ];
  List grid_imgs = [
    "assets/icons/btc.svg",
    "assets/icons/eth.svg",
  ];

  APIUtils apiUtils = APIUtils();
  String name= "";
  List<CoinList> tradePairListAll = [];
  List<MarketDetailsList> marketList = [];
  List<String> marketAseetList = ["All Assets"];
  TradePairList? selectPair;
  List arrData = [];
  IOWebSocketChannel? channelOpenOrder;

  String firstCoin = "";
  String secondCoin = "";
  Timer? timer;

  int m=0;
  List<String> pairs=["BTC-USDT","ETH-USDT","XRP-USDT","LTC-USDT"];

  void onSelectItem(int index) async {
    setState(() {
      if (index == 0) {
        dashview = true;
      } else {
        dashview = false;
        currentIndex = index;
        selectedIndex = index;
        screen = bottomPage[index - 1];
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;

    timer = Timer.periodic(Duration(seconds: 30), (_) {
      setState(() {
        if(m==3)
          {
            m=0;

          }
        else{
          m=m+1;
        }
        coinname=pairs[m];

      });
    });
    coinname=pairs.first;
    profileDetails();
    getCoinList();
    verifysubAcc();
    walletDepoAdd();
    channelOpenOrder = IOWebSocketChannel.connect(
        Uri.parse("wss://ws.okex.com:8443/ws/v5/public?brokerId=197"),
        pingInterval: Duration(seconds: 30));

    webViewController?.loadUrl(
        urlRequest: URLRequest(
      url: Uri.parse("https://app.imperialx.exchange/dashboard/chart/"+coinname),
    ));
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
              double val = double.parse(last) - double.parse(high24h);
              double lastChangge = (val / double.parse(high24h)) * 100;
              for (int m = 0; m < marketList.length; m++) {
                if (marketList[m].name.toString().toLowerCase() ==
                    decode["data"][0]['instId'].toString().toLowerCase()) {
                  marketList[m].last = decode["data"][0]['last'];
                  marketList[m].change = lastChangge;
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
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
          toolbarHeight: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Theme.of(context).primaryColor,
            // Status bar brightness (optional)
            statusBarIconBrightness:
                Brightness.light, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
        ),
        body: CurvedNavBar(
          actionButton: CurvedActionBar(
              onTab: (value) {
                /// perform action here
                print(value);
              },
              activeIcon: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor, shape: BoxShape.circle),
                child:  SvgPicture.asset(
                  'assets/icons/trade.svg',
                  height: 30.0,
                  color: Theme.of(context).focusColor,
                ),
              ),
              inActiveIcon: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor, shape: BoxShape.circle),
                child:  SvgPicture.asset(
                  'assets/icons/trade.svg',
                  height: 30.0,
                  color: Theme.of(context).focusColor,
                ),
              ),
              text: ""),
          activeColor: Theme.of(context).disabledColor,
          navBarBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          inActiveColor:Theme.of(context).bottomAppBarColor,
          appBarItems: [
            FABBottomAppBarItem(
                activeIcon: SvgPicture.asset(
                  'assets/icons/home.svg',
                  color: Theme.of(context).disabledColor,
                ),
                inActiveIcon: SvgPicture.asset(
                  'assets/icons/home.svg',
                  color: Theme.of(context).bottomAppBarColor,
                ),

                text: 'Home'),
            FABBottomAppBarItem(
                activeIcon: SvgPicture.asset(
                  'assets/icons/market.svg',
                  color: Theme.of(context).disabledColor,
                ),
                inActiveIcon: SvgPicture.asset(
                  'assets/icons/market.svg',
                  color: Theme.of(context).bottomAppBarColor,
                ),
                text: 'Market'),
            FABBottomAppBarItem(
                activeIcon: SvgPicture.asset(
                  'assets/icons/copy.svg',
                  color: Theme.of(context).disabledColor,
                ),
                inActiveIcon: SvgPicture.asset(
                  'assets/icons/copy.svg',
                  color: Theme.of(context).bottomAppBarColor,
                ),
                text: 'Copy Trade'),
            FABBottomAppBarItem(
                activeIcon: SvgPicture.asset(
                  'assets/images/wallet.svg',
                  color: Theme.of(context).disabledColor,
                ),
                inActiveIcon: SvgPicture.asset(
                  'assets/images/wallet.svg',
                  color: Theme.of(context).bottomAppBarColor,
                ),
                text: 'Wallet'),
          ],
          bodyItems: [
            newHome(),
            MarketScreen(),
            // TradeScreen(),
            Copy_Trade(),
           Wallet_Screen()

          ],
          actionBarView: TradeScreen()
        )
      ),
    );
  }

  Widget newHome() {
    return Container(
        color: Theme.of(context).primaryColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
          child: Stack(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //     builder: (context) => SideMenu()));
                                  },
                                  child: CircleAvatar(
                                    maxRadius: 25,
                                    minRadius: 25,
                                    backgroundImage: AssetImage(
                                      "assets/icons/logo.png",
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Welcome Back,",
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context).disabledColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                      textAlign: TextAlign.start,
                                    ),
                                    // const SizedBox(
                                    //   height: 10.0,
                                    // ),
                                    Text(
                                      // "Carla Pascle",
                                      name.toString(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              18.0,
                                              Theme.of(context).focusColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => Notification_Screen()));
                                    },
                                    child: SvgPicture.asset(
                                      "assets/images/bell.svg",
                                      height: 25.0,
                                      fit: BoxFit.fill,
                                      color: Theme.of(context).focusColor,
                                    )),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) =>     Side_Menu_Setting()));
                                    },
                                    child: SvgPicture.asset(
                                      "assets/icons/user.svg",
                                      height: 25.0,
                                      fit: BoxFit.fill,
                                      color: Theme.of(context).focusColor,
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    marketList.length>0?      Container(
                      margin: EdgeInsets.only(top: 35.0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.24,
                      child: CoolSwiper(
                        children: List.generate(
                          marketList.length>0 ? 5 : 0,
                          (index) => Container(
                            height: Constants.cardHeight,
                            padding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).disabledColor,
                              image: DecorationImage(
                                  image: AssetImage("assets/images/back.png"),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  marketList[index].name.toString(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          20.0,
                                          Theme.of(context).focusColor,
                                          FontWeight.w700,
                                          'FontRegular'),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  "\$" + double.parse(marketList[index].last.toString()).toStringAsFixed(4),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          32.0,
                                          Theme.of(context).focusColor,
                                          FontWeight.w600,
                                          'FontRegular'),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  height: 25.0,
                                ),
                                Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                              onTap: () {},
                                              child: SvgPicture.asset(
                                                "assets/images/trade.svg",
                                                height: 20.0,
                                                fit: BoxFit.fill,
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor,
                                              )),
                                          const SizedBox(
                                            width: 3.0,
                                          ),
                                          Text(
                                            double.parse(marketList[index]
                                                .change
                                                .toString())
                                                .toStringAsFixed(2) +
                                                " %",
                                            style: CustomWidget(
                                                    context: context)
                                                .CustomSizedTextStyle(
                                                    14.0,
                                                double.parse(
                                                    marketList[index]
                                                        .change
                                                        .toString()) >=
                                                    0
                                                    ? Theme.of(context)
                                                    .indicatorColor
                                                    : Theme.of(context).hoverColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            "USD",
                                            style: CustomWidget(
                                                    context: context)
                                                .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme.of(context).cardColor,
                                                    FontWeight.w600,
                                                    'FontRegular'),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      // Image.asset("assets/images/btc.png",height: 80.0,width: 120.0,fit: BoxFit.contain),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ):Container()
                  ],
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            controller: _scrollController,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 25,
                              mainAxisSpacing: 4,
                            ),
                            // physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: grid_name.length,
                            itemBuilder: (BuildContext context, index) {
                              return InkWell(
                                onTap: () {
                                  if (index == 0) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => Side_Menu_Setting()));
                                  } else if (index== 1) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => Analytics_Screen()));
                                  } else if (index== 2) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => Subscription_Screen()));
                                  }  else if (index== 3) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => Copy_Trade_History()));
                                  }  else if (index== 4) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => Referral_Screen()));
                                  } else if (index== 7) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => Side_Menu_Setting()));
                                  }
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          grid_img[index].toString(),
                                          height: 28.0,
                                          color:
                                              Theme.of(context).disabledColor,
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          // AppLocalizations.instance.text("loc_widthdraw"),
                                          grid_name[index].toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  10.0,
                                                  Theme.of(context).focusColor,
                                                  FontWeight.w300,
                                                  'FontRegular'),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       "Top Coins",
                        //       style: CustomWidget(context: context)
                        //           .CustomSizedTextStyle(
                        //               16.0,
                        //               Theme.of(context).focusColor,
                        //               FontWeight.w700,
                        //               'FontRegular'),
                        //       textAlign: TextAlign.center,
                        //     ),
                        //     Text(
                        //       "Scroll all",
                        //       style: CustomWidget(context: context)
                        //           .CustomSizedTextStyle(
                        //               12.0,
                        //               Theme.of(context).disabledColor,
                        //               FontWeight.w400,
                        //               'FontRegular'),
                        //       textAlign: TextAlign.center,
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(
                        //   height: 20.0,
                        // ),
                        // Container(
                        //   child: GridView.builder(
                        //     padding: EdgeInsets.zero,
                        //     controller: _scrollController,
                        //     gridDelegate:
                        //         const SliverGridDelegateWithFixedCrossAxisCount(
                        //       crossAxisCount: 2,
                        //       crossAxisSpacing: 20,
                        //       mainAxisSpacing: 20,
                        //       childAspectRatio: 2.5 / 3,
                        //     ),
                        //     // physics: ScrollPhysics(),
                        //     shrinkWrap: true,
                        //     itemCount: 2,
                        //     itemBuilder: (BuildContext context, index) {
                        //       return InkWell(
                        //         onTap: () {},
                        //         child: Container(
                        //             padding: EdgeInsets.only(
                        //                 top: 7.0,
                        //                 bottom: 7.0,
                        //                 right: 15.0,
                        //                 left: 15.0),
                        //             decoration: BoxDecoration(
                        //               color: Theme.of(context).splashColor,
                        //               border: Border.all(
                        //                 width: 1.0,
                        //                 color: Theme.of(context).disabledColor,
                        //               ),
                        //               borderRadius: BorderRadius.circular(10.0),
                        //             ),
                        //             alignment: Alignment.center,
                        //             child: Column(
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.start,
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.center,
                        //               children: [
                        //                 Row(
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.center,
                        //                   children: [
                        //                     Container(
                        //                       padding: EdgeInsets.all(1.0),
                        //                       decoration: BoxDecoration(
                        //                         shape: BoxShape.circle,
                        //                       ),
                        //                       child: SvgPicture.asset(
                        //                         grid_imgs[index].toString(),
                        //                         height: 28.0,
                        //                         // color: Theme.of(context).disabledColor,
                        //                       ),
                        //                     ),
                        //                     SizedBox(
                        //                       width: 6.0,
                        //                     ),
                        //                     Text(
                        //                       // AppLocalizations.instance.text("loc_widthdraw"),
                        //                       grid_names[index].toString(),
                        //                       style:
                        //                           CustomWidget(context: context)
                        //                               .CustomSizedTextStyle(
                        //                                   14,
                        //                                   Theme.of(context)
                        //                                       .focusColor,
                        //                                   FontWeight.w400,
                        //                                   'FontRegular'),
                        //                       textAlign: TextAlign.center,
                        //                     ),
                        //                   ],
                        //                 ),
                        //                 SizedBox(
                        //                   height: 5.0,
                        //                 ),
                        //                 Text(
                        //                   "\$ 45.898,16",
                        //                   style: CustomWidget(context: context)
                        //                       .CustomSizedTextStyle(
                        //                           16,
                        //                           Theme.of(context).shadowColor,
                        //                           FontWeight.w400,
                        //                           'FontRegular'),
                        //                   textAlign: TextAlign.center,
                        //                 ),
                        //                 const SizedBox(
                        //                   height: 5.0,
                        //                 ),
                        //                 Row(
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.center,
                        //                   children: [
                        //                     Text(
                        //                       "24,55%",
                        //                       style: CustomWidget(
                        //                               context: context)
                        //                           .CustomSizedTextStyle(
                        //                               16,
                        //                               Theme.of(context)
                        //                                   .secondaryHeaderColor,
                        //                               FontWeight.w400,
                        //                               'FontRegular'),
                        //                       textAlign: TextAlign.center,
                        //                     ),
                        //                     Icon(
                        //                       Icons.arrow_drop_up,
                        //                       size: 18.0,
                        //                       color: Theme.of(context)
                        //                           .secondaryHeaderColor,
                        //                     )
                        //                   ],
                        //                 ),
                        //                 const SizedBox(
                        //                   height: 10.0,
                        //                 ),
                        //                 SvgPicture.asset(
                        //                   "assets/icons/line.svg",
                        //                   fit: BoxFit.fill,
                        //                 )
                        //               ],
                        //             )),
                        //       );
                        //     },
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 20.0,
                        // ),
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       "44.826,12 USDT",
                        //       style: CustomWidget(context: context)
                        //           .CustomSizedTextStyle(
                        //               24.0,
                        //               Theme.of(context).focusColor,
                        //               FontWeight.w600,
                        //               'FontRegular'),
                        //       textAlign: TextAlign.center,
                        //     ),
                        //     Container(
                        //       padding: EdgeInsets.only(
                        //           left: 8.0, right: 8.0, top: 1.0, bottom: 1.0),
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(25.0),
                        //         color: Theme.of(context).canvasColor,
                        //       ),
                        //       child: Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           Icon(
                        //             Icons.arrow_drop_up,
                        //             size: 18.0,
                        //             color:
                        //                 Theme.of(context).secondaryHeaderColor,
                        //           ),
                        //           Text(
                        //             "24,55%",
                        //             style: CustomWidget(context: context)
                        //                 .CustomSizedTextStyle(
                        //                     12,
                        //                     Theme.of(context)
                        //                         .secondaryHeaderColor,
                        //                     FontWeight.w400,
                        //                     'FontRegular'),
                        //             textAlign: TextAlign.center,
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(
                        //   height: 20.0,
                        // ),
                        Container(
                          height: 145.0,
                          child: marketList.length>0 ? ListView.builder(
                            itemCount: marketList.length>0? 100 : 0,
                            shrinkWrap: true,
                            controller: controller,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                children: [
                                  Container(
                                      // width: MediaQuery.of(context).size.width * 0.4,
                                      decoration: BoxDecoration(
                                        // color: Theme.of(context).splashColor,
                                        // border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,),
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerLeft,
                                          colors: <Color>[
                                            Theme.of(context).disabledColor,
                                            Theme.of(context)
                                                .disabledColor
                                                .withOpacity(0.5),
                                            Theme.of(context).primaryColor,
                                          ],
                                          tileMode: TileMode.mirror,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      alignment: Alignment.center,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 8.0,
                                                right: 10.0,
                                                left: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(1.0),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: SvgPicture.asset(
                                                        "assets/icons/btc.svg",
                                                        height: 20.0,
                                                        // color: Theme.of(context).disabledColor,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 4.0,
                                                    ),
                                                    Text(
                                                      // AppLocalizations.instance.text("loc_widthdraw"),
                                                      marketList[index].name.toString(),
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomSizedTextStyle(
                                                              9,
                                                              Theme.of(context)
                                                                  .focusColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  //"12,32 USD",
                                                "\$" + double.parse(marketList[index].last.toString()).toStringAsFixed(4),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          13,
                                                          Theme.of(context)
                                                              .focusColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                // Row(
                                                //   crossAxisAlignment:
                                                //       CrossAxisAlignment.center,
                                                //   children: [
                                                //     Icon(
                                                //       Icons.arrow_drop_up,
                                                //       size: 12.0,
                                                //       color: Theme.of(context)
                                                //           .secondaryHeaderColor,
                                                //     ),
                                                //     Text(
                                                //       // "+1.31%",
                                                //       double.parse(marketList[index].change.toString()).toStringAsFixed(2) + " %",
                                                //       style: CustomWidget(
                                                //               context: context)
                                                //           .CustomSizedTextStyle(
                                                //               9,
                                                //               Theme.of(context)
                                                //                   .secondaryHeaderColor,
                                                //               FontWeight.w500,
                                                //               'FontRegular'),
                                                //       textAlign:
                                                //           TextAlign.center,
                                                //     ),
                                                //   ],
                                                // ),
                                                Text(
                                                  // "+1.31%",
                                                  double.parse(marketList[index].change.toString()).toStringAsFixed(2) + " %",
                                                  style: CustomWidget(
                                                      context: context)
                                                      .CustomSizedTextStyle(
                                                      9,
                                                      double.parse(marketList[index].change.toString()) >= 0 ? Theme.of(context).indicatorColor : Theme.of(context).hoverColor,
                                                      FontWeight.w500,
                                                      'FontRegular'),
                                                  textAlign:
                                                  TextAlign.center,
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SvgPicture.asset(
                                            "assets/icons/map.svg",
                                            height: 60.0,
                                            fit: BoxFit.fitWidth,
                                          )
                                        ],
                                      )),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                ],
                              );
                            },
                          ) : Container(
                            height: MediaQuery.of(context).size.height * 0.2,
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
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: 400.0,
                            child: Stack(
                              children: [

                                InAppWebView(
                                  initialUrlRequest: URLRequest(
                                      url: Uri.parse("https://app.imperialx.exchange/dashboard/chart/"+coinname,)),
                                  onWebViewCreated: (controller){
                                    webViewController = controller;
                                  },
                                  onReceivedServerTrustAuthRequest: (controller, challenge) async {
                                    print(challenge);
                                    return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
                                  },
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20.0),

                                  child:  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Theme.of(context).disabledColor,width: 2.0),
                                        borderRadius: BorderRadius.circular(10.0)
                                      ),
                                      child: Text(
                                        coinname,
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            16.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w700,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                    )
                                  ),
                                ),
                              ],
                            )
                          // child: WebViewWidget(controller: webcontroller),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "Top Trading",
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                                  16.0,
                                  Theme.of(context).focusColor,
                                  FontWeight.w700,
                                  'FontRegular'),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        marketList.length>0 ? ListView.builder(
                          // itemCount: tradePairList.length,
                          itemCount: marketList.length> 0 ?10 :0,
                          shrinkWrap: true,
                          controller: controller,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 10.0,
                                      top: 10.0,
                                      bottom: 10.0,
                                      right: 10.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0)),
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
                                              // Container(
                                              //   padding: EdgeInsets.all(1.0),
                                              //   decoration: BoxDecoration(
                                              //     shape: BoxShape.circle,
                                              //   ),
                                              //   child: SvgPicture.asset(
                                              //     "assets/icons/btc.svg",
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
                                                  Text(
                                                    // name,
                                                    marketList[index].name.toString(),
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
                                                  // Text(
                                                  //   // tradePairList[index].baseAsset.toString().toUpperCase(),
                                                  //   marketList[index].last.toString(),
                                                  //   style: CustomWidget(
                                                  //           context: context)
                                                  //       .CustomSizedTextStyle(
                                                  //           12.0,
                                                  //           Theme.of(context)
                                                  //               .bottomAppBarColor,
                                                  //           FontWeight.w400,
                                                  //           'FontRegular'),
                                                  //   textAlign: TextAlign.start,
                                                  // ),
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
                                          color: double.parse(marketList[
                                          index]
                                              .change
                                              .toString()) >=
                                              0
                                              ? Theme.of(
                                              context)
                                              .indicatorColor
                                              : Theme.of(
                                              context)
                                              .hoverColor,
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
                                              "\$" + double.parse(marketList[index].last.toString()).toStringAsFixed(4),
                                              style:
                                                  CustomWidget(context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .focusColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                              textAlign: TextAlign.start,
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
                                            Text(
                                              double.parse(marketList[index]
                                                  .change
                                                  .toString())
                                                  .toStringAsFixed(2) +
                                                  " %",
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  10,
                                                  double.parse(marketList[
                                                                            index]
                                                                        .change
                                                                        .toString()) >=
                                                                    0
                                                                ? Theme.of(
                                                                        context)
                                                                    .indicatorColor
                                                                : Theme.of(
                                                                        context)
                                                                    .hoverColor,
                                                            FontWeight.w400,
                                                  'FontRegular'),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        flex: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                // const SizedBox(
                                //   height: 10.0,
                                // ),
                              ],
                            );
                          },
                        ) :
                        Container(
                          height: MediaQuery.of(context).size.height * 0.3,
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
                        )
                      ],
                    ),
                  )),
              loading
                  ? CustomWidget(context: context).loadingIndicator(
                CustomTheme.of(context).disabledColor,
              )
                  : Container()
            ],
          ),
        ));
  }



  profileDetails() {
    apiUtils.getProfileDetils().then((GetProfileModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          name = loginData.result!.name.toString();
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        print("welcome");
        loading = false;
      });
    });
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
            var messageJSON = {
              "channel": "tickers",
              "instId": tradePairListAll[m].data!.instId.toString(),
            };

            arrData.add(messageJSON);
          }
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

  verifysubAcc() {
    apiUtils.createSubAccountInfo().then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          // CustomWidget(context: context).showSuccessAlertDialog(
          //     "Login", loginData.message.toString(), "success");
        });
      } else {
        setState(() {
          loading = false;
          // CustomWidget(context: context).showSuccessAlertDialog(
          //     "Login", loginData.message.toString(), "error");
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  walletDepoAdd() {
    apiUtils.walletDepoAdd().then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          // CustomWidget(context: context).showSuccessAlertDialog(
          //     "Login", loginData.message.toString(), "success");
        });
      } else {
        setState(() {
          loading = false;
          // CustomWidget(context: context).showSuccessAlertDialog(
          //     "Login", loginData.message.toString(), "error");
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

// bottomNavigationBar: StylishBottomBar(
// option: AnimatedBarOptions(
// // iconSize: 32,
// barAnimation: BarAnimation.fade,
// iconStyle: IconStyle.animated,
//
// // opacity: 0.3,
// ),
// items: [
// BottomBarItem(
// icon: SvgPicture.asset(
// 'assets/icons/home.svg',
// color: Theme.of(context).disabledColor,
// ),
// selectedIcon: SvgPicture.asset(
// 'assets/icons/home.svg',
// color: Theme.of(context).disabledColor,
// ),
// title: Text(
// 'Home',
// style: CustomWidget(context: context).CustomSizedTextStyle(
// 12.0,
// Theme.of(context).focusColor,
// FontWeight.w500,
// 'FontRegular'),
// ),
// selectedColor: Colors.red,
// showBadge: false,
// badgeColor: Colors.purple,
// badgePadding: const EdgeInsets.only(left: 4, right: 4),
//
// ),
// BottomBarItem(
// icon: SvgPicture.asset('assets/icons/market.svg'),
// selectedIcon: const Icon(Icons.star_rounded),
// selectedColor: Colors.red,
//
// // unSelectedColor: Colors.purple,
// // backgroundColor: Colors.orange,
// title: Text(
// 'Market',
// style: CustomWidget(context: context).CustomSizedTextStyle(
// 12.0,
// Theme.of(context).focusColor,
// FontWeight.w500,
// 'FontRegular'),
// ),
// ),
// BottomBarItem(
// icon: SvgPicture.asset('assets/icons/copy.svg'),
// selectedIcon: const Icon(
// Icons.style,
// ),
// backgroundColor: Colors.amber,
// selectedColor: Colors.deepOrangeAccent,
//
// title: Text(
// 'Copy Trade',
// style: CustomWidget(context: context).CustomSizedTextStyle(
// 12.0,
// Theme.of(context).focusColor,
// FontWeight.w500,
// 'FontRegular'),
// ),
// ),
// BottomBarItem(
// icon: SvgPicture.asset('assets/icons/user.svg'),
// selectedIcon: const Icon(
// Icons.person,
// ),
// backgroundColor: Colors.purpleAccent,
// selectedColor: Colors.deepPurple,
//
// title: Text(
// 'Profile',
// style: CustomWidget(context: context).CustomSizedTextStyle(
// 12.0,
// Theme.of(context).focusColor,
// FontWeight.w500,
// 'FontRegular'),
// ),
// ),
// ],
// hasNotch: true,
// fabLocation: StylishBarFabLocation.center,
// backgroundColor: Theme.of(context).scaffoldBackgroundColor,
// currentIndex: currentIndex,
// onTap: (index) {
// setState(() {
//
//
// currentIndex=index;
// onSelectItem(currentIndex);
//
//
// });
// },
// ),
// floatingActionButton: FloatingActionButton(
// onPressed: () {
// setState(() {
//
// currentIndex=-1;
//
// });
// },
// backgroundColor: Theme.of(context).disabledColor,
// child: SvgPicture.asset('assets/icons/trade.svg')),
// floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,