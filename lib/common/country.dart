import 'dart:convert';


import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:imperial/common/theme/custom_theme.dart';



import './country.dart';
import 'custom_widget.dart';

///This function returns list of countries
Future<List<Country>> getCountriesList(BuildContext context) async {
  String rawData = await DefaultAssetBundle.of(context).loadString(
      'packages/country_calling_code_picker/raw/country_codes.json');
  final parsed = json.decode(rawData.toString()).cast<Map<String, dynamic>>();
  return parsed.map<Country>((json) => new Country.fromJson(json)).toList();
}

///This function returns an user's current country. User's sim country code is matched with the ones in the list.
///If there is no sim in the device, first country in the list will be returned.
Future<Country> getDefaultCountryList(BuildContext context) async {
  final list = await getCountriesList(context);
  var currentCountry;
  try {
    final countryCode = await FlutterSimCountryCode.simCountryCode;
    currentCountry =
        list.firstWhere((element) => element.countryCode == countryCode);
  } catch (e) {
    currentCountry = list.first;
  }
  return currentCountry;
}

///This function returns an country whose [countryCode] matches with the passed one.
Future<Country?> getCountryByCountryCode(
    BuildContext context, String countryCode) async {
  final list = await getCountriesList(context);
  return list.firstWhere((element) => element.countryCode == countryCode);
}

Future<Country?> showCountryPickerSheets(BuildContext context,
    {Widget? title,
    Widget? cancelWidget,
    double cornerRadius= 35,
    bool focusSearchBox= false,
    double heightFactor= 0.9}) {
  assert(heightFactor <= 0.9 && heightFactor >= 0.4,
      'heightFactor must be between 0.4 and 0.9');
  return showModalBottomSheet<Country?>(
      context: context,
      isScrollControlled: true,
      backgroundColor:  CustomTheme.of(context).dividerColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(cornerRadius),
              topRight: Radius.circular(cornerRadius))),
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * heightFactor,
          child: Column(
            children: <Widget>[
              SizedBox(height: 16),
              Stack(
                children: <Widget>[
                  cancelWidget ??
                      Positioned(
                        right: 8,
                        top: 4,
                        bottom: 10,
                        child: TextButton(
                            child: Text(
                              'Cancel',style: TextStyle(color: Colors.white),

                            ),
                            onPressed: () => Navigator.pop(context)),
                      ),
                  Center(
                    child: title ??
                        Text(
                          'Choose Country',
                          textAlign: TextAlign.center,
                          style: CustomWidget(context: context).CustomTextStyle( CustomTheme.of(context).primaryColor,FontWeight.w500, 'FontRegular'),
                        ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: CountryPickerWidget(
                  onSelected: (country) => Navigator.of(context).pop(country),
                ),
              ),
            ],
          ),
        );
      });
}

Future<Country?> showCountryPickerDialogs(
  BuildContext context, {
  Widget? title,
  double cornerRadius = 35,
  bool focusSearchBox= false,
}) {
  return showDialog<Country?>(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(cornerRadius),
            )),
            child: Column(
              children: <Widget>[
                SizedBox(height: 16),
                Stack(
                  children: <Widget>[
                    Positioned(
                      right: 8,
                      top: 4,
                      bottom: 0,
                      child: TextButton(
                          child: Text('Cancel'),
                          onPressed: () => Navigator.pop(context)),
                    ),
                    Center(
                      child: title ??
                          Text(
                            'Choose region',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Expanded(
                  child: CountryPickerWidget(
                    onSelected: (country) => Navigator.of(context).pop(country),
                  ),
                ),
              ],
            ),
          ));
}
