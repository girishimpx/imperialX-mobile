

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/custom_widget.dart';
import '../common/theme/custom_theme.dart';
import '../data/api_utils.dart';
import '../data/crypt_model/copy_trade_history_model.dart';
import '../data/crypt_model/trade_his_list_model.dart';

class Copy_Trade_History extends StatefulWidget {
  const Copy_Trade_History({Key? key}) : super(key: key);

  @override
  State<Copy_Trade_History> createState() => _Copy_Trade_HistoryState();
}

class _Copy_Trade_HistoryState extends State<Copy_Trade_History> {

  ScrollController controller = ScrollController();
  APIUtils apiUtils = APIUtils();
  bool loading=false;
  int page=1;
  List<Doc> historyList = [];
  void _onScroll() {
    if (controller.position.pixels ==
        controller.position.maxScrollExtent) {
      print('Reached the end of the list');
      setState(() {
        page++;
        loading=true;
        getTradeHistory(page.toString());
      });


    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(_onScroll);
    loading=true;
      getTradeHistory(page.toString());
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
            "Copy Trade History",
            style: CustomWidget(context: context)
                .CustomSizedTextStyle(
                18.0,
                Theme.of(context).focusColor,
                FontWeight.w600,
                'FontRegular'),
          ),
          //centerTitle: true,
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
        body: Stack(children: [
          Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).primaryColor,
          child:
            Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
              child:
              historyList.length>0?
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.78,
                  child:
                  ListView.builder(
                    itemCount: historyList.length>0?historyList.length:0,
                    shrinkWrap: true,
                    controller: controller,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 10.0,
                                top: 10.0,
                                bottom: 15.0,
                                right: 10.0),
                            decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.circular(10.0)),
                            child:
                                Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                  Text(
                                    "${historyList[index].pair.toString().trim()?? ""}",
                                    style:
                                    CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        14.0,
                                        Theme.of(context)
                                            .focusColor,
                                        FontWeight.w400,
                                        'FontRegular'),overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(
                                    height: 6.0,
                                  ),
                            Row(
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
                                          padding: EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: historyList[index].tradeType.toString().toLowerCase()=="sell"?Icon(
                                            Icons.arrow_downward_outlined,
                                            size: 24.0,
                                            color: Theme.of(context)
                                                .hoverColor,
                                          ):Icon(
                                            Icons.arrow_upward_outlined,
                                            size: 24.0,
                                            color: Theme.of(context)
                                                .indicatorColor,
                                          ),
                                        ),
                                        // const SizedBox(
                                        //   width: 10.0,
                                        // ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${historyList[index].tradeType.toString() ?? ""}",
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  16.0,
                                                  Theme.of(context)
                                                      .focusColor,
                                                  FontWeight.w600,
                                                  'FontRegular'),overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.start,
                                            ),
                                            const SizedBox(
                                              height: 6.0,
                                            ),
                                            Text(
                                              "${historyList[index].createdAt.toString().split(" ")[0]  ?? ""}",
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .primaryColorDark,
                                                  FontWeight.w400,
                                                  'FontRegular'),overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  flex: 3,
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${historyList[index].tradeAt.toString().trim()?? ""}",
                                        style:
                                        CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            16.0,
                                            Theme.of(context)
                                                .focusColor,
                                            FontWeight.w400,
                                            'FontRegular'),overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(
                                        height: 6.0,
                                      ),
                                      Text(
                                        "${historyList[index].entryPrice.toString().trim() ?? ""}",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            12.0,
                                            Theme.of(context).indicatorColor,
                                            FontWeight.w400,
                                            'FontRegular'),overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                      )

                                    ],
                                  ),
                                  flex: 2,
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${historyList[index].orderType.toString().trim()?? ""}",
                                        style:
                                        CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            16.0,
                                            Theme.of(context)
                                                .focusColor,
                                            FontWeight.w400,
                                            'FontRegular'),overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(
                                        height: 6.0,
                                      ),
                                      Text(
                                        "${historyList[index].volume.toString().trim() ?? ""}",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            12.0,
                                            Theme.of(context).indicatorColor,
                                            FontWeight.w400,
                                            'FontRegular'),overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                      )

                                    ],
                                  ),
                                  flex: 2,
                                ),

                              ],
                            ),
                                ],),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                        ],
                      );
                    },
              )):
              Center(child: Text(
                "No Result Found...",
                style: CustomWidget(
                    context: context)
                    .CustomSizedTextStyle(
                    16.0,
                    Theme.of(context)
                        .focusColor,
                    FontWeight.w600,
                    'FontRegular'),
                textAlign: TextAlign.start,
              ),),
            ),),
              loading
                  ? CustomWidget(context: context)
                  .loadingIndicator(CustomTheme
                  .of(context)
                  .disabledColor)
                  : SizedBox(height: 0, width: 0)
          ]),
          ),

    );
  }
  getTradeHistory(String page) async {
    print("hi");
    await apiUtils.getcopyTradeHistoryList(page).then((
        CopyTradeHistoryModel loginData) {
      if (loginData.success!) {
        setState(() {
          historyList=loginData.result!.docs!.cast<Doc>();
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading=false;
      });
      print(error);
    });
  }
}
