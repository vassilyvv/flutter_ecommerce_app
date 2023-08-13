import 'dart:ui';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:very_supply_api_client/api/client.dart';
import 'package:very_supply_api_client/api/responses.dart';
import 'package:very_supply_api_client/models/auth/user.dart';

class AuthController extends GetxController {
  Rx<User?> authenticatedUser = Rx<User?>(null);

  void logout() {
    authenticatedUser.value = null;
    update();
  }

  Future<dio.Response?> validateSavedAccessToken(
      Future<dio.Response> Function(String) tokenManipulation) async {
    if (authenticatedUser.value == null ||
        authenticatedUser.value!.accessToken == null ||
        authenticatedUser.value!.refreshToken == null) {
      return null;
    }
    dio.Response response =
        await tokenManipulation(authenticatedUser.value!.accessToken!);
    if (response.statusCode == 401) {
      TokenRefreshResponse tokenRefreshResponse =
          apiMethods['refreshAccessToken']!(
              authenticatedUser.value!.refreshToken!);
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
    LoginResponse loginResponse = await apiMethods['authenticate']!(
        {'phoneNumber': phoneNumber, 'password': password, 'otp': otp});
    if (loginResponse.statusCode == 200) {
      UserDataResponse authenticatedUserDataResponse =
          await apiMethods['getAuthenticatedUserData']!(
              {'accessToken': loginResponse.accessToken!});
      authenticatedUser.value = authenticatedUserDataResponse.user;
      authenticatedUser.value!.accessToken = loginResponse.accessToken;
      authenticatedUser.value!.refreshToken = loginResponse.refreshToken;
    } else {
      Get.snackbar(
          snackPosition: SnackPosition.BOTTOM,
          "unable_to_login".tr,
          "invalid_credentials".tr,
          colorText: Colors.black,
          backgroundColor: const Color(0xFFEC6813));
    }
  }

  void refreshToken(String refreshToken) async {
    if (authenticatedUser.value == null ||
        authenticatedUser.value!.refreshToken == null) {
      authenticatedUser.value = null;
      update();
      return null;
    }
    final refreshedAccessToken = (await apiMethods['refreshAccessToken']!(
            {'refreshToken': authenticatedUser.value!.refreshToken!}))
        .refreshedAccessToken;
    if (refreshedAccessToken == null) {
      update();
      return null;
    }
    authenticatedUser.value!.accessToken = refreshedAccessToken;
    update();
  }
}
