import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imperial/common/custom_widget.dart';
import 'package:imperial/screens/side_menu/history.dart';
import 'package:imperial/screens/wallet/deposit.dart';
import 'package:imperial/screens/wallet/withdraw.dart';

import '../common/localization/localizations.dart';
import '../data/api_utils.dart';
import '../data/crypt_model/all_wallet_pairs.dart';
import 'wallet/transfer.dart';

class Wallet_Screen extends StatefulWidget {
  const Wallet_Screen({Key? key}) : super(key: key);

  @override
  State<Wallet_Screen> createState() => _Wallet_ScreenState();
}

class _Wallet_ScreenState extends State<Wallet_Screen> {

  bool loading = false;
  bool frozen= false;
  bool mSell= false;
  bool mBuy= false;
  ScrollController controller = ScrollController();
  APIUtils apiUtils = APIUtils();
  List<GetWalletAll> walletPair = [];
  String walletBalance = "0.000";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    frozen = true;
    loading = true;
    getWallList();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            // leading: Padding(
            //   padding: EdgeInsets.only(right: 1.0),
            //   child: InkWell(
            //     onTap: () {
            //       setState(() {
            //         Navigator.pop(context);
            //       });
            //     },
            //     child: Icon(
            //       Icons.arrow_back_ios_new_rounded,
            //       size: 20.0,
            //       color: Theme.of(context).focusColor,
            //     ),
            //   ),
            // ),
            leading: Container(width: 10.0,),
            title: Text(
              "My Wallet",
              style: CustomWidget(context: context).CustomSizedTextStyle(20.0,
                  Theme.of(context).focusColor, FontWeight.w600, 'FontRegular'),
            ),
            centerTitle: true,
            toolbarHeight: 0.0,
          ),
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
        padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
        child: Stack(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Wallet",
                    style: CustomWidget(context: context).CustomSizedTextStyle(20.0,
                        Theme.of(context).focusColor, FontWeight.w600, 'FontRegular'),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.instance.text("loc_total")+ " value",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                16.0,
                                Theme.of(context).focusColor,
                                FontWeight.w500,
                                'FontRegular'),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          SvgPicture.asset(
                            'assets/icons/eye.svg',
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            // "0.00",
                            double.parse( walletBalance.toString()).toStringAsFixed(8),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                24.0,
                                Theme.of(context).focusColor,
                                FontWeight.w500,
                                'FontRegular'),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "USD",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                18.0,
                                Theme.of(context).focusColor,
                                FontWeight.w400,
                                'FontRegular'),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 10.0,
                      ),

                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10.0, left: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap:(){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Deposit_Screen(
                                        coinList: walletPair,
                                      ),
                                ));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RotationTransition(
                                turns: AlwaysStoppedAnimation(90 / 360),
                                child: SizedBox(
                                  height: 20.0,
                                  width: 20.0,
                                  child: SvgPicture.asset("assets/sidemenu/logout.svg", height: 18.0, color: Theme.of(context).disabledColor,),
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "Deposit",
                                style: TextStyle(
                                  fontFamily: "FontRegular",
                                  color: Theme.of(context).focusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Withdraw_Screen(coinList: walletPair,),
                                ));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RotationTransition(
                                turns: AlwaysStoppedAnimation(270 / 360),
                                child: SizedBox(
                                  height: 20.0,
                                  width: 20.0,
                                  child: SvgPicture.asset("assets/sidemenu/logout.svg", height: 18.0, color: Theme.of(context).disabledColor,),
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "Withdraw",
                                style: TextStyle(
                                  fontFamily: "FontRegular",
                                  color: Theme.of(context).focusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap:(){
                            setState(() {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Transfer_Screen(walletPair: walletPair),));
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20.0,
                                // width: 20.0,
                                child: Icon(
                                  Icons.change_circle_outlined,
                                  size: 24.0,
                                  color: Theme.of(context).disabledColor,
                                ),
                                // SvgPicture.asset("assets/sidemenu/logout.svg", height: 18.0, color: Theme.of(context).disabledColor,),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "Transfer",
                                style: TextStyle(
                                  fontFamily: "FontRegular",
                                  color: Theme.of(context).focusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap:(){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => History_Screen(),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: Icon(
                                  Icons.event_note_outlined,
                                  size: 24.0,
                                  color: Theme.of(context).disabledColor,
                                ),
                                // SvgPicture.asset("assets/sidemenu/logout.svg", height: 18.0, color: Theme.of(context).disabledColor,),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "History",
                                style: TextStyle(
                                  fontFamily: "FontRegular",
                                  color: Theme.of(context).focusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            frozen = true;
                            mSell = false;
                            mBuy = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                              left: 12.0, right: 12.0, top: 6.0, bottom: 8.0),
                          decoration: frozen
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  color: Theme.of(context).canvasColor,
                                )
                              : BoxDecoration(),
                          child: Text(
                            "Frozen Balance",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    12.0,
                                    frozen
                                        ? Theme.of(context).disabledColor
                                        : Theme.of(context).dividerColor,
                                    frozen ? FontWeight.w600 : FontWeight.w400,
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
                            frozen = false;
                            mSell = true;
                            mBuy = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                              left: 12.0, right: 12.0, top: 6.0, bottom: 8.0),
                          decoration: mSell
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  color: Theme.of(context).canvasColor,
                                )
                              : BoxDecoration(),
                          child: Text(
                            "Margin Sell",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    14.0,
                                    mSell
                                        ? Theme.of(context).disabledColor
                                        : Theme.of(context).dividerColor,
                                    mSell ? FontWeight.w600 : FontWeight.w400,
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
                            frozen = false;
                            mSell = false;
                            mBuy = true;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                              left: 12.0, right: 12.0, top: 6.0, bottom: 8.0),
                          decoration: mBuy
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  color: Theme.of(context).canvasColor,
                                )
                              : BoxDecoration(),
                          child: Text(
                            "Margin Buy",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    12.0,
                                    mBuy
                                        ? Theme.of(context).disabledColor
                                        : Theme.of(context).dividerColor,
                                    mBuy ? FontWeight.w600 : FontWeight.w400,
                                    'FontRegular'),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            // walletPair.length >0 ?
            loading
                ? CustomWidget(context: context)
                    .loadingIndicator(Theme.of(context).disabledColor)
                : Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.34),
                    child: SingleChildScrollView(
                        child: frozen ? Container(
                      width: MediaQuery.of(context).size.width,
                      child: walletPair.length > 0
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: walletPair.length,
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
                                                      padding:
                                                          EdgeInsets.all(1.0),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Image.network(
                                                        // "assets/icons/btc.svg",
                                                        walletPair[index]
                                                            .assetId!
                                                            .image
                                                            .toString(),
                                                        height: 40.0,
                                                        // color: Theme.of(context).disabledColor,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          // name,
                                                          // "Bitcoin",
                                                          walletPair[index]
                                                              .assetId!
                                                              .coinname
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
                                                        ),
                                                        const SizedBox(
                                                          height: 4.0,
                                                        ),
                                                        Text(
                                                          // tradePairList[index].baseAsset.toString().toUpperCase(),
                                                          "Balance : " +
                                                              double.parse( walletPair[index]
                                                                  .balance
                                                                  .toString()).toStringAsFixed(2),
                                                          style: CustomWidget(
                                                                  context:
                                                                      context)
                                                              .CustomSizedTextStyle(
                                                                  12.0,
                                                                  Theme.of(
                                                                          context)
                                                                      .bottomAppBarColor,
                                                                  FontWeight
                                                                      .w400,
                                                                  'FontRegular'),
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              flex: 4,
                                            ),
                                            Flexible(
                                              child: Text(
                                                mSell
                                                    ? double.parse(
                                                            walletPair[index]
                                                                .maxLoan![0]
                                                                .maxLoan
                                                                .toString())
                                                        .toStringAsFixed(6)
                                                    : mBuy
                                                        ? double.parse(
                                                                walletPair[
                                                                        index]
                                                                    .maxLoan![1]
                                                                    .maxLoan
                                                                    .toString())
                                                            .toStringAsFixed(6)
                                                        : double.parse(walletPair[
                                                                    index]
                                                                .escrowBalance
                                                                .toString())
                                                            .toStringAsFixed(6),
                                                // "0.006862",
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        14.0,
                                                        Theme.of(context)
                                                            .focusColor,
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                                textAlign: TextAlign.center,
                                              ),
                                              flex: 2,
                                            ),
                                            // Flexible(
                                            //   child: Container(
                                            //     padding: EdgeInsets.only(top: 3.0, bottom: 3.0, right: 10.0, left: 10.0),
                                            //     decoration: BoxDecoration(
                                            //       borderRadius: BorderRadius.circular(5.0),
                                            //       color: Theme.of(context)
                                            //           .disabledColor,
                                            //     ),
                                            //     child: Text(
                                            //       "Trade",
                                            //       style: CustomWidget(
                                            //           context: context)
                                            //           .CustomSizedTextStyle(
                                            //           12,
                                            //           Theme.of(context)
                                            //               .focusColor,
                                            //           FontWeight.w700,
                                            //           'FontRegular'),
                                            //       textAlign: TextAlign.center,
                                            //     ),
                                            //   ),
                                            //   flex: 1,
                                            // ),
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
                    ) : Container(
                        height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Center(
                child: Text(
                  " No records found..!",
                  style: TextStyle(
                    fontFamily: "FontRegular",
                    color: Theme.of(context).focusColor,
                  ),
                ),
              ),
            ),),
                  ),
            loading
                ? CustomWidget(context: context).loadingIndicator(
                    Theme.of(context).disabledColor,
                  )
                : Container()

          ],
        ),
      ),
    );
  }

  getWallList() {
    apiUtils.getWalletList().then((GetWalletAllPairsModel loginData) {
      if (loginData.success!) {
        setState(() {
          walletPair = loginData.result!;
          walletBalance = loginData.totalPriceInUsd!.toString();
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

}


