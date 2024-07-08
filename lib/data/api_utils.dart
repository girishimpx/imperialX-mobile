import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:imperial/data/crypt_model/adress_coin_list_model.dart';
import 'package:imperial/data/crypt_model/adress_coin_list_model.dart';
import 'package:imperial/data/crypt_model/common_model.dart';
import 'package:imperial/data/crypt_model/future_trade_pair_model.dart';
import 'package:imperial/data/crypt_model/kyc_update_model.dart';
import 'package:imperial/data/crypt_model/login_model.dart';
import 'package:imperial/data/crypt_model/market_pair_list_model.dart';
import 'package:imperial/data/crypt_model/trade_his_list_model.dart';
import 'package:imperial/data/crypt_model/trade_pair_model.dart';
import 'package:imperial/data/crypt_model/user_wallet_balance_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'crypt_model/dashboard_image_model.dart';
import 'crypt_model/googleTFA_model.dart';
import 'crypt_model/image_upload_model.dart';
import 'crypt_model/all_wallet_pairs.dart';
import 'crypt_model/allmasters_model.dart';
import 'crypt_model/coin_list_model.dart';
import 'crypt_model/history_model.dart';
import 'crypt_model/my_subscription_model.dart';
import 'crypt_model/notification.dart';
import 'crypt_model/profile_model.dart';
import 'crypt_model/subscribe.dart';
import 'crypt_model/trade_pairs_list_model.dart';
import 'crypt_model/transfer_amount_internal_model.dart';
import 'crypt_model/transfer_history_model.dart';
import 'crypt_model/wallet_address_model.dart';

class APIUtils {
  // static const crypto_baseURL = 'http://139.59.1.77/imperialApi/';
  static const crypto_baseURL = 'https://app.imperialx.exchange/imperialApi/';

  // static const crypto_baseURL = 'http://34.93.139.4/imperialApi/';

  static const String regURL = 'users/register';

  static const String loginURL = 'users/login';
  static const String forgotPasswordURL = 'auth/forgot';
  static const String generateTFAURL = 'auth/generate2fa';
  static const String disableTFAURL = 'auth/disable2fa';
  static const String veifyTFAOTP = 'auth/verify2fa';
  static const String dashBoardImage = 'auth/getDashboardImages';
  static const String KycVerifyUrl = 'users/createKyc';
  static const String KycfrontIDUrl = 'users/imageUpload';
  static const String forgotPasswordVerifyURL = 'auth/reset';
  static const String marketPairURL = 'assets/marketPairs';
  static const String createTicketUrl = '/create-ticket';
  static const String assetListURL = 'assets/getallasset';
  static const String masterListURL = 'users/getMAsters';
  static const String changePassURL = 'profile/changePassword';
  static const String getProfileURL = 'users/get_profile';
  static const String getNotifyURL = 'users/getMynotification';
  static const String marketCoinListURL = 'assets/marketPairs';
  static const String getAllMastersURL = 'users/getMastersbyQuery';
  static const String subscribeDetailsURL = 'trade/createSubscription';
  static const String getTradePairURL = 'assets/getalltradepair';
  static const String getFutureTradePairURL = 'assets/getfuturepairs';
  static const String getTradeHisURL = 'trade/tradeHistory';
  static const String getWalletPairURL = 'bybit/getwallets'; // wallet/getWalletById
  static const String getMySubscibeURL = 'trade/getMysubscription';
  static const String tradePairsWthTypeURL = '/bybit/getnewpairsbytype';
  static const String getHistoryURL = 'trade/tradeHistorypaginate';
  static const String getWalletAddressURL = 'wallet/getWalletaddressById';
  static const String createWalletAddressURL = 'bybit/address';
  static const String resendOTP = 'api/withdraw-resend-otp';
  static const String withdrawURL = 'wallet/withdrawUser';
  static const String createSubAccURL = 'bybit/createsub'; // trade/createsubaccount
  // static const String walletDepAddURL = 'wallet/createDepositeAddress';
  static const String tradeAllPairsURL = 'bybit/orderbook';
  static const String tradeURL = 'bybit/trade'; //trade/userTrade
  static const String masterTradeURL = 'bybit/mastertrade';
  static const String addSubsTradeURL = 'trade/addsubscriber';
  static const String transferHistoryURL = 'users/getInternalTransfer';
  static const String transferAmountURL = 'bybit/createInternalTransfer';
  static const String transferTradingURL = 'wallet/getSubAccBal';
  static const String walletByAssetIdURL = 'wallet/getWalletByAssetId';
  static const String userToMasterURL = 'users/mademasterRequest';

