import 'dart:async';

import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/version.dart';
import 'package:bag24/src/feature/authentication/data/authentication_repository.dart';
import 'package:bag24/src/feature/onboarding/data/onboarding_repository.dart';
import 'package:bag24/src/feature/permissions/data/permissions_repository.dart';
import 'package:bag24/src/feature/pin/data/pin_repository.dart';
import 'package:bag24/src/feature/system/data/app_state_repository.dart';
import 'package:bag24/src/feature/system/model/app_state.dart';
import 'package:bag24/src/feature/user/data/user_repository.dart';
import 'package:bag24/src/feature/user/model/user_profile.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'splash_bloc.freezed.dart';
part 'splash_event.dart';
part 'splash_state.dart';

final class SplashBloc({
  required final PackageInfo _packageInfo,
  required final IAppStateRepository _stateRepository,
  required final IAuthenticationRepository _authenticationRepository,
  required final IUserRepository _userRepository,
  required final IPinRepository _pinRepository,
  required final IPermissionsRepository _permissionsRepository,
  required final IOnboardingRepository _onboardingRepository,
}) extends Bloc<SplashEvent, SplashState> {
  this : super(const SplashState.processing()) {
    on<_SplashStarted>(_start);
  }

  Future<void> _start(_SplashStarted event, Emitter<SplashState> emit) async {
    emit(const SplashState.processing());
    await ExceptionHandler.handle(() async {
      await _permissionsRepository.checkAllPermissions();

      // Check internet connection
      final bool hasInternet = await InternetConnection().hasInternetAccess;
      if (!hasInternet) {
        emit(const SplashState.failure(Routes.connectionError));
        return;
      }

      final List<AppState> appStates = await _stateRepository.state;
      final AppState? appState = appStates.firstOrNull;

      if (appState != null) {
        if (appState.technicalWorks) {
          emit(const SplashState.failure(Routes.technicalError));
          return;
        }
        final String appVersion = _packageInfo.version;
        if (compareVersions(appVersion, appState.latestSupportedVersion) == -1) {
          emit(SplashState.failure(Routes.updateApp, latestVersion: appState.latestSupportedVersion));
          return;
        }
        if (compareVersions(appVersion, appState.latestVersion) == -1) {
          _stateRepository.setUpdateAvailable();
        }
      }
    }, onError: (exception, stackTrace) async => emit(const SplashState.failure(Routes.technicalError)));

    final String? accessToken = _authenticationRepository.currentUser.accessToken;
    final String? pin = await _pinRepository.getPin();
    if (accessToken != null && (pin?.isNotEmpty ?? false)) {
      await ExceptionHandler.handle(
        () async {
          /// Get user information
          final UserProfile? user = await _userRepository.me();
          if (user != null) {
            emit(const SplashState.success(Routes.enterPin));
            return;
          }
        },
        onError: (exception, stackTrace) async {
          return;
        },
      );
    } else {
      await _authenticationRepository.signOut();
      emit(SplashState.failure(await _route));
    }
  }

  Future<Routes> get _route async {
    if (await _onboardingRepository.isHideOnboarding()) {
      return Routes.home;
    } else {
      return Routes.onboarding;
    }
  }
}
