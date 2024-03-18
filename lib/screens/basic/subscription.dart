import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imperial/screens/basic/subs_details.dart';

import '../../common/custom_widget.dart';
import '../../data/api_utils.dart';
import '../../data/crypt_model/my_subscription_model.dart';

class Subscription_Screen extends StatefulWidget {
  const Subscription_Screen({Key? key}) : super(key: key);

  @override
  State<Subscription_Screen> createState() => _Subscription_ScreenState();
}

class _Subscription_ScreenState extends State<Subscription_Screen> {


  APIUtils apiUtils = APIUtils();
  bool loading = false;
  List<SubscriptionDetails> subscripDetails=[];
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            "Subscription",
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
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 0.0),
            child: Stack(
              children: [
                Text(
                  "Add New Exchange Account",
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      12.0,
                      Theme.of(context).focusColor,
                      FontWeight.w700,
                      'FontRegular'),
                  textAlign: TextAlign.start,
                ),
                loading
                    ? CustomWidget(context: context).loadingIndicator(
                  Theme.of(context).disabledColor,
                )
                    :  Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                  child: SingleChildScrollView(
                    child: subscripDetails.length>0 ?
                    ListView.builder(
                      itemCount: subscripDetails.length,
                      shrinkWrap: true,
                      controller: controller,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Theme.of(context).canvasColor,
                            border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset("assets/icons/logo.png",height: 40.0, fit: BoxFit.fitWidth,),
                                  const SizedBox(width: 10.0,),
                                  Text(
                                    subscripDetails[index].exchange.toString().toUpperCase(),
                                    style: CustomWidget(context: context).CustomSizedTextStyle(
                                        22.0,
                                        Theme.of(context).focusColor,
                                        FontWeight.w700,
                                        'FontRegular'),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25.0,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Referral Bonus",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(height: 5.0,),
                                      Text(
                                        "Yes",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            16.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w700,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Subaccounts",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(height: 5.0,),
                                      Text(
                                        "Yes",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            16.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w700,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 25.0,),
                                ],
                              ),
                              const SizedBox(height: 25.0,),
                              Text(
                                "Supported Types",
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    14.0,
                                    Theme.of(context).focusColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 5.0,),
                              Text(
                                "Spot, USDⓈ-M, COIN-M",
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context).focusColor,
                                    FontWeight.w700,
                                    'FontRegular'),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 30.0,),
                              Align(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: (){
                                    // Navigator.of(context).push(
                                    //     MaterialPageRoute(builder: (context) => Subs_details(title: "ImperialX")));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.0),
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    child: Text(
                                      "Edit",
                                      style: CustomWidget(context: context).CustomSizedTextStyle(
                                          14.0,
                                          Theme.of(context).splashColor,
                                          FontWeight.w600,
                                          'FontRegular'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15.0,),

                            ],
                          ),
                        );
                      },
                    )
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Theme.of(context).canvasColor,
                            border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset("assets/icons/logo.png",height: 40.0, fit: BoxFit.fitWidth,),
                                  const SizedBox(width: 10.0,),
                                  Text(
                                    "ImperialX",
                                    style: CustomWidget(context: context).CustomSizedTextStyle(
                                        22.0,
                                        Theme.of(context).focusColor,
                                        FontWeight.w700,
                                        'FontRegular'),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25.0,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Referral Bonus",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(height: 5.0,),
                                      Text(
                                        "Yes",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            16.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w700,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Subaccounts",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(height: 5.0,),
                                      Text(
                                        "Yes",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            16.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w700,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 25.0,),
                                ],
                              ),
                              const SizedBox(height: 25.0,),
                              Text(
                                "Supported Types",
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    14.0,
                                    Theme.of(context).focusColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 5.0,),
                              Text(
                                "Spot, USDⓈ-M, COIN-M",
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context).focusColor,
                                    FontWeight.w700,
                                    'FontRegular'),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 30.0,),
                              Align(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => Subs_details(title: "ImperialX")));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.0),
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    child: Text(
                                      "Subscribe",
                                      style: CustomWidget(context: context).CustomSizedTextStyle(
                                          14.0,
                                          Theme.of(context).splashColor,
                                          FontWeight.w600,
                                          'FontRegular'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15.0,),

                            ],
                          ),
                        ),
                        const SizedBox(height: 25.0,),
                        Container(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Theme.of(context).canvasColor,
                            border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset("assets/menu/binance.svg",height: 40.0, fit: BoxFit.fitWidth,),
                                  const SizedBox(width: 10.0,),
                                  Text(
                                    "Binance",
                                    style: CustomWidget(context: context).CustomSizedTextStyle(
                                        22.0,
                                        Theme.of(context).focusColor,
                                        FontWeight.w700,
                                        'FontRegular'),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25.0,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Referral Bonus",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(height: 5.0,),
                                      Text(
                                        "Yes",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            16.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w700,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Subaccounts",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(height: 5.0,),
                                      Text(
                                        "Yes",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            16.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w700,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 25.0,),
                                ],
                              ),
                              const SizedBox(height: 25.0,),
                              Text(
                                "Supported Types",
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    14.0,
                                    Theme.of(context).focusColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 5.0,),
                              Text(
                                "Spot, USDⓈ-M, COIN-M",
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context).focusColor,
                                    FontWeight.w700,
                                    'FontRegular'),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 30.0,),
                              Align(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => Subs_details(title: "Binance")));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.0),
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    child: Text(
                                      "Subscribe",
                                      style: CustomWidget(context: context).CustomSizedTextStyle(
                                          14.0,
                                          Theme.of(context).splashColor,
                                          FontWeight.w600,
                                          'FontRegular'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15.0,),

                            ],
                          ),
                        ),
                        const SizedBox(height: 25.0,),
                        Container(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Theme.of(context).canvasColor,
                            border: Border.all(width: 1.0, color: Theme.of(context).disabledColor,),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset("assets/menu/okx.svg",height: 40.0, fit: BoxFit.fitWidth,),
                                  const SizedBox(width: 10.0,),
                                  Text(
                                    "OKX",
                                    style: CustomWidget(context: context).CustomSizedTextStyle(
                                        22.0,
                                        Theme.of(context).focusColor,
                                        FontWeight.w700,
                                        'FontRegular'),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25.0,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Referral Bonus",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(height: 5.0,),
                                      Text(
                                        "Yes",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            16.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w700,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Subaccounts",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(height: 5.0,),
                                      Text(
                                        "Yes",
                                        style: CustomWidget(context: context).CustomSizedTextStyle(
                                            16.0,
                                            Theme.of(context).focusColor,
                                            FontWeight.w700,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 25.0,),
                                ],
                              ),
                              const SizedBox(height: 25.0,),
                              Text(
                                "Supported Types",
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    14.0,
                                    Theme.of(context).focusColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 5.0,),
                              Text(
                                "Spot, Futures",
                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                    16.0,
                                    Theme.of(context).focusColor,
                                    FontWeight.w700,
                                    'FontRegular'),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 30.0,),
                              Align(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => Subs_details(title: "OKX")));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.0),
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    child: Text(
                                      "Subscribe",
                                      style: CustomWidget(context: context).CustomSizedTextStyle(
                                          14.0,
                                          Theme.of(context).splashColor,
                                          FontWeight.w600,
                                          'FontRegular'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15.0,),

                            ],
                          ),
                        ),
                        const SizedBox(height: 25.0,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  getWallList() {
    apiUtils.getMySubsDetails().then((SubscriptionDetailsModel loginData) {
      if (loginData.success!) {
        setState(() {
          subscripDetails = loginData.result!;
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
