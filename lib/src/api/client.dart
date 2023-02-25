import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;

import '../controller/auth_controller.dart';
import '../model/company.dart';
import '../model/marketplace.dart';
import '../model/menu_section.dart';
import '../model/order.dart';
import '../model/node.dart';
import '../model/order_entry.dart';
import '../model/stage_achievement.dart';
import '../model/transaction.dart';
import '../model/transaction_entry.dart';

final AuthController controller = getx.Get.put(AuthController());
const apiBaseUrl = String.fromEnvironment('apiBaseUrl',
    defaultValue: 'http://localhost:8000');

class GenericResponse {
  late int statusCode;

  GenericResponse(this.statusCode);

  GenericResponse.fromResponse(Response response) {
    statusCode = response.statusCode!;
  }
}

class TokenRefreshResponse extends GenericResponse {
  late final String? refreshedAccessToken;

  TokenRefreshResponse(statusCode, this.refreshedAccessToken)
      : super(statusCode);

  TokenRefreshResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode! == 200) {
      refreshedAccessToken = response.data['access'];
    }
  }
}

class LoginResponse extends GenericResponse {
  String? accessToken;
  String? refreshToken;

  LoginResponse(statusCode, this.accessToken, this.refreshToken)
      : super(statusCode);

  LoginResponse.fromResponse(Response response) : super.fromResponse(response) {
    accessToken = response.data['access'];
    refreshToken = response.data['refresh'];
  }
}

class RegisterResponse extends GenericResponse {
  late HashMap<String, String> validationErrors;

  RegisterResponse(statusCode, this.validationErrors) : super(statusCode);

  RegisterResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode! >= 400) {
      validationErrors = HashMap.from(response.data
          .map((key, value) => MapEntry(key.toString(), value?.toString())));
    }
  }
}

class PasswordResetResponse extends GenericResponse {
  final String? validationError;

  PasswordResetResponse(statusCode, this.validationError) : super(statusCode);
}

class ConfirmEmailResponse extends GenericResponse {
  late final String? validationError;

  ConfirmEmailResponse(statusCode, this.validationError) : super(statusCode);

  ConfirmEmailResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode! >= 400) {
      validationError = "Invalid Pin";
    }
  }
}

class OtpStatusResponse extends GenericResponse {
  late final bool isOtpEnabled;

  OtpStatusResponse(statusCode, this.isOtpEnabled) : super(statusCode);

  OtpStatusResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    isOtpEnabled = response.data['result'];
  }
}

class ConfirmPhoneNumberResponse extends GenericResponse {
  late final String? validationError;

  ConfirmPhoneNumberResponse(statusCode, this.validationError)
      : super(statusCode);

  ConfirmPhoneNumberResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode! >= 400) {
      validationError = "Invalid Pin";
    }
  }
}

class UpdatePasswordResponse extends GenericResponse {
  late final String? validationError;

  UpdatePasswordResponse(statusCode, this.validationError) : super(statusCode);

  UpdatePasswordResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode! >= 400) {
      validationError = "Invalid password";
    }
  }
}

class UserDataResponse extends GenericResponse {
  late String id;
  late String firstName;
  late String lastName;
  late String? email;
  late bool? isEmailConfirmed;
  late String? emailCandidate;
  late String? phoneNumber;
  late bool? isPhoneNumberConfirmed;
  late String? phoneNumberCandidate;
  late bool? isMFAEnabled;
  String? validationError;

  UserDataResponse(
      statusCode,
      this.id,
      this.email,
      this.isEmailConfirmed,
      this.phoneNumber,
      this.emailCandidate,
      this.isMFAEnabled,
      this.isPhoneNumberConfirmed,
      this.phoneNumberCandidate,
      this.validationError,
      this.firstName,
      this.lastName)
      : super(statusCode);

  UserDataResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode! < 300) {
      id = response.data["id"];
      email = response.data['email'];
      isEmailConfirmed = response.data['is_email_confirmed'];
      emailCandidate = response.data['email_candidate'];
      phoneNumber = response.data['phone_number'];
      isPhoneNumberConfirmed = response.data['is_phone_number_confirmed'];
      phoneNumberCandidate = response.data['phone_number_candidate'];
      isMFAEnabled = response.data['is_mfa_enabled'];
    } else {
      validationError = response.toString();
    }
  }
}

