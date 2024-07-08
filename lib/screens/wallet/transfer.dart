import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imperial/common/custom_widget.dart';
import 'package:imperial/common/textformfield_custom.dart';
import 'package:imperial/common/theme/custom_theme.dart';
import 'package:imperial/data/api_utils.dart';
import 'package:imperial/data/crypt_model/all_wallet_pairs.dart';
import 'package:imperial/data/crypt_model/common_model.dart';
import 'package:imperial/data/crypt_model/wallet_address_model.dart';

import '../../data/crypt_model/transfer_amount_internal_model.dart';
import '../../data/crypt_model/transfer_history_model.dart';
import '../side_menu/transfer_history.dart';

class Transfer_Screen extends StatefulWidget {

  final  List<GetWalletAll> walletPair;
   Transfer_Screen({super.key, required this.walletPair});

  @override
  State<Transfer_Screen> createState() => _Transfer_ScreenState();
}

class _Transfer_ScreenState extends State<Transfer_Screen> {

  bool loading = false;
  bool swap= false;
  ScrollController _scrollController = ScrollController();
  FocusNode spendFocus = FocusNode();
  FocusNode recieveFocus = FocusNode();
  TextEditingController spendController = TextEditingController();
  TextEditingController recieveController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  ScrollController controller = ScrollController();

  String fee = "0.00";
  String percentage = "0";
  String coinTwo = "";
  String coinOne = "";
  String coinBalnce = "0.00";
  APIUtils apiUtils = APIUtils();
  List<String> coinOnelist = ["Funding", "Trading",];   //6-Funding 18-Trading
String coinOneSelect = "";
  List<GetWalletAll> walletPair = [];
  List<GetWalletAll> coinPair = [];
  GetWalletAll? selectPair;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loading = true;

