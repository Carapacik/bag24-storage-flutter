import 'dart:async';

import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:bag24/src/feature/authentication/widget/authentication_scope.dart';
import 'package:bag24/src/feature/biometrics/data/biometrics_repository.dart';
import 'package:bag24/src/feature/pin/bloc/enter_pin/enter_pin_bloc.dart';
import 'package:bag24/src/feature/pin/widget/pin_dots.dart';
import 'package:bag24/src/feature/pin/widget/pin_keyboard.dart';
import 'package:bag24/src/feature/shared_widgets/animation/shake_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class const EnterPinScreen({super.key}) extends StatefulWidget {
  @override
  State<EnterPinScreen> createState() => _EnterPinScreenState();
}

class _EnterPinScreenState() extends State<EnterPinScreen> {
  late final IBiometricsRepository _biometricsRepository = context.dependencies.biometricsRepository;
  final _shakeKey = GlobalKey<ShakeAnimationWidgetState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => unawaited(_localAuthenticate(context)));
  }

  Future<void> _localAuthenticate(BuildContext context) async {
    final GoRouter router = GoRouter.of(context);
    await _biometricsRepository.localAuthenticate(
      context,
      onAuthenticate: (didAuthenticate) {
        if (didAuthenticate) {
          router.goNamed(Routes.home.name);
        }
      },
      checkForSavedBiometrics: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<EnterPinBloc, EnterPinState>(
          listener: (context, state) {
            state.mapOrNull(
              failure: (value) => _shakeKey.currentState?.shake(),
              success: (value) => context.goNamed(Routes.home.name),
            );
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    context.l10n.enterPinCode,
                    style: context.textStyles.bodyRegular.copyWith(color: context.colors.textPrimary),
                  ),
                  const SizedBox(height: 32),
                  ShakeAnimationWidget(
                    key: _shakeKey,
                    child: PinDots(
                      pin: state.pin,
                      isValid: state.mapOrNull(failure: (_) => false, success: (_) => true),
                    ),
                  ),
                  WindowSizeScope.of(context)
                      .maybeMap(compact: () => const Spacer(), orElse: () => const SizedBox(height: 64)),
                  Center(
                    child: PinKeyboard(
                      pin: state.pin,
                      onChanged: (value) {
                        final fullPin = '${state.pin}$value';
                        if (fullPin.length < 5) {
                          context.read<EnterPinBloc>().add(EnterPinEvent.pinChanged(fullPin));
                          return;
                        }
                      },
                      onDeletePressed: () {
                        if (state.pin.isNotEmpty) {
                          context.read<EnterPinBloc>().add(
                            EnterPinEvent.pinChanged(state.pin.substring(0, state.pin.length - 1)),
                          );
                        }
                      },
                    ),
                  ),
                  WindowSizeScope.of(context)
                      .maybeMap(compact: () => const SizedBox(height: 20), orElse: () => const Spacer()),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: TextButton(
                      onPressed: () => AuthenticationScope.of(context).add(const AuthenticationEvent.signOutPressed()),
                      child: Text(
                        context.l10n.forgotYourPin,
                        style: context.textStyles.bodyRegular.copyWith(color: context.colors.textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
