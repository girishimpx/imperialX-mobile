import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:imperial/data/crypt_model/common_model.dart';
import 'package:imperial/data/crypt_model/future_trade_pair_model.dart';
import 'package:imperial/data/crypt_model/login_model.dart';
import 'package:imperial/data/crypt_model/market_pair_list_model.dart';
import 'package:imperial/data/crypt_model/trade_his_list_model.dart';
import 'package:imperial/data/crypt_model/trade_pair_model.dart';
import 'package:imperial/data/crypt_model/user_wallet_balance_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'crypt_model/all_wallet_pairs.dart';
import 'crypt_model/allmasters_model.dart';
import 'crypt_model/coin_list_model.dart';
import 'crypt_model/history_model.dart';
import 'crypt_model/my_subscription_model.dart';
import 'crypt_model/notification.dart';
import 'crypt_model/profile_model.dart';
import 'crypt_model/subscribe.dart';
import 'crypt_model/transfer_history_model.dart';
import 'crypt_model/wallet_address_model.dart';

class APIUtils {
  // static const crypto_baseURL = 'http://139.59.1.77/imperialApi/';
  static const crypto_baseURL = 'https://app.imperialx.exchange/imperialApi/';

  // static const crypto_baseURL = 'http://34.93.139.4/imperialApi/';

  static const String regURL = 'users/register';

  static const String loginURL = 'users/login';
  static const String forgotPasswordURL = 'auth/forgot';
  static const String forgotPasswordVerifyURL = 'auth/reset';
  static const String marketPairURL = 'assets/marketPairs';
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
  static const String getWalletPairURL = 'wallet/getWalletById';
  static const String getMySubscibeURL = 'trade/getMysubscription';
  static const String getHistoryURL = 'trade/tradeHistorypaginate';
  static const String getWalletAddressURL = 'wallet/getWalletaddressById';
  static const String resendOTP = 'api/withdraw-resend-otp';
  static const String withdrawURL = 'wallet/withdrawUser';
  static const String createSubAccURL = 'trade/createsubaccount';
  static const String walletDepAddURL = 'wallet/createDepositeAddress';
  static const String tradeURL = 'trade/userTrade';
  static const String addSubsTradeURL = 'trade/addsubscriber';
  static const String transferHistoryURL = 'users/getInternalTransfer';
  static const String transferAmountURL = 'users/transferFunds';
  static const String walletByAssetIdURL = 'wallet/getWalletByAssetId';

  Future<CommonModel> doVerifyRegister(
    String first_name,
    String email,
    String password,
  ) async {
    var emailbodyData = {
      'name': first_name,
      'email': email,
      'password': password,
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
    final response = await http.post(
        Uri.parse(crypto_baseURL + marketCoinListURL),
        headers: {
          "authorization": "Bearer " + preferences.getString("token").toString()
        },
        body: emailbodyData);

    print(response.body);
    return CoinListModel.fromJson(json.decode(response.body));
  }

  Future<GetAllMastersModel> getAllMasters() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http
        .post(Uri.parse(crypto_baseURL + getAllMastersURL), headers: {
      "Authorization": "Bearer " + preferences.getString("token").toString()
    });

    print(response.body);
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
    return TradePairListModel.fromJson(json.decode(response.body));
  }

  Future<FutureTradePairListModel> getFutureTradePairList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(crypto_baseURL + getFutureTradePairURL),
      headers: {
        "authorization": "Bearer " + preferences.getString("token").toString()
      },
    );
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

  Future<WalletAddressModel> walletAddressInfo(String coin) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "ccy": coin,
    };
    final response = await http.post(Uri.parse(crypto_baseURL + getWalletAddressURL),
        body: bankData,
        headers: {"authorization": "Bearer " + preferences.getString("token").toString()});
    return WalletAddressModel.fromJson(json.decode(response.body));
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

  Future<CommonModel> createSubAccountInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.post(Uri.parse(crypto_baseURL + createSubAccURL),
        headers: {"authorization": "Bearer " + preferences.getString("token").toString()});
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> walletDepoAdd() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await http.post(Uri.parse(crypto_baseURL + walletDepAddURL),
        headers: {"authorization": "Bearer " + preferences.getString("token").toString()});
    return CommonModel.fromJson(json.decode(response.body));
  }

  Future<CommonModel> tradeInfo(String instId, String tdMode, String ccy, String lever, String side, String orderType, String px, String sz, String trade_at) async {
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
    };
    print(bankData);
    final response = await http.post(Uri.parse(crypto_baseURL + tradeURL),
        body: bankData,
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

  Future<CommonModel> transferAmount(String Amount, String Currency, String from, String to) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var bankData = {
      "Amount": Amount,
      "Currency": Currency,
      "from": from,
      "to": to,
    };

    final response = await http.post(Uri.parse(crypto_baseURL + transferAmountURL),
        body: bankData,
        headers: {"authorization": "Bearer " + preferences.getString("token").toString()});
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

}