class MarketplacesListResponse extends GenericResponse {
  List<Marketplace> marketplaces = [];

  MarketplacesListResponse(statusCode, this.marketplaces) : super(statusCode);

  MarketplacesListResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    List<Marketplace> marketplaces = [];
    if (response.statusCode == 200) {
      response.data
          .forEach((entry) => marketplaces.add(Marketplace.fromJson(entry)));
    }
    this.marketplaces = marketplaces;
  }
}

class NodesListResponse extends GenericResponse {
  List<Node> nodes = [];

  NodesListResponse(statusCode, this.nodes) : super(statusCode);

  NodesListResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    List<Node> nodes = [];
    if (response.statusCode == 200) {
      response.data.forEach((entry) => nodes.add(Node.fromJson(entry)));
    }
    this.nodes = nodes;
  }
}
class OrdersListResponse extends GenericResponse {
  List<Order> orders = [];

  OrdersListResponse(statusCode, this.orders) : super(statusCode);

  OrdersListResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    List<Order> orders = [];
    if (response.statusCode == 200) {
      response.data.forEach((order) => orders.add(Order.fromJson(order)));
    }
    this.orders = orders;
  }
}

class OrderCreateResponse extends GenericResponse {
  Order? order;
  Map<String, dynamic>? validationError;

  OrderCreateResponse(statusCode, this.order, this.validationError)
      : super(statusCode);

  OrderCreateResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode == 201) {
      order = Order.fromJson(response.data);
    } else {
      validationError = response.data;
    }
  }
}

class MFASwitchResponse extends GenericResponse {
  late final String? validationError;
  late final String? mfaUrl;
  late final String? secretKey;

  MFASwitchResponse(statusCode, this.validationError) : super(statusCode);

  MFASwitchResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode! >= 400) {
      validationError = "some error";
    }
    mfaUrl = response.data['mfa_url'];
    secretKey = response.data['mfa_secret_key'];
  }
}

class CompanyResponse extends GenericResponse {
  Company? company;

  CompanyResponse(statusCode, this.company) : super(statusCode);

  CompanyResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode == 200) {
      company = Company.fromJson(response.data);
    }
  }
}

class StageAchievementsResponse extends GenericResponse {
  List<StageAchievement>? stageAchievements;
  Map<String, dynamic>? validationError;

  StageAchievementsResponse(
      statusCode, this.stageAchievements, this.validationError)
      : super(statusCode);

  StageAchievementsResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode == 200) {
      stageAchievements = (response.data as List<dynamic>)
          .map((offer) => StageAchievement.fromJson(offer))
          .toList();
    } else {
      validationError = response.data;
    }
  }
}

class TransactionsResponse extends GenericResponse {
  List<Transaction>? transactions;
  String? validationError;

  TransactionsResponse(statusCode, this.transactions, this.validationError)
      : super(statusCode);

  TransactionsResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode == 200) {
      transactions = (response.data as List<dynamic>)
          .map((offer) => Transaction.fromJson(offer))
          .toList();
    } else {
      validationError = response.data.toString();
    }
  }
}

class TransactionCreateResponse extends GenericResponse {
  Transaction? transaction;
  Map<String, dynamic>? validationError;

  TransactionCreateResponse(statusCode, this.transaction, this.validationError)
      : super(statusCode);

  TransactionCreateResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode == 201) {
      transaction = Transaction.fromJson(response.data);
    } else {
      validationError = response.data;
    }
  }
}

class MenuSectionResponse extends GenericResponse {
  MenuSection? menuSection;
  String? validationError;

  MenuSectionResponse(statusCode, this.menuSection, this.validationError)
      : super(statusCode);

  MenuSectionResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode == 200) {
      menuSection = MenuSection.fromJson(response.data);
    } else {
      validationError = response.data.values[0];
    }
  }
}

class MarketplaceResponse extends GenericResponse {
  Marketplace? marketplace;
  String? validationError;

