import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imperial/common/custom_widget.dart';
import 'package:imperial/common/localization/localizations.dart';
import 'package:imperial/common/otp_fields/otp_field_custom.dart';
import 'package:imperial/common/otp_fields/style.dart';
import 'package:imperial/common/theme/custom_theme.dart';
import 'package:imperial/data/api_utils.dart';
import 'package:imperial/data/crypt_model/all_wallet_pairs.dart';
import 'package:imperial/data/crypt_model/common_model.dart';
import 'package:imperial/data/crypt_model/user_wallet_balance_model.dart';

class Withdraw_Screen extends StatefulWidget {
  final List<GetWalletAll> coinList;

  const Withdraw_Screen({super.key,
    required this.coinList
  });

  @override
  State<Withdraw_Screen> createState() => _Withdraw_ScreenState();
}

class _Withdraw_ScreenState extends State<Withdraw_Screen> {

  APIUtils apiUtils = APIUtils();
  bool loading = false;
  UserWalletResult? selectedCoin;
  TextEditingController searchController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  ScanResult? scanResult;
  var _autoEnableFlash = false;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _aspectTolerance = 0.00;
  final _flashOnController = TextEditingController(text: 'Flash on');
  final _flashOffController = TextEditingController(text: 'Flash off');
  final _cancelController = TextEditingController(text: 'Cancel');
  ScrollController controller = ScrollController();
  ScrollController _scroll = ScrollController();
  var pinValue;
  String axn_id = "";
  String withdrawAmount = "0.00";
  List<NetworkAddress> networkAddress = [];
  String fee = "";

