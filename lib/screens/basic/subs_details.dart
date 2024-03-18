import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imperial/screens/basic/subscription.dart';

import '../../common/custom_widget.dart';
import '../../common/localization/localizations.dart';
import '../../common/textformfield_custom.dart';
import '../../data/api_utils.dart';
import '../../data/crypt_model/common_model.dart';
import '../../data/crypt_model/subscribe.dart';

class Subs_details extends StatefulWidget {
  final String title;

  const Subs_details({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<Subs_details> createState() => _Subs_detailsState();
}

class _Subs_detailsState extends State<Subs_details> {
  bool next = false;
  bool nexttwo = false;
  bool passVisible = false;
  bool conpassVisible = false;

  FocusNode nameFocus = FocusNode();
  FocusNode secretKeyFocus = FocusNode();
  FocusNode apiKeyFocus = FocusNode();
  FocusNode typeFocus = FocusNode();
  FocusNode passphraseFocus = FocusNode();
  FocusNode permissionFocus = FocusNode();
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController apiKeyController = TextEditingController();
  TextEditingController secretKeyController = TextEditingController();
  TextEditingController passphraseController = TextEditingController();
  TextEditingController permissionController = TextEditingController();

  bool spot = false;
  bool margin = false;
  bool future = false;
  APIUtils apiUtils = APIUtils();
  bool loading = false;
  String spotValue = "";
  final loginformKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // next = true;
    typeController = TextEditingController(text: widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(right: 1.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (next == true) {
                    next = false;
                    nexttwo = false;
                  } else {
                    Navigator.pop(context);
                  }
                });
              },
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20.0,
                color: Theme.of(context).focusColor,
              ),
            ),
          ),
          title: Text(
            "Subscription",
            style: CustomWidget(context: context).CustomSizedTextStyle(18.0,
                Theme.of(context).focusColor, FontWeight.w600, 'FontRegular'),
          ),
          centerTitle: true,
          actions: [
            Container(
              padding: EdgeInsets.only(right: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    child: Icon(
                      Icons.star_border_outlined,
                      size: 20.0,
                      color: Theme.of(context).focusColor,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
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
              padding: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Theme.of(context).canvasColor,
                        border: Border.all(
                          width: 1.0,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row(
                              //   children: [
                              //     SvgPicture.asset(
                              //       "assets/menu/binance.svg",
                              //       height: 40.0,
                              //       fit: BoxFit.fitWidth,
                              //     ),
                              //     const SizedBox(
                              //       width: 10.0,
                              //     ),
                              //     Text(
                              //       "Binance",
                              //       style: CustomWidget(context: context)
                              //           .CustomSizedTextStyle(
                              //           24.0,
                              //           Theme.of(context).focusColor,
                              //           FontWeight.w700,
                              //           'FontRegular'),
                              //       textAlign: TextAlign.start,
                              //     ),
                              //   ],
                              // ),
                              Text(
                                // "Binance",
                                widget.title,
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        24.0,
                                        Theme.of(context).focusColor,
                                        FontWeight.w700,
                                        'FontRegular'),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                height: 25.0,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "1 Step",
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                                7.0,
                                                Theme.of(context).focusColor,
                                                FontWeight.w500,
                                                'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "Create Account",
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                                10.0,
                                                Theme.of(context).focusColor,
                                                FontWeight.w700,
                                                'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/menu/next.svg",
                                        height: 12.0,
                                        fit: BoxFit.fitWidth,
                                        color: Theme.of(context).disabledColor,
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "2 Step",
                                            style: CustomWidget(context: context)
                                                .CustomSizedTextStyle(
                                                    7.0,
                                                    Theme.of(context)
                                                        .focusColor
                                                        .withOpacity(0.6),
                                                    FontWeight.w500,
                                                    'FontRegular'),
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            "Create API Key",
                                            style: CustomWidget(context: context)
                                                .CustomSizedTextStyle(
                                                    10.0,
                                                    Theme.of(context)
                                                        .focusColor
                                                        .withOpacity(0.6),
                                                    FontWeight.w700,
                                                    'FontRegular'),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/menu/next.svg",
                                        height: 12.0,
                                        fit: BoxFit.fitWidth,
                                        color: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.6),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "3 Step",
                                            style: CustomWidget(context: context)
                                                .CustomSizedTextStyle(
                                                    7.0,
                                                    Theme.of(context)
                                                        .focusColor
                                                        .withOpacity(0.6),
                                                    FontWeight.w500,
                                                    'FontRegular'),
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            "Enter Your Key",
                                            style: CustomWidget(context: context)
                                                .CustomSizedTextStyle(
                                                    10.0,
                                                    Theme.of(context)
                                                        .focusColor
                                                        .withOpacity(0.6),
                                                    FontWeight.w700,
                                                    'FontRegular'),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 25.0,
                              ),
                              next
                                  ? Container(
                                      child: nexttwo
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                  Text(
                                                    "Enter Your Key",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            18.0,
                                                            Theme.of(context)
                                                                .focusColor,
                                                            FontWeight.w700,
                                                            'FontRegular'),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  const SizedBox(
                                                    height: 15.0,
                                                  ),
                                                  Form(
                                                      key: loginformKey,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Exchange",
                                                            style: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    10.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .focusColor
                                                                        .withOpacity(
                                                                            0.6),
                                                                    FontWeight
                                                                        .w400,
                                                                    'FontRegular'),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          const SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          TextFormFieldCustom(
                                                            onEditComplete: () {
                                                              typeFocus.unfocus();
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      apiKeyFocus);
                                                            },
                                                            radius: 8.0,
                                                            error: " ",
                                                            textColor:
                                                                Theme.of(context)
                                                                    .focusColor,
                                                            borderColor: Theme.of(
                                                                    context)
                                                                .disabledColor
                                                                .withOpacity(0.2),
                                                            fillColor:
                                                                Theme.of(context)
                                                                    .canvasColor,
                                                            hintStyle: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    12.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .dividerColor,
                                                                    FontWeight
                                                                        .w400,
                                                                    'FontRegular'),
                                                            textStyle: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    12.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .focusColor,
                                                                    FontWeight
                                                                        .w500,
                                                                    'FontRegular'),
                                                            textInputAction:
                                                                TextInputAction
                                                                    .next,
                                                            focusNode: typeFocus,
                                                            maxlines: 1,
                                                            text: '',
                                                            hintText: " ",
                                                            obscureText: false,
                                                            suffix: Container(
                                                              width: 0.0,
                                                            ),
                                                            textChanged:
                                                                (value) {},
                                                            onChanged: () {},
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return "Name";
                                                              }
                                                              // else if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                              //     .hasMatch(value)) {
                                                              //   return "Please enter valid email";
                                                              // }
                                                              return null;
                                                            },
                                                            enabled: false,
                                                            textInputType:
                                                                TextInputType
                                                                    .name,
                                                            controller:
                                                                typeController,
                                                          ),
                                                          const SizedBox(
                                                            height: 15.0,
                                                          ),
                                                          Text(
                                                            "API Key",
                                                            style: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    10.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .focusColor
                                                                        .withOpacity(
                                                                            0.6),
                                                                    FontWeight
                                                                        .w400,
                                                                    'FontRegular'),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          const SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          TextFormFieldCustom(
                                                            obscureText:
                                                                !passVisible,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .next,
                                                            textColor:
                                                                Theme.of(context)
                                                                    .primaryColor,
                                                            borderColor: Theme.of(
                                                                    context)
                                                                .disabledColor
                                                                .withOpacity(0.2),
                                                            fillColor:
                                                                Theme.of(context)
                                                                    .canvasColor,
                                                            hintStyle: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    12.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .dividerColor,
                                                                    FontWeight
                                                                        .w400,
                                                                    'FontRegular'),
                                                            textStyle: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    12.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .focusColor,
                                                                    FontWeight
                                                                        .w500,
                                                                    'FontRegular'),
                                                            radius: 8.0,
                                                            focusNode:
                                                                apiKeyFocus,
                                                            suffix: IconButton(
                                                              icon: Icon(
                                                                passVisible
                                                                    ? Icons
                                                                        .visibility
                                                                    : Icons
                                                                        .visibility_off,
                                                                color: Theme.of(
                                                                        context)
                                                                    .focusColor,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  passVisible =
                                                                      !passVisible;
                                                                });
                                                              },
                                                            ),
                                                            controller:
                                                                apiKeyController,
                                                            enabled: true,
                                                            onChanged: () {},
                                                            hintText:
                                                                "Enter your API key",
                                                            textChanged:
                                                                (value) {},
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return "Please enter API key";
                                                              }
                                                              return null;
                                                            },
                                                            maxlines: 1,
                                                            error:
                                                                "Enter Valid API key",
                                                            text: "",
                                                            onEditComplete: () {
                                                              apiKeyFocus
                                                                  .unfocus();
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      secretKeyFocus);
                                                            },
                                                            textInputType:
                                                                TextInputType
                                                                    .visiblePassword,
                                                          ),
                                                          const SizedBox(
                                                            height: 15.0,
                                                          ),
                                                          Text(
                                                            "Secret Key",
                                                            style: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    10.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .focusColor
                                                                        .withOpacity(
                                                                            0.6),
                                                                    FontWeight
                                                                        .w400,
                                                                    'FontRegular'),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          const SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          TextFormFieldCustom(
                                                            obscureText:
                                                                !conpassVisible,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .next,
                                                            textColor:
                                                                Theme.of(context)
                                                                    .primaryColor,
                                                            borderColor: Theme.of(
                                                                    context)
                                                                .disabledColor
                                                                .withOpacity(0.2),
                                                            fillColor:
                                                                Theme.of(context)
                                                                    .canvasColor,
                                                            hintStyle: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    12.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .dividerColor,
                                                                    FontWeight
                                                                        .w400,
                                                                    'FontRegular'),
                                                            textStyle: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    12.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .focusColor,
                                                                    FontWeight
                                                                        .w500,
                                                                    'FontRegular'),
                                                            radius: 8.0,
                                                            focusNode:
                                                                secretKeyFocus,
                                                            suffix: IconButton(
                                                              icon: Icon(
                                                                conpassVisible
                                                                    ? Icons
                                                                        .visibility
                                                                    : Icons
                                                                        .visibility_off,
                                                                color: Theme.of(
                                                                        context)
                                                                    .focusColor,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  conpassVisible =
                                                                      !conpassVisible;
                                                                });
                                                              },
                                                            ),
                                                            controller:
                                                                secretKeyController,
                                                            enabled: true,
                                                            onChanged: () {},
                                                            hintText:
                                                                "Enter your secret key",
                                                            textChanged:
                                                                (value) {},
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return "Please enter secret key";
                                                              }

                                                              return null;
                                                            },
                                                            maxlines: 1,
                                                            error:
                                                                "Enter valid secret key",
                                                            text: "",
                                                            onEditComplete: () {
                                                              secretKeyFocus
                                                                  .unfocus();
                                                            },
                                                            textInputType:
                                                                TextInputType
                                                                    .visiblePassword,
                                                          ),
                                                          const SizedBox(
                                                            height: 15.0,
                                                          ),
                                                          Text(
                                                            "API Name",
                                                            style: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    10.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .focusColor
                                                                        .withOpacity(
                                                                            0.6),
                                                                    FontWeight
                                                                        .w400,
                                                                    'FontRegular'),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          const SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          TextFormFieldCustom(
                                                            onEditComplete: () {
                                                              nameFocus.unfocus();
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      passphraseFocus);
                                                            },
                                                            radius: 8.0,
                                                            error:
                                                                "Enter API Name",
                                                            textColor:
                                                                Theme.of(context)
                                                                    .focusColor,
                                                            borderColor: Theme.of(
                                                                    context)
                                                                .disabledColor
                                                                .withOpacity(0.2),
                                                            fillColor:
                                                                Theme.of(context)
                                                                    .canvasColor,
                                                            hintStyle: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    12.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .dividerColor,
                                                                    FontWeight
                                                                        .w400,
                                                                    'FontRegular'),
                                                            textStyle: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    12.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .focusColor,
                                                                    FontWeight
                                                                        .w500,
                                                                    'FontRegular'),
                                                            textInputAction:
                                                                TextInputAction
                                                                    .next,
                                                            focusNode: nameFocus,
                                                            maxlines: 1,
                                                            text: '',
                                                            hintText:
                                                                "Enter your API Name",
                                                            obscureText: false,
                                                            suffix: Container(
                                                              width: 0.0,
                                                            ),
                                                            textChanged:
                                                                (value) {},
                                                            onChanged: () {},
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return "Please enter API Name";
                                                              }
                                                              return null;
                                                            },
                                                            enabled: true,
                                                            textInputType:
                                                                TextInputType
                                                                    .name,
                                                            controller:
                                                                nameController,
                                                          ),
                                                          const SizedBox(
                                                            height: 15.0,
                                                          ),
                                                          Text(
                                                            "Passphrase",
                                                            style: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    10.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .focusColor
                                                                        .withOpacity(
                                                                            0.6),
                                                                    FontWeight
                                                                        .w400,
                                                                    'FontRegular'),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          const SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          TextFormFieldCustom(
                                                            onEditComplete: () {
                                                              passphraseFocus
                                                                  .unfocus();
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      permissionFocus);
                                                            },
                                                            radius: 8.0,
                                                            error: " ",
                                                            textColor:
                                                                Theme.of(context)
                                                                    .focusColor,
                                                            borderColor: Theme.of(
                                                                    context)
                                                                .disabledColor
                                                                .withOpacity(0.2),
                                                            fillColor:
                                                                Theme.of(context)
                                                                    .canvasColor,
                                                            hintStyle: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    12.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .dividerColor,
                                                                    FontWeight
                                                                        .w400,
                                                                    'FontRegular'),
                                                            textStyle: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    12.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .focusColor,
                                                                    FontWeight
                                                                        .w500,
                                                                    'FontRegular'),
                                                            textInputAction:
                                                                TextInputAction
                                                                    .next,
                                                            focusNode:
                                                                passphraseFocus,
                                                            maxlines: 1,
                                                            text: '',
                                                            hintText: " ",
                                                            obscureText: false,
                                                            suffix: Container(
                                                              width: 0.0,
                                                            ),
                                                            textChanged:
                                                                (value) {},
                                                            onChanged: () {},
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return "Please enter Passphrase";
                                                              }
                                                              return null;
                                                            },
                                                            enabled: true,
                                                            textInputType:
                                                                TextInputType
                                                                    .name,
                                                            controller:
                                                                passphraseController,
                                                          ),
                                                          const SizedBox(
                                                            height: 15.0,
                                                          ),
                                                          Text(
                                                            "Permission",
                                                            style: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    10.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .focusColor
                                                                        .withOpacity(
                                                                            0.6),
                                                                    FontWeight
                                                                        .w400,
                                                                    'FontRegular'),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          const SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          TextFormFieldCustom(
                                                            onEditComplete: () {
                                                              permissionFocus
                                                                  .unfocus();
                                                            },
                                                            radius: 8.0,
                                                            error: " ",
                                                            textColor:
                                                                Theme.of(context)
                                                                    .focusColor,
                                                            borderColor: Theme.of(
                                                                    context)
                                                                .disabledColor
                                                                .withOpacity(0.2),
                                                            fillColor:
                                                                Theme.of(context)
                                                                    .canvasColor,
                                                            hintStyle: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    12.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .dividerColor,
                                                                    FontWeight
                                                                        .w400,
                                                                    'FontRegular'),
                                                            textStyle: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    12.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .focusColor,
                                                                    FontWeight
                                                                        .w500,
                                                                    'FontRegular'),
                                                            textInputAction:
                                                                TextInputAction
                                                                    .next,
                                                            focusNode:
                                                                permissionFocus,
                                                            maxlines: 1,
                                                            text: '',
                                                            hintText: " ",
                                                            obscureText: false,
                                                            suffix: Container(
                                                              width: 0.0,
                                                            ),
                                                            textChanged:
                                                                (value) {},
                                                            onChanged: () {},
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return "Please enter Permission";
                                                              }
                                                              return null;
                                                            },
                                                            enabled: true,
                                                            textInputType:
                                                                TextInputType
                                                                    .name,
                                                            controller:
                                                                permissionController,
                                                          ),
                                                          const SizedBox(
                                                            height: 25.0,
                                                          ),
                                                        ],
                                                      )),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            width: 8.0,
                                                            height: 8.0,
                                                            child: Checkbox(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0)),
                                                              checkColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .focusColor,
                                                              activeColor: Theme
                                                                      .of(context)
                                                                  .disabledColor,
                                                              value: spot,
                                                              onChanged:
                                                                  (bool? value) {
                                                                setState(() {
                                                                  spot = value!;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10.0,
                                                          ),
                                                          Text(
                                                            'Spot',
                                                            style: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    10.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .focusColor,
                                                                    FontWeight
                                                                        .w600,
                                                                    'FontRegular'),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            width: 8.0,
                                                            height: 8.0,
                                                            child: Checkbox(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0)),
                                                              checkColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .focusColor,
                                                              activeColor: Theme
                                                                      .of(context)
                                                                  .disabledColor,
                                                              value: margin,
                                                              onChanged:
                                                                  (bool? value) {
                                                                setState(() {
                                                                  margin = value!;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10.0,
                                                          ),
                                                          Text(
                                                            'Margin',
                                                            style: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    10.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .focusColor,
                                                                    FontWeight
                                                                        .w600,
                                                                    'FontRegular'),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            width: 8.0,
                                                            height: 8.0,
                                                            child: Checkbox(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0)),
                                                              checkColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .focusColor,
                                                              activeColor: Theme
                                                                      .of(context)
                                                                  .disabledColor,
                                                              value: future,
                                                              onChanged:
                                                                  (bool? value) {
                                                                setState(() {
                                                                  future = value!;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10.0,
                                                          ),
                                                          Text(
                                                            'Future',
                                                            style: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    10.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .focusColor,
                                                                    FontWeight
                                                                        .w600,
                                                                    'FontRegular'),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5.0,
                                                  ),
                                                ])
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Add Binance API Key",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          14.0,
                                                          Theme.of(context)
                                                              .focusColor,
                                                          FontWeight.w700,
                                                          'FontRegular'),
                                                  textAlign: TextAlign.start,
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  "1. Log in to your Binance account. Go to Profile --> API Management page and click the Create API button.",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          8.0,
                                                          Theme.of(context)
                                                              .focusColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                  textAlign: TextAlign.start,
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  "2. Select the “System generated API key” option. Enter your API key label and pass the Security verification.",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          8.0,
                                                          Theme.of(context)
                                                              .focusColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                  textAlign: TextAlign.start,
                                                ),
                                                const SizedBox(
                                                  height: 8.0,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 13.0,
                                                      right: 13.0,
                                                      top: 10.0,
                                                      bottom: 10.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    color: Theme.of(context)
                                                        .unselectedWidgetColor
                                                        .withOpacity(0.51),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.info_outline,
                                                        size: 20.0,
                                                        color: Theme.of(context)
                                                            .splashColor,
                                                      ),
                                                      const SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Container(
                                                        height: 30.0,
                                                        width: 1.5,
                                                        color: Theme.of(context)
                                                            .cardColor
                                                            .withOpacity(0.3),
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
                                                            "Be advised",
                                                            style: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    7.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .focusColor,
                                                                    FontWeight
                                                                        .w500,
                                                                    'FontRegular'),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          Text(
                                                            "Do not close or reload the page, otherwise Secret Key will be.",
                                                            style: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    7.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .focusColor,
                                                                    FontWeight
                                                                        .w500,
                                                                    'FontRegular'),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          Text(
                                                            "hidden once and forever.",
                                                            style: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    7.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .focusColor,
                                                                    FontWeight
                                                                        .w500,
                                                                    'FontRegular'),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 8.0,
                                                ),
                                                Text(
                                                  "3. Hit the ‘Edit restriction' button and select the following checkboxes: ",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          8.0,
                                                          Theme.of(context)
                                                              .focusColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                  textAlign: TextAlign.start,
                                                ),
                                                const SizedBox(
                                                  height: 3.0,
                                                ),
                                                Text(
                                                  "For Stop trading: ",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          8.0,
                                                          Theme.of(context)
                                                              .focusColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                  textAlign: TextAlign.start,
                                                ),
                                                const SizedBox(
                                                  height: 3.0,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 3.0,
                                                      height: 3.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10.0),
                                                        color: Theme.of(context)
                                                            .focusColor,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Text(
                                                      "Enable Spot & Margin Trading ",
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomSizedTextStyle(
                                                              8.0,
                                                              Theme.of(context)
                                                                  .focusColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 3.0,
                                                ),
                                                Text(
                                                  "For Spot and Futures trading: ",
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          8.0,
                                                          Theme.of(context)
                                                              .focusColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                  textAlign: TextAlign.start,
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    color: Theme.of(context)
                                                        .unselectedWidgetColor
                                                        .withOpacity(0.51),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.only(
                                                            left: 10.0,
                                                            right: 10.0,
                                                            top: 5.0,
                                                            bottom: 5.0),
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8.0),
                                                          color: Theme.of(context)
                                                              .splashColor,
                                                        ),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "For Spot and Futures trading ? ",
                                                              style: CustomWidget(
                                                                      context:
                                                                          context)
                                                                  .CustomSizedTextStyle(
                                                                      8.0,
                                                                      Theme.of(
                                                                              context)
                                                                          .disabledColor,
                                                                      FontWeight
                                                                          .w500,
                                                                      'FontRegular'),
                                                              textAlign:
                                                                  TextAlign.start,
                                                            ),
                                                            RotationTransition(
                                                                turns:
                                                                    AlwaysStoppedAnimation(
                                                                        -90 /
                                                                            360),
                                                                //it will rotate 20 degree, remove (-) to rotate -20 degree
                                                                child: SvgPicture
                                                                    .asset(
                                                                  "assets/menu/back.svg",
                                                                  height: 11.0,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .disabledColor,
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            left: 10.0,
                                                            right: 10.0,
                                                            bottom: 8.0,
                                                            top: 8.0),
                                                        child: Text(
                                                          "If you do not see the checkbox ‘Enable Futures Trading’, you should open Futures account first. Just go to https://www.binance.com/en/my/wallet/account/futures (will be opened on a new tab) and click the button “Open Now”. ",
                                                          style: CustomWidget(
                                                                  context:
                                                                      context)
                                                              .CustomSizedTextStyle(
                                                                  8.0,
                                                                  Theme.of(
                                                                          context)
                                                                      .focusColor,
                                                                  FontWeight.w500,
                                                                  'FontRegular'),
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        "4. Switch the ‘Restrict access to trusted IPs only’ radio button, return to Coinmatics website tab and click the “Copy IP” button, enter them to the field on Binance and click the “Confirm” button. ",
                                                        style: CustomWidget(
                                                                context: context)
                                                            .CustomSizedTextStyle(
                                                                8.0,
                                                                Theme.of(context)
                                                                    .focusColor,
                                                                FontWeight.w500,
                                                                'FontRegular'),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      flex: 3,
                                                    ),
                                                    const SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Flexible(
                                                      child: InkWell(
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 8.0,
                                                                  bottom: 8.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.0),
                                                            border: Border.all(
                                                              width: 1.0,
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor,
                                                            ),
                                                          ),
                                                          child: Text(
                                                            "Copy ID",
                                                            style: CustomWidget(
                                                                    context:
                                                                        context)
                                                                .CustomSizedTextStyle(
                                                                    7.0,
                                                                    Theme.of(
                                                                            context)
                                                                        .disabledColor,
                                                                    FontWeight
                                                                        .w500,
                                                                    'FontRegular'),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                      ),
                                                      flex: 1,
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 13.0,
                                                      right: 13.0,
                                                      top: 10.0,
                                                      bottom: 10.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    color: Theme.of(context)
                                                        .unselectedWidgetColor
                                                        .withOpacity(0.51),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.info_outline,
                                                        size: 20.0,
                                                        color: Theme.of(context)
                                                            .splashColor,
                                                      ),
                                                      const SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Container(
                                                        height: 30.0,
                                                        width: 1.5,
                                                        color: Theme.of(context)
                                                            .cardColor
                                                            .withOpacity(0.3),
                                                      ),
                                                      const SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          "Pay attention!You should copy and enter the IP-addresses without any changes. If you do change, API Key will not work properly.",
                                                          style: CustomWidget(
                                                                  context:
                                                                      context)
                                                              .CustomSizedTextStyle(
                                                                  7.0,
                                                                  Theme.of(
                                                                          context)
                                                                      .focusColor,
                                                                  FontWeight.w500,
                                                                  'FontRegular'),
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                // const SizedBox(height: 20.0,),
                                              ],
                                            ),
                                    )
                                  : Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Create Account",
                                            style: CustomWidget(context: context)
                                                .CustomSizedTextStyle(
                                                    20.0,
                                                    Theme.of(context).focusColor,
                                                    FontWeight.w700,
                                                    'FontRegular'),
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              text: 'Go to ',
                                              style:
                                                  CustomWidget(context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .focusColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: 'Binance Register page',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight: FontWeight.w500,
                                                      color: Theme.of(context)
                                                          .focusColor,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    )),
                                                TextSpan(
                                                  text: ' and create an account.',
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .focusColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          Text(
                                            "Don’t forget to enable two-factor authentication in the end of registration process. It’s a mandatory requirement for an API key creation.",
                                            style: CustomWidget(context: context)
                                                .CustomSizedTextStyle(
                                                    12.0,
                                                    Theme.of(context).focusColor,
                                                    FontWeight.w500,
                                                    'FontRegular'),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                              const SizedBox(
                                height: 15.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child:  next ? InkWell(
                              onTap: () {
                                setState(() {
                                  if (next == true) {
                                    next = false;
                                    nexttwo = false;
                                  } else {
                                    Navigator.pop(context);
                                  }
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(top: 14.0, bottom: 14.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Theme.of(context).primaryColor,
                                    border: Border.all(
                                      width: 1.0,
                                      color: Theme.of(context).disabledColor,
                                    )),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/menu/back.svg",
                                      height: 15.0,
                                      fit: BoxFit.fitWidth,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      AppLocalizations.instance.text("loc_back"),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context).disabledColor,
                                              FontWeight.w600,
                                              'FontRegular'),
                                      textAlign: TextAlign.start,
                                    )
                                  ],
                                ),
                              ),
                            ) : Container(),
                            flex: 1,
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Flexible(
                            child: InkWell(
                              onTap: () {
                               setState(() {
                                 next = true;
                               });
                                setState(() {
                                  if (next) {
                                    nexttwo = true;
                                   setState(() {
                                     if (nexttwo) {
                                       if (loginformKey.currentState!.validate()) {
                                         loading = true;
                                         subsDetail();
                                       }
                                     } else {
                                       nexttwo = false;
                                       apiKeyController.clear();
                                       secretKeyController.clear();
                                       nameController.clear();
                                       passphraseController.clear();
                                       permissionController.clear();
                                     }
                                   });
                                  } else {
                                    next = false;
                                  }
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(top: 14.0, bottom: 14.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Theme.of(context).disabledColor,
                                ),
                                child: nexttwo
                                    ? Text(
                                        AppLocalizations.instance
                                            .text("loc_add_acc"),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                                12.0,
                                                Theme.of(context).splashColor,
                                                FontWeight.w600,
                                                'FontRegular'),
                                        textAlign: TextAlign.center,
                                      )
                                    : Container(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              AppLocalizations.instance
                                                  .text("loc_next"),
                                              style:
                                                  CustomWidget(context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w600,
                                                          'FontRegular'),
                                              textAlign: TextAlign.start,
                                            ),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            SvgPicture.asset(
                                              "assets/menu/next.svg",
                                              height: 15.0,
                                              fit: BoxFit.fitWidth,
                                              color:
                                                  Theme.of(context).splashColor,
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  subsDetail() {
    apiUtils
        .subsDetails(
            "null",
            nameController.text.toString(),
            apiKeyController.text.toString(),
            widget.title.toString(),
            "null",
            future.toString(),
            margin.toString(),
            passphraseController.text.toString(),
            permissionController.text.toString(),
            secretKeyController.text.toString(),
            spot.toString())
        .then((SubscribeModel loginData) {
      if (loginData.success!) {
        setState(() {
          apiKeyController.clear();
          secretKeyController.clear();
          nameController.clear();
          passphraseController.clear();
          permissionController.clear();
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Subscription", loginData.message.toString(), "success");
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Subscription_Screen()));
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
}