  MarketplaceResponse(statusCode, this.marketplace, this.validationError)
      : super(statusCode);

  MarketplaceResponse.fromResponse(Response response)
      : super.fromResponse(response) {
    if (response.statusCode == 200) {
      marketplace = Marketplace.fromJson(response.data);
    } else {
      validationError = response.data.values[0];
    }
  }
}

class APIClient {
  // final Dio _dio = Dio()..interceptors.add(LogInterceptor(responseBody: true));
  // final Dio _dio = Dio()..interceptors.add(HttpFormatter());
  final Dio _dio = Dio();

  Future<TokenRefreshResponse> refreshAccessToken(String refreshToken) async {
    return TokenRefreshResponse.fromResponse(await _dio.post(
        "$apiBaseUrl/moses/token/refresh/",
        data: {'refresh': refreshToken},
        options: Options(validateStatus: (status) => status! < 500)));
  }

  Future<LoginResponse> authenticate(
      String phoneNumber, String password, String otp) async {
    Response response = await _dio.post(
      "$apiBaseUrl/moses/token/obtain/",
      data: {'phone_number': phoneNumber, 'password': password, 'otp': otp},
      options: Options(validateStatus: (status) => status! < 500),
    );
    return LoginResponse.fromResponse(response);
  }

  Future<OtpStatusResponse> checkOtpStatus(String phoneNumber) async {
    phoneNumber = Uri.encodeQueryComponent(phoneNumber);
    Response response = await _dio.get(
        "$apiBaseUrl/moses/is_mfa_enabled_for_phone_number/?phone_number=$phoneNumber",
        options: Options(validateStatus: (status) => status! < 500));
    return OtpStatusResponse.fromResponse(response);
  }

  Future<RegisterResponse> register(
    String firstName,
    String lastName,
    String phoneNumber,
    String email,
    String password,
  ) async {
    Response response = await _dio.post(
      "$apiBaseUrl/moses/users/",
      data: {
        'phone_number': phoneNumber,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'email': email
      },
      options: Options(validateStatus: (status) => status! < 500),
    );
    return RegisterResponse.fromResponse(response);
  }

  Future<PasswordResetResponse> resetPassword(
      String? phoneNumber, String? email) async {
    Response response = await _dio.post(
      "$apiBaseUrl/moses/password/reset/",
      data: email == null ? {'phone_number': phoneNumber} : {'email': email},
      options: Options(validateStatus: (status) => status! < 500),
    );
    return PasswordResetResponse(
        response.statusCode, response.data?["error"] ?? "");
  }

  Future<PasswordResetResponse> confirmPasswordReset(
      String uid, String token, String password) async {
    Response response = await _dio.post(
      "$apiBaseUrl/moses/users/reset_password_confirm/",
      data: {'uid': uid, 'token': token, 'new_password': password},
      options: Options(validateStatus: (status) => status! < 500),
    );
    return PasswordResetResponse(
        response.statusCode, response.data ?? response.data["error"] ?? "");
  }

  Future<UserDataResponse> getAuthenticatedUserData(String accessToken) async {
    return UserDataResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/moses/users/me/",
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  }

  Future<UserDataResponse?> getProfileByPhoneOrEmail(
      String accessToken, String value) async {
    return UserDataResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/moses/get_by_phone_or_email/?value=${Uri.encodeComponent(value)}",
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  }