  Future<CommonModel> doVerifyRegister(
    String first_name,
    String email,
    String password,
    String ref_code,
  ) async {
    var emailbodyData = {
      'name': first_name,
      'email': email,
      'password': password,
      'referred_by_code': ref_code,
      'signup_type': "gmail"
    };

    final response = await http.post(Uri.parse(crypto_baseURL + regURL),
        body: emailbodyData);

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<LoginDetailsModel> doGoogleRegister(
    String first_name,
    String email,
  ) async {
    var emailbodyData = {
      'name': first_name,
      'email': email,
      'signup_type': "google"
    };

    final response = await http.post(Uri.parse(crypto_baseURL + regURL),
        body: emailbodyData);

    return LoginDetailsModel.fromJson(json.decode(response.body));
  }

  Future<LoginDetailsModel> doLoginEmail(String email, String pass) async {
    var emailbodyData = {
      'email': email,
      'password': pass,
    };
    final response = await http.post(Uri.parse(crypto_baseURL + loginURL),
        body: emailbodyData);

  print(response.body );
    return LoginDetailsModel.fromJson(json.decode(response.body));
  }

  Future<GoogleAuthCodeModel> enableTwoFA() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.post(Uri.parse(crypto_baseURL + generateTFAURL),
        headers: {
          "Authorization": "Bearer " + preferences.getString("token").toString()
        });
print(response.body);
    return GoogleAuthCodeModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> disableTwoFA() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.post(Uri.parse(crypto_baseURL + disableTFAURL),
        headers: {
          "Authorization": "Bearer " + preferences.getString("token").toString()
        });
    print(response.body);
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<DashImageModel> getDashImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.post(Uri.parse(crypto_baseURL + dashBoardImage),
        headers: {
          "Authorization": "Bearer " + preferences.getString("token").toString()
        });
    print(response.body);
    return DashImageModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> doCreateTicket(
      String subject,
      String message,
      ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "subject": subject,
      "message": message,
    };

    final response = await http.post(
        Uri.parse(
          crypto_baseURL + createTicketUrl,
        ),
        body: bankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> veifyEmailOTP( String Code) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bodyData = {
      'secret': Code,
    };
    final response = await http.post(Uri.parse(crypto_baseURL + veifyTFAOTP),
        body: bodyData,
        headers: {
          "Authorization": "Bearer " + preferences.getString("token").toString()
        });

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> updateKYCDetails(
      String fname,
      String lastname,
      String phoneno,
      String gender,
      String dob,
      String country,
      String state,
      String city,
      String zipcode,
      String telegramUser,
      String accNo,
      String ifscCode,
      String bankName,
      String address,
      String idproof,
      String idnumber,
      String image,
      String expdate,
      ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bodyData = {
      'first_name': fname,
      'last_name': lastname,
      'phone_no': phoneno,
      'gender': gender,
      'dob': dob,
      'country': country,
      'state': state,
      'city': city,
      'zipcode': zipcode,
      'telegram': telegramUser,
      'account_no': accNo,
      'ifsc_code': ifscCode,
      'bank_name': bankName,
      'address': address,
      'document_type': idproof,
      'document_num': idnumber,
      'document_image': image,
      'expiry_date': expdate,
    };
    final response = await http.post(Uri.parse(crypto_baseURL + KycVerifyUrl),
        body: bodyData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<ImageUploadingModel> updateKycFrontUpload(String image,) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var request = http.MultipartRequest(
        "POST", Uri.parse(crypto_baseURL + KycfrontIDUrl));
    request.headers['authorization'] =
        "Bearer " + preferences.getString("token").toString();
    request.headers['Accept'] = 'application/json';

    var pic = await http.MultipartFile.fromPath("image", image);

    request.files.add(pic);
    http.Response response = await http.Response.fromStream(await request.send());
print(response.body);
    return ImageUploadingModel.fromJson(json.decode(response.body.toString()));
  }

  Future<CommonModel> forgotPassword(String email) async {
    var emailbodyData = {
      'email': email,
    };

    final response = await http.post(
        Uri.parse(crypto_baseURL + forgotPasswordURL),
        body: emailbodyData);

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> doVerifyOTP(
    String email,
    String otp,
    String password,
  ) async {
    var emailbodyData = {
      'email': email,
      "otp": otp,
      "new_password": password,
    };

    final response = await http.post(
        Uri.parse(crypto_baseURL + forgotPasswordVerifyURL),
        body: emailbodyData);

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> doChangePassword(
      String cpassword, String npassword) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var emailbodyData = {
      'oldPassword': cpassword,
      "newPassword": npassword,
    };

    final response = await http.post(Uri.parse(crypto_baseURL + changePassURL),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        },
        body: emailbodyData);

    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<MarketPairListModel> getMarketPairlist() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.post(Uri.parse(crypto_baseURL + marketPairURL),
        headers: {
          "Authorization": "Bearer " + preferences.getString("token").toString()
        });
    return MarketPairListModel.fromJson(json.decode(response.body));
  }

  Future<MarketPairListModel> getAssetslist() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.get(Uri.parse(crypto_baseURL + assetListURL),
        headers: {
          "Authorization": "Bearer " + preferences.getString("token").toString()
        });

    return MarketPairListModel.fromJson(json.decode(response.body));
  }

  Future<MarketPairListModel> getMasterlist() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.get(Uri.parse(crypto_baseURL + masterListURL),
        headers: {
          "Authorization": "Bearer " + preferences.getString("token").toString()
        });

    return MarketPairListModel.fromJson(json.decode(response.body));
  }

  Future<GetProfileModel> getProfileDetils() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.get(Uri.parse(crypto_baseURL + getProfileURL),
        headers: {
          "Authorization": "Bearer " + preferences.getString("token").toString()
        });
    return GetProfileModel.fromJson(json.decode(response.body));
  }