  int indexVal = 0;
  List<UserWalletResult> coinList = [];
  List<UserWalletResult> searchCoinList = [];
  List<GetWalletAll> walletPair = [];
  List<GetWalletAll> coinPair = [];
  GetWalletAll? selectPair;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    coinPair=widget.coinList;
    walletPair=widget.coinList;
    selectPair= coinPair.first;
    getWallList();
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
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: Container(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20.0,
                color: Theme.of(context).focusColor,
              ),
              ),
            ),
            centerTitle: true,
            title: Text(
              AppLocalizations.instance.text("loc_withdraw"),
              style: CustomWidget(context: context).CustomSizedTextStyle(18.0,
                  Theme.of(context).focusColor, FontWeight.w600, 'FontRegular'),
            ),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Theme.of(context).primaryColor,
            child: Padding(
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 6.0, bottom: 10.0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.20,
                      decoration: BoxDecoration(
                          color: Theme.of(context).disabledColor.withOpacity(0.8),
                          image: DecorationImage(
                              image: AssetImage("assets/images/back.png"),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(15),
                        boxShadow: kElevationToShadow[3],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Container(
                          //   height: 40.0,
                          //   width: 40.0,
                          //   child: Image.network(
                          //     selectPair!.assetId!.image.toString(),
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 2.0,
                          // ),
                          Text(
                            selectPair!.coinname!.toString(),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                14.0,
                                Theme.of(context).primaryColor,
                                FontWeight.w600,
                                'FontRegular'),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            "Available",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                12.0,
                                Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.5),
                                FontWeight.w500,
                                'FontRegular'),
                          ),
                          Text(
                            selectPair!.balance.toString(),
                            // "500.00",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                14.0,
                                Theme.of(context).primaryColor,
                                FontWeight.w500,
                                'FontRegular'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.22,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  showSheeet(context);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding:
                                  EdgeInsets.fromLTRB(12.0, 15.0, 12, 15.0),
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
                                            selectPair!.coinname.toString().toUpperCase(),
                                            // "Btc",
                                            style:
                                            CustomWidget(context: context)
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
                                                color:  Theme.of(context).focusColor,
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              // selectedCoin!.type.toString()!="coin"||  selectedCoin!.type.toString()!="token"?   bankList.length>0?  Container(
                              //   height: 45.0,
                              //   padding: const EdgeInsets.only(
                              //       left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(5.0),
                              //     color:  CustomTheme.of(context)
                              //         .shadowColor
                              //         .withOpacity(0.2),
                              //   ),
                              //   child: Center(
                              //     child: Theme(
                              //       data: Theme.of(context).copyWith(
                              //         canvasColor:
                              //         CustomTheme.of(context).cardColor,
                              //       ),
                              //       child: DropdownButtonHideUnderline(
                              //         child: DropdownButton(
                              //           items: bankList
                              //               .map((value) => DropdownMenuItem(
                              //             child: Text(
                              //               value.bankName.toString(),
                              //               style: CustomWidget(
                              //                   context: context)
                              //                   .CustomSizedTextStyle(
                              //                   12.0,
                              //                   Theme.of(context)
                              //                       .splashColor,
                              //                   FontWeight.w500,
                              //                   'FontRegular'),
                              //             ),
                              //             value: value,
                              //           ))
                              //               .toList(),
                              //           onChanged: (value) {
                              //             setState(() {
                              //               selectedBank = value;
                              //             });
                              //           },
                              //           isExpanded: true,
                              //           value: selectedBank,
                              //           icon: Icon(
                              //             Icons.keyboard_arrow_down,
                              //             color:
                              //             CustomTheme.of(context).splashColor,
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ): Padding(
                              //   padding: EdgeInsets.only(top:0.0, bottom: 0.0, ),
                              //   child: InkWell(
                              //     onTap: () {
                              //       Navigator.of(context)
                              //           .push(
                              //         MaterialPageRoute(builder: (_) => AddBankScreen()),
                              //       )
                              //           .then((val) => val ? _getRequests() : null);
                              //     },
                              //     child: Container(
                              //       height: 45.0,
                              //       decoration: BoxDecoration(
                              //           color: CustomTheme.of(context)
                              //               .canvasColor,
                              //           borderRadius: BorderRadius.circular(5.0)),
                              //       padding: EdgeInsets.only(left: 10.0,right: 10.0),
                              //       child: Row(
                              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //         children: [
                              //
                              //           Text(
                              //             "Link A Bank Account",
                              //             style: CustomWidget(context: context).CustomSizedTextStyle(16.0,
                              //                 Theme.of(context).splashColor, FontWeight.w500, 'FontRegular'),
                              //           ),
                              //
                              //           Icon(
                              //             Icons.add,
                              //             size: 20.0,
                              //           )
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ):Container(),
                              // const SizedBox(
                              //   height: 10.0,
                              // ),
                              // selectedCoin!.type.toString()!="coin"||  selectedCoin!.type.toString()!="token"?
                              // Container():

                              // networkAddress.length > 0 ?
                              Container(
                                child: ListView.builder(
                                  itemCount: networkAddress.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              indexVal = index;
                                              amountController.clear();
                                              fee = "0.00";
                                              withdrawAmount = "0.00";

                                              if (networkAddress[0]
                                                  .withdrawtype
                                                  .toString()
                                                  .toLowerCase() ==
                                                  "percentage") {
                                                fee = (double.parse(networkAddress[
                                                indexVal]
                                                    .withdrawcommission
                                                    .toString()) /
                                                    100)
                                                    .toString();
                                              } else {
                                                fee = networkAddress[
                                                indexVal]
                                                    .withdrawcommission
                                                    .toString();
                                              }
                                            });
                                          },
                                          child: Container(
                                              padding:
                                              EdgeInsets.fromLTRB(
                                                  15.0,
                                                  0.0,
                                                  15.0,
                                                  0.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    8.0),
                                                color: indexVal == index
                                                    ? CustomTheme.of(
                                                    context)
                                                    .primaryColorLight
                                                    : CustomTheme.of(
                                                    context)
                                                    .disabledColor
                                                    .withOpacity(0.4),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  // networkAddress[index]
                                                  //     .name
                                                  //     .toString()
                                                  //     .toUpperCase(),
                                                  "ashnnmcikmnldlo".toUpperCase(),
                                                  style: CustomWidget(
                                                      context:
                                                      context)
                                                      .CustomSizedTextStyle(
                                                      14.0,
                                                      Theme.of(
                                                          context)
                                                          .focusColor,
                                                      FontWeight.w400,
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
                                height: 35.0,
                              ),
                                  // : Container(),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                                decoration: BoxDecoration(
                                  color: CustomTheme.of(context).canvasColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                          'Input or paste your address',
                                          hintStyle: TextStyle(
                                            fontSize: 12.0,
                                            color: CustomTheme.of(context)
                                                .dividerColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        controller: addressController,
                                        style: TextStyle(
                                          color:  Theme.of(context).focusColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _scan();
                                      },
                                      child: Icon(
                                        Icons.qr_code_scanner,
                                        color: CustomTheme.of(context)
                                            .focusColor,
                                        size: 25.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                                decoration: BoxDecoration(
                                  color: CustomTheme.of(context).canvasColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Withdrawal volume',
                                          hintStyle: TextStyle(
                                            fontSize: 12.0,
                                            color: CustomTheme.of(context)
                                                .dividerColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            withdrawAmount = "0";

                                            if (val.isNotEmpty) {
                                              if (networkAddress.length > 0) {
                                                if (networkAddress[0]
                                                    .withdrawtype
                                                    .toString()
                                                    .toLowerCase() ==
                                                    "percentage") {
                                                  String fees = (double.parse(
                                                      networkAddress[
                                                      indexVal]
                                                          .withdrawcommission
                                                          .toString()) /
                                                      100)
                                                      .toString();
                                                  fee = (double.parse(val) *
                                                      double.parse(fees))
                                                      .toStringAsFixed(8);

                                                  if(double.parse(val)>double.parse(fee))
                                                  {
                                                    withdrawAmount =
                                                        (double.parse(val) -
                                                            double.parse(fee))
                                                            .toStringAsFixed(8);
                                                  }


                                                  print(withdrawAmount);
                                                } else {
                                                  fee = networkAddress[indexVal]
                                                      .withdrawcommission
                                                      .toString();

                                                  if(double.parse(val)>double.parse(fee))
                                                  {
                                                    withdrawAmount = (double
                                                        .parse(val) -
                                                        double.parse(
                                                            networkAddress[
                                                            indexVal]
                                                                .withdrawcommission
                                                                .toString()))
                                                        .toStringAsFixed(1);
                                                  }

                                                  print(withdrawAmount);
                                                }
                                              }
                                              // if (double.parse(selectedCoin!.fee
                                              //         .toString()) <=
                                              //     double.parse(val))
                                              //   withdrawAmount = (double.parse(
                                              //               val) -
                                              //           double.parse(
                                              //               selectedCoin!.fee
                                              //                   .toString()))
                                              //       .toStringAsFixed(1);
                                            }
                                          });
                                        },
                                        controller: amountController,
                                        textInputAction: TextInputAction.done,
                                        keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                        style: TextStyle(
                                          color:  Theme.of(context).focusColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding:
                                          EdgeInsets.fromLTRB(0, 0, 5, 0),
                                          child: Text(
                                            selectPair!.coinname.toString().toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style:
                                            CustomWidget(context: context)
                                                .CustomSizedTextStyle(
                                                10.0,
                                                Theme.of(context).focusColor,
                                                FontWeight.w500,
                                                'FontRegular'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Received : " + withdrawAmount,
                                    textAlign: TextAlign.center,
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        12.0,
                                        Theme.of(context).focusColor,
                                        FontWeight.w400,
                                        'FontRegular'),
                                  ),
                                  Text(
                                    "Fee : " + fee,
                                    textAlign: TextAlign.center,
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        12.0,
                                        Theme.of(context).focusColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              // selectedCoin!.type.toString() ==
                              //     "fiat"
                              //     ?
                              TextFormField(
                                // controller: email,
                                // focusNode: emailFocus,
                                maxLines: 1,
                                // enabled: emailVerify,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                style: CustomWidget(context: context)
                                    .CustomTextStyle(
                                    Theme.of(context).focusColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 12,
                                      right: 0,
                                      top: 2,
                                      bottom: 2),
                                  hintText:
                                  "Cash withdrawal notes (optional)",
                                  hintStyle: CustomWidget(
                                      context: context)
                                      .CustomSizedTextStyle(
                                      12.0,
                                      Theme.of(context).dividerColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                                  filled: true,
                                  fillColor:
                                  CustomTheme.of(context).canvasColor,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .canvasColor,
                                        width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .canvasColor,
                                        width: 0.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .cardColor,
                                        width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .cardColor,
                                        width: 1.0),
                                  ),
                                ),
                              ),
                                  // : Container(),
                              SizedBox(
                                height: 10.0,
                              ),
                              // Text(
                              //   "H2cryptO’s API allows users to make market inquiries, trade automatically and perform various other tasks. You may find out more here",
                              //   style: CustomWidget(context: context)
                              //       .CustomSizedTextStyle(
                              //       12.0,
                              //       Theme.of(context)
                              //           .splashColor
                              //           .withOpacity(0.5),
                              //       FontWeight.w400,
                              //       'FontRegular'),
                              // ),
                              // SizedBox(
                              //   height: 10.0,
                              // ),
                              // Text(
                              //   "Each user may create up to 5 groups of API keys. The platform currently supports most mainstream currencies. For a full list of supported currencies, click here.",
                              //   style: CustomWidget(context: context)
                              //       .CustomSizedTextStyle(
                              //       12.0,
                              //       Theme.of(context)
                              //           .splashColor
                              //           .withOpacity(0.5),
                              //       FontWeight.w400,
                              //       'FontRegular'),
                              // ),
                              // SizedBox(
                              //   height: 10.0,
                              // ),
                              // Text(
                              //   "Please keep your API key confidential to protect your account. For security reasons, we recommend you link your IP address with your API key. To link your API Key with multiple addresses, you may separate each of them with a comma such as 192.168.1.1, 192.168.1.2, 192.168.1.3. Each API key can be linked with up to 4 IP addresses.",
                              //   style: CustomWidget(context: context)
                              //       .CustomSizedTextStyle(
                              //       12.0,
                              //       Theme.of(context)
                              //           .splashColor
                              //           .withOpacity(0.5),
                              //       FontWeight.w400,
                              //       'FontRegular'),
                              // ),
                              SizedBox(
                                height: 55.0,
                              ),
                              // ButtonCustom(
                              //     text:
                              //     AppLocalizations.instance.text("loc_confirm"),
                              //     iconEnable: false,
                              //     radius: 5.0,
                              //     icon: "",
                              //     textStyle: CustomWidget(context: context)
                              //         .CustomSizedTextStyle(
                              //         13.0,
                              //         Theme.of(context).splashColor,
                              //         FontWeight.w500,
                              //         'FontRegular'),
                              //     iconColor: CustomTheme.of(context).shadowColor,
                              //     shadowColor: CustomTheme.of(context).shadowColor,
                              //     splashColor: CustomTheme.of(context).shadowColor,
                              //     onPressed: () {
                              //       setState(() {
                              //
                              //
                              //         if(addressController.text.isEmpty)
                              //         {
                              //
                              //           CustomWidget(context: context).showSuccessAlertDialog("Zurumi", "Enter Withdraw Address", "error");
                              //
                              //         }
                              //         else if(amountController.text.isEmpty)
                              //         {
                              //           CustomWidget(context: context).showSuccessAlertDialog("Zurumi", "Enter  Withdraw amount", "error");
                              //
                              //
                              //         }
                              //         else
                              //         {
                              //
                              //           loading=true;
                              //
                              //
                              //
                              //           print("Mano");
                              //           coinWithdraw();
                              //
                              //         }
                              //
                              //
                              //       });
                              //     },
                              //     paddng: 1.0),

                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (double.parse(withdrawAmount) > 0) {
                                      if (addressController.text.isEmpty) {
                                        CustomWidget(context: context)
                                            .showSuccessAlertDialog(
                                            "Imperial",
                                            "Enter Withdraw Address",
                                            "error");
                                      } else if (amountController
                                          .text.isEmpty) {
                                        CustomWidget(context: context)
                                            .showSuccessAlertDialog(
                                            "Imperial",
                                            "Enter  Withdraw amount",
                                            "error");
                                      } else {
                                        if (double.parse(selectedCoin!.balance
                                            .toString()) <
                                            double.parse(amountController.text
                                                .toString())) {
                                          CustomWidget(context: context)
                                              .showSuccessAlertDialog(
                                              "Imperial",
                                              "Balance was too low",
                                              "error");

                                        } else {
                                          loading = true;

                                          // coinWithdraw();
                                        }
                                      }
                                    } else {
                                      CustomWidget(context: context)
                                          .showSuccessAlertDialog(
                                          "Imperial",
                                          "Enter  Withdraw amount",
                                          "error");
                                    }
                                  });
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding:
                                  EdgeInsets.only(top: 12.0, bottom: 12.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).disabledColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    AppLocalizations.instance
                                        .text("loc_confirm"),
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        17.0,
                                        CustomTheme.of(context).primaryColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        )),
                    loading
                        ? CustomWidget(context: context).loadingIndicator(
                      CustomTheme.of(context).disabledColor,
                    )
                        : Container(),
                  ],
                )),
          ),
        ));
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
                                    if (walletPair[m].symbol.toString().toLowerCase().contains(value.toString().toLowerCase()) || walletPair[m].coinname!.toString().toLowerCase().contains(value.toString().toLowerCase()))
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
                                        // setState(() {
                                        //   currentSymbol = selectPair!.tradepair.toString();
                                        //   print(currentSymbol + "wel");
                                        // });
                                        selectPair = coinPair[index];
                                        print(index);
                                        print(selectPair!);
                                        // getAddressDetails();
                                        Navigator.pop(context);
                                      });
                                      searchController.clear();
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

  // showssSheeet(BuildContext contexts) {
  //   return showModalBottomSheet(
  //       context: contexts,
  //       isScrollControlled: true,
  //       builder: (context) {
  //         return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setStates) {
  //             return Container(
  //               height: MediaQuery.of(context).size.height * 0.9,
  //               width: MediaQuery.of(context).size.width,
  //               color: Theme.of(context).primaryColor,
  //               child: Column(
  //                 children: <Widget>[
  //                   SizedBox(
  //                     height: 20.0,
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Padding(
  //                         padding: EdgeInsets.only(top: 10.0),
  //                         child: Container(
  //                           height: 45.0,
  //                           padding: EdgeInsets.only(left: 20.0),
  //                           width: MediaQuery.of(context).size.width * 0.8,
  //                           child: TextField(
  //                             controller: searchController,
  //                             focusNode: searchFocus,
  //                             enabled: true,
  //                             onEditingComplete: () {
  //                               setState(() {
  //                                 searchFocus.unfocus();
  //                               });
  //                             },
  //                             onChanged: (value) {
  //                               setState(() {
  //                                 coinList = [];
  //
  //                                 for (int m = 0;
  //                                     m < searchCoinList.length;
  //                                     m++) {
  //                                   if (searchCoinList[m]
  //                                           .symbol
  //                                           .toString()
  //                                           .toLowerCase()
  //                                           .contains(value
  //                                               .toString()
  //                                               .toLowerCase()) ||
  //                                       searchCoinList[m]
  //                                           .symbol
  //                                           .toString()
  //                                           .toLowerCase()
  //                                           .contains(value
  //                                               .toString()
  //                                               .toLowerCase())) {
  //                                     coinList.add(searchCoinList[m]);
  //                                   }
  //                                 }
  //                               });
  //                             },
  //                             decoration: InputDecoration(
  //                               contentPadding: const EdgeInsets.only(
  //                                   left: 12, right: 0, top: 8, bottom: 8),
  //                               hintText: "Search",
  //                               hintStyle: TextStyle(
  //                                   fontFamily: "FontRegular",
  //                                   color: Theme.of(context).hintColor,
  //                                   fontSize: 14.0,
  //                                   fontWeight: FontWeight.w400),
  //                               filled: true,
  //                               fillColor: CustomTheme.of(context)
  //                                   .backgroundColor
  //                                   .withOpacity(0.5),
  //                               border: OutlineInputBorder(
  //                                 borderRadius:
  //                                     BorderRadius.all(Radius.circular(5.0)),
  //                                 borderSide: BorderSide(
  //                                     color: CustomTheme.of(context)
  //                                         .splashColor
  //                                         .withOpacity(0.5),
  //                                     width: 1.0),
  //                               ),
  //                               disabledBorder: OutlineInputBorder(
  //                                 borderRadius:
  //                                     BorderRadius.all(Radius.circular(5.0)),
  //                                 borderSide: BorderSide(
  //                                     color: CustomTheme.of(context)
  //                                         .splashColor
  //                                         .withOpacity(0.5),
  //                                     width: 1.0),
  //                               ),
  //                               enabledBorder: OutlineInputBorder(
  //                                 borderRadius:
  //                                     BorderRadius.all(Radius.circular(5.0)),
  //                                 borderSide: BorderSide(
  //                                     color: CustomTheme.of(context)
  //                                         .splashColor
  //                                         .withOpacity(0.5),
  //                                     width: 1.0),
  //                               ),
  //                               focusedBorder: OutlineInputBorder(
  //                                 borderRadius:
  //                                     BorderRadius.all(Radius.circular(5.0)),
  //                                 borderSide: BorderSide(
  //                                     color: CustomTheme.of(context)
  //                                         .splashColor
  //                                         .withOpacity(0.5),
  //                                     width: 1.0),
  //                               ),
  //                               errorBorder: const OutlineInputBorder(
  //                                 borderRadius:
  //                                     BorderRadius.all(Radius.circular(5)),
  //                                 borderSide:
  //                                     BorderSide(color: Colors.red, width: 0.0),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       Container(
  //                         child: Align(
  //                             child: InkWell(
  //                           onTap: () {
  //                             Navigator.pop(context);
  //                             setState(() {
  //                               searchController.clear();
  //                               coinList.addAll(searchCoinList);
  //                             });
  //                           },
  //                           child: Icon(
  //                             Icons.close,
  //                             size: 20.0,
  //                             color: Theme.of(context).hintColor,
  //                           ),
  //                         )),
  //                       ),
  //                       const SizedBox(
  //                         width: 10.0,
  //                       )
  //                     ],
  //                   ),
  //                   const SizedBox(
  //                     height: 15.0,
  //                   ),
  //                   Expanded(
  //                       child: Padding(
  //                     padding: EdgeInsets.only(top: 15.0),
  //                     child: ListView.builder(
  //                         controller: controller,
  //                         itemCount: coinList.length,
  //                         itemBuilder: ((BuildContext context, int index) {
  //                           return Column(
  //                             children: [
  //                               InkWell(
  //                                 onTap: () {
  //                                   setState(() {
  //                                     selectedCoin = coinList[index];
  //                                     indexVal = 0;
  //
  //                                     print(selectedCoin!.type);
  //                                     Navigator.pop(context);
  //                                   });
  //                                 },
  //                                 child: Row(
  //                                   children: [
  //                                     const SizedBox(
  //                                       width: 20.0,
  //                                     ),
  //                                     Container(
  //                                       height: 25.0,
  //                                       width: 25.0,
  //                                       child: SvgPicture.network(
  //                                         coinList[index].image.toString(),
  //                                         fit: BoxFit.cover,
  //                                       ),
  //                                     ),
  //                                     const SizedBox(
  //                                       width: 10.0,
  //                                     ),
  //                                     Text(
  //                                       coinList[index]
  //                                           .symbol
  //                                           .toString()
  //                                           .toUpperCase(),
  //                                       style: CustomWidget(context: context)
  //                                           .CustomSizedTextStyle(
  //                                               16.0,
  //                                               Theme.of(context).splashColor,
  //                                               FontWeight.w500,
  //                                               'FontRegular'),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               const SizedBox(
  //                                 height: 5.0,
  //                               ),
  //                               Container(
  //                                 height: 1.0,
  //                                 width: MediaQuery.of(context).size.width,
  //                                 color:
  //                                     CustomTheme.of(context).backgroundColor,
  //                               ),
  //                               const SizedBox(
  //                                 height: 5.0,
  //                               ),
  //                             ],
  //                           );
  //                         })),
  //                   )),
  //                 ],
  //               ),
  //             );
  //           },
  //         );
  //       });
  // }
  viewDetails(BuildContext contexts) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter ssetState) {
                return Container(
                  margin: EdgeInsets.only(top: 5.0),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                    right: 5.0,
                    left: 0.0,
                  ),
                  decoration: BoxDecoration(
                      color: CustomTheme.of(context).cardColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0),
                      )),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 30.0,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Withdraw  OTP",
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        16.0,
                                        Theme.of(context).splashColor,
                                        FontWeight.w600,
                                        'FontRegular'),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(
                                    height: 35.0,
                                  ),
                                  OTPTextField(
                                    length: 6,
                                    width: MediaQuery.of(context).size.width,
                                    fieldWidth: 45,
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        14.0,
                                        Theme.of(context).primaryColor,
                                        FontWeight.w600,
                                        'FontRegular'),
                                    textFieldAlignment:
                                    MainAxisAlignment.spaceAround,
                                    fieldStyle: FieldStyle.underline,
                                    onCompleted: (pin) {
                                      setState(() {
                                        pinValue = pin;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 45.0,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      onTap: () {
                                        if (pinValue.isEmpty ||
                                            pinValue.length < 6) {
                                          CustomWidget(context: context)
                                              .showSuccessAlertDialog(
                                              "Withdraw",
                                              "Please enter OTP",
                                              "error");
                                        } else {
                                          ssetState(() {
                                            loading = true;
                                            Navigator.pop(context);
                                            // confirmWithdraw();
                                          });
                                        }
                                      },
                                      child: Container(
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.6,
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 10.0, 0.0, 10.0),
                                        decoration: BoxDecoration(
                                          // border: Border.all(
                                          //   width: 1.0,
                                          //   color: Theme.of(context).cardColor,
                                          // ),
                                          borderRadius:
                                          BorderRadius.circular(6.0),
                                          color: CustomTheme.of(context)
                                              .shadowColor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Verify",
                                            style:
                                            CustomWidget(context: context)
                                                .CustomSizedTextStyle(
                                                16.0,
                                                Theme.of(context)
                                                    .splashColor,
                                                FontWeight.w800,
                                                'FontRegular'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  // Align(
                                  //   alignment: Alignment.center,
                                  //   child: InkWell(
                                  //     onTap: (){
                                  //       ssetState(() {
                                  //         loading=true;
                                  //         resndOTP();
                                  //       });
                                  //
                                  //
                                  //     },
                                  //     child: Text(
                                  //       "Resend OTP",
                                  //       style: CustomWidget(context: context)
                                  //           .CustomSizedTextStyle(
                                  //           14.0,
                                  //           Theme.of(context).shadowColor,
                                  //           FontWeight.w800,
                                  //           'FontRegular'),
                                  //     ),
                                  //   ),
                                  // ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                );
              }),
        ));
  }

  // getDetails() {
  //   print(selectedCoin!.symbol.toString());
  //   apiUtils
  //       .getDepositDetails(selectedCoin!.symbol.toString())
  //       .then((DepositDetailsModel loginData) {
  //     setState(() {
  //       loading = false;
  //
  //       networkAddress = [];
  //       if (loginData.network!.length > 0) {
  //         networkAddress = loginData.network!;
  //
  //         if (networkAddress[0].withdrawtype.toString().toLowerCase() ==
  //             "percentage") {
  //           fee = (double.parse(networkAddress[indexVal]
  //               .withdrawcommission
  //               .toString()) /
  //               100)
  //               .toString();
  //         } else {
  //           fee = networkAddress[indexVal].withdrawcommission.toString();
  //         }
  //       }
  //     });
  //   }).catchError((Object error) {
  //     print(error);
  //   });
  // }

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': _cancelController.text,
            'flash_on': _flashOnController.text,
            'flash_off': _flashOffController.text,
          },
          useCamera: _selectedCamera,
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: _aspectTolerance,
            useAutoFocus: _useAutoFocus,
          ),
        ),
      );
      setState(() {


        var str = result.rawContent.toString();
        print(str);
        if(str.contains(":")){
          var parts = str.split(':');
          addressController.text=parts[1].trim().toString();
        }else{
          addressController.text=str.toString();
        }

      });
    } on PlatformException catch (e) {
      setState(() {
        print("Mano");
        scanResult = ScanResult(
          type: ResultType.Error,
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
    }
  }

  // getBankList() {
  //   apiUtils.getBankDetails().then((BankListModel loginData) {
  //     if (loginData.success!) {
  //       setState(() {
  //         loading = false;
  //         bankList = loginData.result!;
  //         selectedBank = bankList.first;
  //       });
  //     } else {
  //       setState(() {
  //         loading = false;
  //       });
  //     }
  //   }).catchError((Object error) {
  //     setState(() {
  //       loading = false;
  //     });
  //   });
  // }

  // coinWithdraw() {
  //   apiUtils
  //       .coinWithdrawDetails(
  //       selectedCoin!.symbol.toString(),
  //       addressController.text.toString(),
  //       amountController.text.toString(),
  //       networkAddress.length > 0
  //           ? networkAddress[indexVal].type.toString()
  //           : "coin")
  //       .then((WithdrawModel loginData) {
  //     if (loginData.success!) {
  //       setState(() {
  //         loading = false;
  //         CustomWidget(context: context).showSuccessAlertDialog(
  //             "Imperial", loginData.message.toString(), "success");
  //
  //         viewDetails(context);
  //       });
  //     } else {
  //       setState(() {
  //         loading = false;
  //         CustomWidget(context: context).showSuccessAlertDialog(
  //             "Imperial", loginData.message.toString(), "error");
  //       });
  //     }
  //   }).catchError((Object error) {
  //     print(error);
  //     setState(() {
  //       loading = false;
  //     });
  //   });
  // }

  // confirmWithdraw() {
  //   setState(() {
  //     loading = true;
  //   });
  //   apiUtils
  //       .confirmWithdrawOTP(
  //       selectedCoin!.symbol.toString(),
  //       addressController.text.toString(),
  //       amountController.text.toString(),
  //       pinValue.toString(),
  //       networkAddress.length > 0
  //           ? networkAddress[indexVal].type.toString()
  //           : "coin")
  //       .then((CommonModel loginData) {
  //     if (loginData.status!) {
  //       setState(() {
  //         loading = false;
  //         CustomWidget(context: context).showSuccessAlertDialog(
  //             "Imperial", loginData.message.toString(), "success");
  //
  //         amountController.clear();
  //         addressController.clear();
  //         getCoinList();
  //         searchCoinList.clear();
  //         coinList.clear();
  //         coinList = [];
  //         searchCoinList = [];
  //       });
  //     } else {
  //       setState(() {
  //         loading = false;
  //         CustomWidget(context: context).showSuccessAlertDialog(
  //             "Imperial", loginData.message.toString(), "error");
  //       });
  //     }
  //   }).catchError((Object error) {
  //     setState(() {
  //       loading = false;
  //     });
  //   });
  // }

  resndOTP() {
    setState(() {
      loading = true;
    });
    apiUtils.resendWithdrawOTP(axn_id).then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Imperial", loginData.message.toString(), "success");
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Imperial", loginData.message.toString(), "error");
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

  getCoinList() {
    apiUtils.walletBalanceInfo().then((UserWalletBalanceModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          coinList = loginData.result!;
          searchCoinList = loginData.result!;
          selectedCoin = coinList.first;

          // getDetails();
          coinList..sort((a, b) => b.balance!.compareTo(a.balance!));
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

  getWallList() {
    apiUtils.getWalletList().then((GetWalletAllPairsModel loginData) {
      if (loginData.success!) {
        setState(() {
          walletPair = loginData.result!;
          // walletBalance = loginData.totalPriceInUsd!.toString();
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
