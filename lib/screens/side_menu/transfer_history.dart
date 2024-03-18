import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imperial/common/custom_widget.dart';
import 'package:imperial/common/theme/custom_theme.dart';
import 'package:imperial/data/api_utils.dart';
import 'package:imperial/data/crypt_model/transfer_history_model.dart';

class Transfer_History extends StatefulWidget {
  const Transfer_History({super.key});

  @override
  State<Transfer_History> createState() => _Transfer_HistoryState();
}

class _Transfer_HistoryState extends State<Transfer_History> {

  bool loading = false;
  List<InternalTransferResult> trasactionListDetails = [];
  APIUtils apiUtils = APIUtils();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    getTransList();
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
                "Transfer History",
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
              )),
          body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
              child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Stack(
                    children: [
                      history(),
                      loading
                          ? CustomWidget(context: context).loadingIndicator(
                        Theme.of(context).disabledColor,
                      )
                          : Container()
                    ],
                  ))),
        ));
  }


  Widget history() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0,),
            trasactionListDetails.length > 0
                ?
            Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: ListView.builder(
                    itemCount: trasactionListDetails.length,
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemBuilder: (BuildContext context, int index) {
                      // double staked=double.parse(stackList[index].noOfCoin.toString())/double.parse(livePrice);
                      // double total=double.parse(stackList[index].totalEstimatedReward.toString())/double.parse(livePrice);
                      return Column(
                        children: [
                          Container(
                            width:
                            MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(top: 15.0,bottom: 15.0
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(10.0),
                              border: Border.all(width: 1.0, color: Theme.of(context).disabledColor),
                              // color: Theme.of(context).focusColor,
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0),child:    Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Order ID",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .focusColor.withOpacity(0.5),
                                              FontWeight.w400,
                                              'FontRegular'),
                                          textAlign: TextAlign.center,
                                        ),
                                       Container(
                                         width: MediaQuery.of(context).size.width *0.4,
                                         child:  Text(
                                           trasactionListDetails[index].id.toString(),
                                           style: CustomWidget(
                                               context: context)
                                               .CustomSizedTextStyle(
                                               14.0,
                                               Theme.of(context)
                                                   .focusColor,
                                               FontWeight.w600,
                                               'FontRegular'),
                                           textAlign: TextAlign.center,
                                           overflow: TextOverflow.ellipsis,
                                         ),
                                       )
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    ),
                                    Column(

                                      children: [
                                        Text(
                                          "Date ",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .focusColor.withOpacity(0.5),
                                              FontWeight.w400,
                                              'FontRegular'),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          trasactionListDetails[index].createdAt.toString(),
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .focusColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                    )
                                  ],
                                ),),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Container(
                                  height: 1.0,
                                  color: Theme.of(context).disabledColor.withOpacity(0.5),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0),child:    Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Currency ",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .focusColor.withOpacity(0.5),
                                              FontWeight.w400,
                                              'FontRegular'),
                                          textAlign: TextAlign.start,
                                        ),
                                        Text(
                                          trasactionListDetails[index].currency.toString().toUpperCase(),
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .focusColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    ),
                                    Column(

                                      children: [
                                        Text(
                                          "Amount",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .focusColor.withOpacity(0.5),
                                              FontWeight.w400,
                                              'FontRegular'),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          trasactionListDetails[index]
                                              .amount.toString().toUpperCase(),
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .focusColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                    )
                                  ],
                                ),),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0),child:    Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "From",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .focusColor.withOpacity(0.5),
                                              FontWeight.w400,
                                              'FontRegular'),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          trasactionListDetails[index].from.toString().toUpperCase(),
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .focusColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    ),
                                    Column(

                                      children: [
                                        Text(
                                          "To",
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .focusColor.withOpacity(0.5),
                                              FontWeight.w400,
                                              'FontRegular'),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          trasactionListDetails[index].to.toString(),
                                          style: CustomWidget(
                                              context: context)
                                              .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .focusColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                    )
                                  ],
                                ),),
                                // const SizedBox(
                                //   height: 10.0,
                                // ),
                                // Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0),child:    Row(
                                //   crossAxisAlignment:
                                //   CrossAxisAlignment.center,
                                //   mainAxisAlignment:
                                //   MainAxisAlignment
                                //       .spaceBetween,
                                //   children: [
                                //     Column(
                                //       children: [
                                //         Text(
                                //           "Trade Type",
                                //           style: CustomWidget(
                                //               context: context)
                                //               .CustomSizedTextStyle(
                                //               12.0,
                                //               Theme.of(context)
                                //                   .focusColor.withOpacity(0.5),
                                //               FontWeight.w400,
                                //               'FontRegular'),
                                //           textAlign: TextAlign.center,
                                //         ),
                                //         Text(
                                //           trasactionListDetails[index]
                                //               .tradeType.toString().toUpperCase(),
                                //           style: CustomWidget(
                                //               context: context)
                                //               .CustomSizedTextStyle(
                                //               12.0,
                                //               Theme.of(context)
                                //                   .focusColor,
                                //               FontWeight.w500,
                                //               'FontRegular'),
                                //           textAlign: TextAlign.center,
                                //         ),
                                //       ],
                                //       crossAxisAlignment: CrossAxisAlignment.start,
                                //     ),
                                //     Column(
                                //
                                //       children: [
                                //         Text(
                                //           "Leverage",
                                //           style: CustomWidget(
                                //               context: context)
                                //               .CustomSizedTextStyle(
                                //               12.0,
                                //               Theme.of(context)
                                //                   .focusColor.withOpacity(0.5),
                                //               FontWeight.w400,
                                //               'FontRegular'),
                                //           textAlign: TextAlign.center,
                                //         ),
                                //         Text(
                                //           historyList[index].leverage.toString()=="null"|| historyList[index].leverage.toString()==null ? "0" : historyList[index].leverage.toString(),
                                //           style: CustomWidget(
                                //               context: context)
                                //               .CustomSizedTextStyle(
                                //               12.0,
                                //               Theme.of(context)
                                //                   .focusColor,
                                //               FontWeight.w500,
                                //               'FontRegular'),
                                //           textAlign: TextAlign.center,
                                //         ),
                                //       ],
                                //       crossAxisAlignment: CrossAxisAlignment.end,
                                //     )
                                //   ],
                                // ),),

                                const SizedBox(
                                  height: 5.0,
                                ),
                                // Container(
                                //   height: 1.0,
                                //   color: Theme.of(context).disabledColor.withOpacity(0.5),
                                // ),
                                // const SizedBox(
                                //   height: 5.0,
                                // ),
                                // Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0),child:    Row(
                                //   crossAxisAlignment:
                                //   CrossAxisAlignment.center,
                                //   mainAxisAlignment:
                                //   MainAxisAlignment
                                //       .spaceBetween,
                                //   children: [
                                //     // Column(
                                //     //   children: [
                                //     //     Text(
                                //     //       "Next Reward",
                                //     //       style: CustomWidget(
                                //     //           context: context)
                                //     //           .CustomSizedTextStyle(
                                //     //           12.0,
                                //     //           Theme.of(context)
                                //     //               .cardColor.withOpacity(0.5),
                                //     //           FontWeight.w400,
                                //     //           'FontRegular'),
                                //     //       textAlign: TextAlign.center,
                                //     //     ),
                                //     //     Text(
                                //     //       stackList[index]
                                //     //           .nextReward
                                //     //           .toString(),
                                //     //       style: CustomWidget(
                                //     //           context: context)
                                //     //           .CustomSizedTextStyle(
                                //     //           12.0,
                                //     //           Theme.of(context)
                                //     //               .cardColor,
                                //     //           FontWeight.w500,
                                //     //           'FontRegular'),
                                //     //       textAlign: TextAlign.center,
                                //     //     ),
                                //     //   ],
                                //     //   crossAxisAlignment: CrossAxisAlignment.start,
                                //     // ),
                                //     Column(
                                //
                                //       children: [
                                //         Text(
                                //           "Action",
                                //           style: CustomWidget(
                                //               context: context)
                                //               .CustomSizedTextStyle(
                                //               12.0,
                                //               Theme.of(context)
                                //                   .focusColor.withOpacity(0.5),
                                //               FontWeight.w400,
                                //               'FontRegular'),
                                //           textAlign: TextAlign.center,
                                //         ),
                                //         Text(
                                //           "---",
                                //           style: CustomWidget(
                                //               context: context)
                                //               .CustomSizedTextStyle(
                                //               12.0,
                                //               Theme.of(context)
                                //                   .focusColor,
                                //               FontWeight.w500,
                                //               'FontRegular'),
                                //           textAlign: TextAlign.center,
                                //         ),
                                //       ],
                                //       crossAxisAlignment: CrossAxisAlignment.end,
                                //     )
                                //   ],
                                // ),),
                                // const SizedBox(
                                //   height: 5.0,
                                // ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                        ],
                      );
                    },
                  ),
                ))
                : Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Center(
                child: Text(
                  "No Records Found..!",
                  style: CustomWidget(context: context)
                      .CustomSizedTextStyle(
                      16.0,
                      CustomTheme.of(context).focusColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
          ],
        ),
      ),
    );
  }



  getTransList() {
    apiUtils.transferList().then((InternalTransferModel loginData) {
      if (loginData.success!) {
        setState(() {
          trasactionListDetails = loginData.result!;
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