  Future<GetNotificationModel> getNotiDetils() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.get(Uri.parse(crypto_baseURL + getNotifyURL),
        headers: {
          "Authorization": "Bearer " + preferences.getString("token").toString()
        });
    return GetNotificationModel.fromJson(json.decode(response.body));
  }

  Future<CoinListModel> allCoinList(String type) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var emailbodyData = {
      'type': type,
    };
    print(emailbodyData);
    final response = await http.post(
        Uri.parse(crypto_baseURL + marketCoinListURL),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        },
        body: emailbodyData);
    print("TEtstMano");
    print(response.body);
    return CoinListModel.fromJson(json.decode(response.body));
  }

  Future<GetAllMastersModel> getAllMasters() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http
        .post(Uri.parse(crypto_baseURL + getAllMastersURL), headers: {
      "Authorization": "Bearer " + preferences.getString("token").toString()
    });

    return GetAllMastersModel.fromJson(json.decode(response.body));
  }

  Future<SubscribeModel> subsDetails(
    String amount,
    String api_name,
    String apikey,
    String exchange,
    String follower_user_id,
    String future,
    String margin,
    String passphrase,
    String permission,
    String secretkey,
    String spot,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var emailbodyData = {
      'amount': amount,
      'api_name': api_name,
      'apikey': apikey,
      'exchange': exchange,
      'follower_user_id': follower_user_id,
      'future': future,
      'margin': margin,
      'passphrase': passphrase,
      'permission': permission,
      'secretkey': secretkey,
      'spot': spot,
    };
    final response = await http.post(
        Uri.parse(crypto_baseURL + subscribeDetailsURL),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        },
        body: emailbodyData);
    return SubscribeModel.fromJson(json.decode(response.body));
  }

  Future<TradePairListModel> getTradePairList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse(crypto_baseURL + getTradePairURL),
      headers: {
        "authorization": "Bearer " + preferences.getString("token").toString()
      },
    );
    print(response.body);
    return TradePairListModel.fromJson(json.decode(response.body));
  }

  Future<FutureTradePairListModel> getFutureTradePairList(String type) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var emailbodyData = {
      'type': type,
    };
    final response = await http.post(
      Uri.parse(crypto_baseURL + tradeAllPairsURL),
      body: emailbodyData,
      headers: {
        "authorization": "Bearer " + preferences.getString("token").toString()
      },
    );
    print("FUTURES");
    print(response.body);
    return FutureTradePairListModel.fromJson(json.decode(response.body));
  }

  Future<TradeHistoryListModel> getTradehistory(String pair) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var emailbodyData = {
      'pair': pair,
    };
    final response = await http.post(
      Uri.parse(crypto_baseURL + getTradeHisURL),
      body: emailbodyData,
      headers: {
        "authorization": "Bearer " + preferences.getString("token").toString()
      },
    );

    return TradeHistoryListModel.fromJson(json.decode(response.body));
  }

  Future<GetWalletAllPairsModel> getWalletList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse(crypto_baseURL + getWalletPairURL),
      headers: {
        "authorization": "Bearer " + preferences.getString("token").toString()
      },
    );
    return GetWalletAllPairsModel.fromJson(json.decode(response.body));
  }


  Future<SubscriptionDetailsModel> getMySubsDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse(crypto_baseURL + getMySubscibeURL),
      headers: {
        "authorization": "Bearer " + preferences.getString("token").toString()
      },
    );
    return SubscriptionDetailsModel.fromJson(json.decode(response.body));
  }

  Future<AllHistoryModel> getHistory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse(crypto_baseURL + getHistoryURL),
      headers: {
        "authorization": "Bearer " + preferences.getString("token").toString()
      },
    );
    return AllHistoryModel.fromJson(json.decode(response.body));
  }

  Future<UserWalletBalanceModel> walletBalanceInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http
        .post(Uri.parse(crypto_baseURL + getWalletAddressURL), headers: {
      "authorization": "Bearer " + preferences.getString("token").toString()
    });
    print(response.body);
    return UserWalletBalanceModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> resendWithdrawOTP(String atx_id,) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "atx_id": atx_id,
    };

    final response = await http.post(Uri.parse(crypto_baseURL + resendOTP,),
        body: bankData,
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        });
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<GetAddressListCoinModel> walletAddressDetails(String symbol,) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "ccy": symbol,
    };
    final response = await http.post(Uri.parse(crypto_baseURL + getWalletAddressURL),
        body: bankData,
        headers: {"authorization": "Bearer " + preferences.getString("token").toString()});
    return GetAddressListCoinModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> walletAddressInfo(String symple, String name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "chain": symple,
      "coinname": name,
    };
    final response = await http.post(Uri.parse(crypto_baseURL + createWalletAddressURL),
        body: bankData,
        headers: {"authorization": "Bearer " + preferences.getString("token").toString()});
    return CommonModel.fromJson(json.decode(response.body));
  }


  Future<CommonModel> aithdrawWallet(String amount, String fee, String dest, String currency, String chain, String address) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "Amount": amount,
      "Fee": fee,
      "Dest": dest,
      "Currency": currency,
      "Chain": chain,
      "Address": address,
    };
    final response = await http.post(Uri.parse(crypto_baseURL + withdrawURL),
        body: bankData,
        headers: {"authorization": "Bearer " + preferences.getString("token").toString()});
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> createSubAccountInfo( String name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "name": name,
    };
  print(bankData);
    final response = await http.post(Uri.parse(crypto_baseURL + createSubAccURL),
        body: bankData,
        headers: {"authorization": "Bearer " + preferences.getString("token").toString()});
    return CommonModel.fromJson(json.decode(response.body));
  }

  // Future<CommonModel> walletDepoAdd() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //
  //   final response = await http.post(Uri.parse(crypto_baseURL + walletDepAddURL),
  //       headers: {"authorization": "Bearer " + preferences.getString("token").toString()});
  //   return CommonModel.fromJson(json.decode(response.body));
  // }

  Future<CommonModel> tradeInfo(String instId, String tdMode, String ccy, String lever, String side, String orderType, String px, String sz, String trade_at, bool tpslType, String tpPice, String slPrice) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "instId": instId,
      "tdMode": tdMode,
      "ccy": ccy,
      "tag": "mk1",
      "lever": lever,
      "side": side,
      "orderType": orderType.toLowerCase(),
      "px": px,
      "sz": sz,
      "trade_at": trade_at,
      "istpsl": tpslType,
    };
    var TradeData = {
      "instId": instId,
      "tdMode": tdMode,
      "ccy": ccy,
      "tag": "mk1",
      "lever": lever,
      "side": side,
      "orderType": orderType.toLowerCase(),
      "px": px,
      "sz": sz,
      "trade_at": trade_at,
      "istpsl": tpslType,
      "tpPrice": tpPice,
      "slPrice": slPrice,
    };
    final response = await http.post(Uri.parse(crypto_baseURL + tradeURL),
        body: tpslType? TradeData : bankData,
        headers: {"authorization": "Bearer " + preferences.getString("token").toString()});
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> masterTradeInfo(String instId, String tdMode, String ccy, String lever, String side, String orderType, String px, String sz, String trade_at, bool tpslType, String tpPice, String slPrice) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "instId": instId,
      "tdMode": tdMode,
      "ccy": ccy,
      "tag": "mk1",
      "lever": lever,
      "side": side,
      "orderType": orderType.toLowerCase(),
      "px": px,
      "sz": sz,
      "trade_at": trade_at,
      "istpsl": tpslType,
    };
    var TradeData = {
      "instId": instId,
      "tdMode": tdMode,
      "ccy": ccy,
      "tag": "mk1",
      "lever": lever,
      "side": side,
      "orderType": orderType.toLowerCase(),
      "px": px,
      "sz": sz,
      "trade_at": trade_at,
      "istpsl": tpslType,
      "tpPrice": tpPice,
      "slPrice": slPrice,
    };
    final response = await http.post(Uri.parse(crypto_baseURL + masterTradeURL),
        body: tpslType? TradeData : bankData,
        headers: {"authorization": "Bearer " + preferences.getString("token").toString()});
    return CommonModel.fromJson(json.decode(response.body));
  }


  Future<CommonModel> addSubscriberInfo(String Follower_id, String Amount,) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "follower_id": Follower_id,
      "amount": Amount,
    };
    final response = await http.post(Uri.parse(crypto_baseURL + addSubsTradeURL),
        body: bankData,
        headers: {"authorization": "Bearer " + preferences.getString("token").toString()});
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<InternalTransferModel> transferList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.get(Uri.parse(crypto_baseURL + transferHistoryURL),
        headers: {"authorization": "Bearer " + preferences.getString("token").toString()});
    return InternalTransferModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> transferAmount(String Currency, String Amount, String from, String to) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "coin": Currency,
      "amount": Amount,
      "fromAccountType": from,
      "toAccountType": to,
    };

    print(bankData);
    final response = await http.post(Uri.parse(crypto_baseURL + transferAmountURL),
        body: bankData,
        headers: {"authorization": "Bearer " + preferences.getString("token").toString()});
    print(response.body);
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<UserWalletBalanceModel> walletAddressByID(String AssetId,) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "asset_id": AssetId,
    };
    final response = await http.post(Uri.parse(crypto_baseURL + walletByAssetIdURL),
        body: bankData,
        headers: {"authorization": "Bearer " + preferences.getString("token").toString()});
    return UserWalletBalanceModel.fromJson(json.decode(response.body));
  }

  Future<AmountTransferInternalModel> transferTypeBalance(String AccountType, String CoinName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "accountType": AccountType,
      "coin": CoinName,
    };
    final response = await http.post(Uri.parse(crypto_baseURL + transferTradingURL ),
        body: bankData,
        headers: {"authorization": "Bearer " + preferences.getString("token").toString()});
    return AmountTransferInternalModel.fromJson(json.decode(response.body));
  }

  Future<TradePairsSpotModel> spotAllPairs(String orderType,) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "type": orderType,
    };
    final response = await http.post(Uri.parse(crypto_baseURL + tradeAllPairsURL),
        body: bankData,
        headers: {"authorization": "Bearer " + preferences.getString("token").toString()});
    return TradePairsSpotModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> createUserToMaster() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.get(Uri.parse(crypto_baseURL + userToMasterURL),
        headers: {"authorization": "Bearer " + preferences.getString("token").toString()});
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> pairListWithType(String selectCoin, String orderType) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "category": selectCoin,
      "type": orderType,
    };
    final response = await http.post(Uri.parse(crypto_baseURL + tradePairsWthTypeURL),
        body: bankData,
        headers: {"authorization": "Bearer " + preferences.getString("token").toString()});
    return CommonModel.fromJson(json.decode(response.body));
  }

}