    coinOneSelect=coinOnelist.first;
    coinPair= widget.walletPair;
    walletPair= widget.walletPair;
    getWallList();
    selectPair= coinPair.first;
    if(coinOneSelect=="Funding")
    {
      spendController.text=coinOnelist[1];
    }
    else{
      spendController.text=coinOnelist[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0.0,
              centerTitle: true,
              title: Text(
                "Transfer",
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    17.0,
                    Theme.of(context).focusColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Icon(
                    Icons.arrow_back,
                    size: 25.0,
                    color: Theme.of(context).focusColor,
                  ),
                ),
              ),
            actions: [
              InkWell(
                onTap: (){
                  setState(() {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Transfer_History(),),
                    );
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Icon(
                    Icons.list_alt,
                    size: 25.0,
                    color: Theme.of(context).focusColor,
                  ),
                )
              )
            ],
          ),
          body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
              child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Stack(
                    children: [
                      transfer(),
                      loading
                          ? CustomWidget(context: context).loadingIndicator(
                        Theme.of(context).disabledColor,
                      )
                          : Container()
                    ],
                  ))),
        ));
  }

  Widget transfer(){
    return Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Coin",
                style: CustomWidget(context: context).CustomSizedTextStyle(14.0,
                    Theme.of(context).focusColor, FontWeight.w500, 'FontRegular'),
              ),
              const SizedBox(
                height: 10.0,
              ),
              InkWell(
                onTap: () {
                  showSheeet(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                  EdgeInsets.fromLTRB(12.0, 14.0, 12, 14.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: CustomTheme.of(context).canvasColor,
                  ),
                  child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor:
                        CustomTheme.of(context).cardColor,
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectPair!.coinname.toString(),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                14.0,
                                Theme.of(context).focusColor,
                                FontWeight.w500,
                                'FontRegular'),
                          ),
                          Row(
                            children: [
                              Text(
                                // selectedCoin!.asset!.type.toString(),
                                "***",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    14.0,
                                    Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.5),
                                    FontWeight.w400,
                                    'FontRegular'),
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 15.0,
                                color:
                                Theme.of(context).focusColor,
                              ),
                            ],
                          )
                        ],
                      )),
                ),
              ),
              const SizedBox(
                height: 35.0,
              ),
              Text(
                "From",
                style: CustomWidget(context: context).CustomSizedTextStyle(14.0,
                    Theme.of(context).focusColor, FontWeight.w500, 'FontRegular'),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(12.0, 0.0, 12, 0.0),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).canvasColor, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Theme.of(context).canvasColor,
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Theme.of(context).canvasColor,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      menuMaxHeight: MediaQuery.of(context).size.height * 0.7,
                      items: coinOnelist
                          .map((value) => DropdownMenuItem(
                        child: Text(
                          // value.coinone.toString(),
                          value.toString(),
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                              14.0,
                              Theme.of(context).focusColor,
                              FontWeight.w500,
                              'FontRegular'),
                        ),
                        value: value,
                      ))
                          .toList(),
                      onChanged: (dynamic value) async {
                        setState(() {
                          coinOneSelect = value!;
                          if(coinOneSelect=="Funding")
                            {
                              spendController.text=coinOnelist[1];
                            }
                          else{
                            spendController.text=coinOnelist[0];
                          }

                          loading = true;
                          getTransfer();

                          // loading = getSwapBalanceList();
                        });
                      },
                      hint: Text(
                        "Select Coin",
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            10.0,
                            Theme.of(context).focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                      isExpanded: true,
                      value: coinOneSelect,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        // color: AppColors.otherTextColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              InkWell(
                onTap: (){
                  setState(() {
                  });
                },
                child: Align(
                  child: RotationTransition(
                      turns: AlwaysStoppedAnimation(90 / 360),
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.5, color: Theme.of(context).disabledColor,),
                          shape: BoxShape.circle,
                          color: Theme.of(context).canvasColor,
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/trade.svg",
                          height: 22.0,
                          color: Theme.of(context).disabledColor,
                        ),
                      )),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "To",
                style: CustomWidget(context: context).CustomSizedTextStyle(14.0,
                    Theme.of(context).focusColor, FontWeight.w500, 'FontRegular'),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextFormFieldCustom(
                onEditComplete: () {
                  spendFocus.unfocus();
                },
                radius: 8.0,
                error: "Enter amount",
                textColor: Theme.of(context).primaryColor,
                borderColor: Colors.transparent,
                fillColor: Theme.of(context).canvasColor,
                hintStyle: CustomWidget(context: context)
                    .CustomSizedTextStyle(
                    15.0,
                    Theme.of(context).dividerColor,
                    FontWeight.w400,
                    'FontRegular'),
                textStyle: CustomWidget(context: context).CustomTextStyle(
                    Theme.of(context).focusColor,
                    FontWeight.w500,
                    'FontRegular'),
                textInputAction: TextInputAction.done,
                focusNode: spendFocus,
                maxlines: 1,
                text: '',
                hintText: "Enter amount",
                obscureText: false,
                suffix: Container(
                  width: 0.0,
                ),
                textChanged: (value) {
                  // setState(() {
                  //   if (value.isEmpty) {
                  //     fee = "0.000";
                  //     spendController.clear();
                  //   } else {
                  //     String rec = (double.parse(value)/
                  //         double.parse(
                  //             selectedCoinTwo!.liveprice.toString()))
                  //         .toStringAsFixed(8);
                  //     spendController.text = rec;
                  //     fee = (double.parse(recieveController.text.toString()) *
                  //         double.parse(selectedCoinTwo!
                  //             .commissionPercentage
                  //             .toString()) /
                  //         100)
                  //         .toStringAsFixed(8);
                  //   }
                  // });
                },
                onChanged: () {},
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter amount";
                  }
                  return null;
                },
                enabled: false,
                textInputType: TextInputType.numberWithOptions(decimal: true,signed: true,),
                controller: spendController,
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                "Transfer Amount",
                style: CustomWidget(context: context).CustomSizedTextStyle(14.0,
                    Theme.of(context).focusColor, FontWeight.w500, 'FontRegular'),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextFormFieldCustom(
                onEditComplete: () {
                  recieveFocus.unfocus();
                },
                radius: 8.0,
                error: "Enter amount",
                textColor: Theme.of(context).focusColor,
                borderColor: Colors.transparent,
                fillColor: Theme.of(context).canvasColor,
                hintStyle: CustomWidget(context: context)
                    .CustomSizedTextStyle(
                    15.0,
                    Theme.of(context).dividerColor,
                    FontWeight.w400,
                    'FontRegular'),
                textStyle: CustomWidget(context: context).CustomTextStyle(
                    Theme.of(context).focusColor,
                    FontWeight.w500,
                    'FontRegular'),
                textInputAction: TextInputAction.done,
                focusNode: recieveFocus,
                maxlines: 1,
                text: '',
                hintText: "Enter amount",
                obscureText: false,
                suffix: Container(
                  width: 0.0,
                ),
                textChanged: (value) {
                  // setState(() {
                  //   if (value.isEmpty) {
                  //     fee = "0.000";
                  //     spendController.clear();
                  //   } else {
                  //     String rec = (double.parse(value)/
                  //         double.parse(
                  //             selectedCoinTwo!.liveprice.toString()))
                  //         .toStringAsFixed(8);
                  //     spendController.text = rec;
                  //     fee = (double.parse(recieveController.text.toString()) *
                  //         double.parse(selectedCoinTwo!
                  //             .commissionPercentage
                  //             .toString()) /
                  //         100)
                  //         .toStringAsFixed(8);
                  //   }
                  // });
                },
                onChanged: () {},
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter amount";
                  }
                  return null;
                },
                enabled: true,
                textInputType: TextInputType.numberWithOptions(decimal: true,signed: true,),
                controller: recieveController,
              ),
              const SizedBox(
                height: 25.0,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                // coinTwoBalance,
                "Avilable balance: "+double.parse(coinBalnce.toString()).toStringAsFixed(8)+" "+selectPair!.coinname.toString(),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    14.0,
                    Theme.of(context).focusColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
              const SizedBox(
                height: 25.0,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    if(recieveController.text.length>0)
                    {
                      setState(() {
                        loading=true;
                        getTransferAmount();

                      });
                    } else {
                      CustomWidget(context: context).showSuccessAlertDialog("Transfer", "Please fill the details", "error");
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "Confirm transfer",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        17.0,
                        Theme.of(context).focusColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  showSheeet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext contexts, StateSetter setStates) {
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
                                  coinPair = [];
                                  for (int m = 0; m < walletPair.length; m++) {
                                    if (walletPair[m].symbol.toString().toLowerCase().contains(value.toString().toLowerCase()))
                                    {
                                      coinPair.add(walletPair[m]);
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
                                    .primaryColorLight
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
                                    // searchPair.addAll(tradePair);
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
                            itemCount: coinPair.length,
                            itemBuilder: ((BuildContext context, int index) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectPair = coinPair[index];
                                        // getAddressDetails();
                                        Navigator.pop(context);
                                      });
                                      searchController.clear();
                                      loading = true;
                                      getTransfer();
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
                                        //     coinPair[index].assetId!.image.toString(),
                                        //     fit: BoxFit.cover,
                                        //   ),
                                        // ),
                                        // const SizedBox(
                                        //   width: 10.0,
                                        // ),
                                        Text(
                                          coinPair[index].coinname.toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                              14.0,
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
                                    CustomTheme.of(context).primaryColorLight,
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



  getWallList() {
    apiUtils.getWalletList().then((GetWalletAllPairsModel loginData) {
      if (loginData.success!) {
        setState(() {
          walletPair = loginData.result!;
          coinPair = loginData.result!;
          selectPair=coinPair.first;
          getTransfer();
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


  getTransferAmount() {
    apiUtils.transferAmount(selectPair!.coinname.toString(), recieveController.text.toString(), coinOneSelect.toString()=="Funding" ? "FUND": "UNIFIED", spendController.text.toString() =="Funding" ? "FUND": "UNIFIED",).then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          recieveController.clear();
          getWallList();

          CustomWidget(context: context).showSuccessAlertDialog(
              "Transfer", loginData.message.toString(), "success");
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Transfer", loginData.message.toString(), "error");
        });
      }
    }).catchError((Object error) {
      print("Mano");
      print(error);
    });
  }

  getTransfer() {
    apiUtils.transferTypeBalance(coinOneSelect.toString()=="Funding" ? "FUND": "UNIFIED", selectPair!.coinname.toString() ).then((AmountTransferInternalModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          coinBalnce = loginData.result!.walletBalance!.toString();
          // CustomWidget(context: context).showSuccessAlertDialog(
          //     "Transfer", loginData.message.toString(), "success");
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Transfer", loginData.message.toString(), "error");
        });
      }
    }).catchError((Object error) {
      print("Mano");
      print(error);
    });
  }

}
