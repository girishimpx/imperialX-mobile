import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/custom_widget.dart';

class Analytics_Screen extends StatefulWidget {
  const Analytics_Screen({Key? key}) : super(key: key);

  @override
  State<Analytics_Screen> createState() => _Analytics_ScreenState();
}

class _Analytics_ScreenState extends State<Analytics_Screen> {

  bool spot= false;
  bool margin= false;
  bool future= false;
  ScrollController controller = ScrollController();


  @override
  void initState() {
    // TODO: implement initState
    spot= true;
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
            "Analytics",
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          setState(() {
                            spot = true;
                            margin = false;
                            future = false;
                          });
                        },
                        child:  Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 8.0),
                          decoration: spot ? BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color: Theme.of(context).canvasColor,
                          ) : BoxDecoration(),
                          child:  Text(
                            "Spot",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                16.0,
                                spot ? Theme.of(context).disabledColor: Theme.of(context).dividerColor,
                                spot ? FontWeight.w600 : FontWeight.w400,
                                'FontRegular'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0,),
                      InkWell(
                        onTap: (){
                          setState(() {
                            spot = false;
                            margin = true;
                            future = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 8.0),
                          decoration: margin?  BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color: Theme.of(context).canvasColor,
                          ): BoxDecoration(),
                          child:  Text(
                            "Margin",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                16.0,
                                margin? Theme.of(context).disabledColor : Theme.of(context).dividerColor,
                                margin?  FontWeight.w600 : FontWeight.w400,
                                'FontRegular'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0,),
                      InkWell(
                        onTap: (){
                          setState(() {
                            spot = false;
                            margin = false;
                            future = true;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 8.0),
                          decoration: future ? BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color: Theme.of(context).canvasColor,
                          ) : BoxDecoration(),
                          child:  Text(
                            "Future",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                16.0,
                                future ? Theme.of(context).disabledColor : Theme.of(context).dividerColor,
                                future ? FontWeight.w600 : FontWeight.w400,
                                'FontRegular'),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20.0,),
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
                                            Icons.arrow_upward_outlined,
                                            size: 24.0,
                                            color: Theme.of(context)
                                                .indicatorColor,
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
                                              "Buy",
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
                                                      .primaryColorDark,
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
