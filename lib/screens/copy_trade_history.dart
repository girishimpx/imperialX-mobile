import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/custom_widget.dart';

class Copy_Trade_History extends StatefulWidget {
  const Copy_Trade_History({Key? key}) : super(key: key);

  @override
  State<Copy_Trade_History> createState() => _Copy_Trade_HistoryState();
}

class _Copy_Trade_HistoryState extends State<Copy_Trade_History> {

  ScrollController controller = ScrollController();

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
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10.0,),
                  ListView.builder(
                    itemCount: 8,
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
                                          padding: EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.arrow_downward_outlined,
                                            size: 24.0,
                                            color: Theme.of(context)
                                                .hoverColor,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Sell",
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  16.0,
                                                  Theme.of(context)
                                                      .focusColor,
                                                  FontWeight.w600,
                                                  'FontRegular'),
                                              textAlign: TextAlign.start,
                                            ),
                                            const SizedBox(
                                              height: 6.0,
                                            ),
                                            Text(
                                              "Aug 12, 2021"+ " 9:10 PM",
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .bottomAppBarColor,
                                                  FontWeight.w400,
                                                  'FontRegular'),
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
                                    CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "+16 \$",
                                        style:
                                        CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            16.0,
                                            Theme.of(context)
                                                .focusColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(
                                        height: 6.0,
                                      ),
                                      Text(
                                        "+0,00002256 BTC",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            12.0,
                                            Theme.of(context).indicatorColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      )

                                    ],
                                  ),
                                  flex: 2,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                        ],
                      );
                    },
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
