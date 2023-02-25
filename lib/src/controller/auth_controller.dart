import 'package:e_commerce_flutter/src/api/client.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../model/user.dart';

final apiClient = APIClient();

class AuthController extends GetxController {
  Rx<User?> authenticatedUser = Rx<User?>(null);


  Future<dio.Response?> validateSavedAccessToken(
      Future<dio.Response> Function(String) tokenManipulation) async {
    if (authenticatedUser.value == null ||
        authenticatedUser.value!.accessToken == null ||
        authenticatedUser.value!.refreshToken == null) {
      return null;
    }
    dio.Response response = await tokenManipulation(
        authenticatedUser.value!.accessToken!);
    if (response.statusCode == 401) {
      TokenRefreshResponse tokenRefreshResponse = await apiClient
          .refreshAccessToken(authenticatedUser.value!.refreshToken!);
      if (tokenRefreshResponse.statusCode >= 400) {
        return response;
      }
      authenticatedUser.value!.accessToken =
      tokenRefreshResponse.refreshedAccessToken!;
      return await tokenManipulation(authenticatedUser.value!.accessToken!);
    } else {
      return response;
    }
  }

  void authenticate(String phoneNumber, String password, String? otp) async {
    LoginResponse loginResponse = await apiClient.authenticate(
        phoneNumber, password, otp);
    if (loginResponse.statusCode == 200) {
      UserDataResponse authenticatedUserDataResponse = await apiClient
          .getAuthenticatedUserData(loginResponse.accessToken!);
      authenticatedUser.value = User(
        authenticatedUserDataResponse.email,
        authenticatedUserDataResponse.phoneNumber,
        authenticatedUserDataResponse.firstName,
        authenticatedUserDataResponse.lastName,
        loginResponse.accessToken,
        loginResponse.refreshToken,
        authenticatedUserDataResponse.id,
        authenticatedUserDataResponse.isEmailConfirmed,
        authenticatedUserDataResponse.emailCandidate,
        authenticatedUserDataResponse.isPhoneNumberConfirmed,
        authenticatedUserDataResponse.phoneNumberCandidate,
        authenticatedUserDataResponse.isMFAEnabled,
      );
    }
  }

  void refreshToken(String refreshToken) async {
    if (authenticatedUser.value == null || authenticatedUser.value!.refreshToken == null) {
      authenticatedUser.value = null;
      update();
      return null;
    }
    final refreshedAccessToken = (await apiClient.refreshAccessToken(
        authenticatedUser.value!.refreshToken!)).refreshedAccessToken;
    if (refreshedAccessToken == null) {
      update();
      return null;
    }
    authenticatedUser.value!.accessToken = refreshedAccessToken;
    update();
  }
}