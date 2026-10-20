// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/apple_sign_in_dto.dart';
import '../models/auth_response_dto.dart';
import '../models/change_password_dto.dart';
import '../models/dev_customer_login_dto.dart';
import '../models/google_sign_in_dto.dart';
import '../models/login_dto.dart';
import '../models/me_dto.dart';
import '../models/refresh_token_dto.dart';
import '../models/update_profile_dto.dart';

part 'auth_client.g.dart';

@RestApi()
abstract class AuthClient {
  factory AuthClient(Dio dio, {String? baseUrl}) = _AuthClient;

  /// Customer sign-in with a Google ID token
  @POST('/api/v1/auth/google')
  Future<AuthResponseDto> google({
    @Body() required GoogleSignInDto body,
  });

  /// Customer sign-in with an Apple identity token
  @POST('/api/v1/auth/apple')
  Future<AuthResponseDto> apple({
    @Body() required AppleSignInDto body,
  });

  /// Merchant (phone) or admin (email) login with a password
  @POST('/api/v1/auth/login')
  Future<AuthResponseDto> login({
    @Body() required LoginDto body,
  });

  /// Get a new access token. The refresh token is replaced too.
  @POST('/api/v1/auth/refresh')
  Future<AuthResponseDto> refresh({
    @Body() required RefreshTokenDto body,
  });

  /// Log out this device (revokes the refresh token)
  @POST('/api/v1/auth/logout')
  Future<void> logout({
    @Body() required RefreshTokenDto body,
  });

  /// The logged-in user and the stores they work at
  @GET('/api/v1/auth/me')
  Future<MeDto> me();

  /// Update my name or contact phone
  @PATCH('/api/v1/auth/me')
  Future<MeDto> updateMe({
    @Body() required UpdateProfileDto body,
  });

  /// Change password (logs out other devices, returns new tokens)
  @POST('/api/v1/auth/change-password')
  Future<AuthResponseDto> changePassword({
    @Body() required ChangePasswordDto body,
  });

  /// DEVELOPMENT ONLY: log in as a test customer (404 unless DEV_AUTH_ENABLED=true)
  @POST('/api/v1/auth/dev/customer')
  Future<AuthResponseDto> devCustomer({
    @Body() required DevCustomerLoginDto body,
  });
}