  Future<UserDataResponse?> updateProfile(
      String accessToken, String phoneNumber, String email) async {
    return UserDataResponse.fromResponse(await _dio.patch(
      "$apiBaseUrl/moses/users/me/",
      data: {"phone_number": phoneNumber, "email": email},
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  }

  Future<ConfirmEmailResponse?> confirmEmail(
      String accessToken, String emailPin, String emailCandidatePin) async {
    return ConfirmEmailResponse.fromResponse(await _dio.post(
      "$apiBaseUrl/moses/confirm_email/",
      data: {"pin": emailPin, "candidate_pin": emailCandidatePin},
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  }

  Future<ConfirmPhoneNumberResponse?> confirmPhoneNumber(
      String accessToken, String emailPin, String emailCandidatePin) async {
    return ConfirmPhoneNumberResponse.fromResponse(await _dio.post(
      "$apiBaseUrl/moses/confirm_phone_number/",
      data: {"pin": emailPin, "candidate_pin": emailCandidatePin},
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  }

  Future<UpdatePasswordResponse?> updatePassword(
      String accessToken, String oldPassword, String newPassword) async {
    return UpdatePasswordResponse.fromResponse(await _dio.post(
      "$apiBaseUrl/moses/password/",
      data: {"current_password": oldPassword, "new_password": newPassword},
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  }

  Future<MFASwitchResponse?> setMFAEnabled(
      String accessToken, String action, String? secretKey, String? otp) async {
    return MFASwitchResponse.fromResponse(await _dio.post(
      "$apiBaseUrl/moses/mfa/",
      data: {"action": action, "mfa_secret_key": secretKey},
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken', 'OTP': otp}),
    ));
  }

  Future<CompanyResponse?> getCompany({
    required String accessToken,
    required String companyId,
  }) async {
    return CompanyResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/company/company/$companyId",
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  }

  Future<MarketplacesListResponse?> getMarketplaces(String accessToken) async {
    return MarketplacesListResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/catalogue/marketplace/",
    ));
  }

  Future<MarketplaceResponse?> getMarketplace(
      {required String accessToken,
      required String companyId,
      required String marketplaceId}) async {
    return MarketplaceResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/catalogue/marketplace/$marketplaceId/?company=$companyId",
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  }

  Future<MenuSectionResponse?> getMarketplaceRootMenuSection(
      {required String accessToken,
      required String companyId,
      required String marketplaceId}) async {
    return MenuSectionResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/catalogue/marketplace/$marketplaceId/get_menu?company=$companyId",
    ));
  }

  Future<OrdersListResponse?> getOrders(String accessToken) async {
    return OrdersListResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/trade/order/",
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  }

  Future<OrderCreateResponse> createOrder({
    required String? accessToken,
    required List<OrderEntry> entries,
    required List<String> promocodes,
  }) async {
    return OrderCreateResponse.fromResponse(await _dio.post(
      "$apiBaseUrl/trade/order/",
      data: {
        "order_entries": entries,
        "promocodes": promocodes,
      },
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  }

  Future<TransactionsResponse?> getTransactions(
      String accessToken, int companyId) async {
    return TransactionsResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/logistics/transaction/",
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  }

  Future<TransactionCreateResponse?> createTransaction({
    required String accessToken,
    required int sourceNode,
    required int targetNode,
    int? orderEntryToPayFor,
    int? orderEntryToCompensateFor,
    int? orderEntry,
    required List<TransactionEntry> transactionEntries,
    List<String> externalLedgerTransactions = const [],
    Map<String, dynamic> extraData = const {},
    List<int> pipelineIds = const [],
  }) async {
    Map<String, dynamic> data = {
      "source": sourceNode,
      "target": targetNode,
      if (orderEntry != null) "order_entry": orderEntry,
      if (orderEntryToPayFor != null)
        "order_entry_to_pay_for": orderEntryToPayFor,
      if (orderEntryToCompensateFor != null)
        "order_entry_to_compensate_for": orderEntryToCompensateFor,
      "entries": transactionEntries,
      "extra_data": extraData,
      "external_ledger_transactions": externalLedgerTransactions,
      "pipelines": pipelineIds,
    };

    return TransactionCreateResponse.fromResponse(await _dio.post(
      "$apiBaseUrl/logistics/transaction/",
      data: data,
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  }

  Future<StageAchievementsResponse?> getStageAchievements(
    String accessToken,
    int companyId,
  ) async {
    return StageAchievementsResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/logistics/stageachievement/?company=$companyId",
      options: Options(
        validateStatus: (status) => status! < 500,
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    ));
  }

  Future<NodesListResponse?> getNodes(String accessToken) async {
    return NodesListResponse.fromResponse(await _dio.get(
      "$apiBaseUrl/logistics/transactionnode/",
      options: Options(
          validateStatus: (status) => status! < 500,
          headers: {'Authorization': 'Bearer $accessToken'}),
    ));
  }
}
