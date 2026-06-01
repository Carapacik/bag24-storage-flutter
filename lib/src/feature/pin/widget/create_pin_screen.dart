import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/pin/bloc/create_pin/create_pin_bloc.dart';
import 'package:bag24/src/feature/pin/widget/pin_dots.dart';
import 'package:bag24/src/feature/pin/widget/pin_keyboard.dart';
import 'package:bag24/src/feature/shared_widgets/animation/shake_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

class const CreatePinScreen({super.key}) extends StatefulWidget {
  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState() extends State<CreatePinScreen> {
  final _shakeKey = GlobalKey<ShakeAnimationWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<CreatePinBloc, CreatePinState>(
          listener: (context, state) {
            state.mapOrNull(
              failure: (_) => _shakeKey.currentState?.shake(),
              success: (s) {
                if (s.availableBiometrics.contains(BiometricType.face) ||
                    s.availableBiometrics.contains(BiometricType.fingerprint) ||
                    s.availableBiometrics.contains(BiometricType.strong)) {
                  // Don`t use goNamed, it causes an error
                  context.pushReplacementNamed(Routes.biometrics.name, extra: s.availableBiometrics);
                  return;
                }
                // Don`t use goNamed, it causes an error
                context.pushReplacementNamed(Routes.home.name);
              },
            );
          },
          builder: (context, state) {
            return Column(
              children: [
                const Spacer(),
                Text(
                  state.savedPin == null ? context.l10n.setPinCode : context.l10n.repeatPinCode,
                  style: context.textStyles.bodyRegular.copyWith(
                    color: state.isFailure ? context.colors.error : context.colors.textPrimary,
                  ),
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
                        context.read<CreatePinBloc>().add(CreatePinEvent.pinChanged(fullPin));
                      }
                    },
                    onDeletePressed: () {
                      if (state.pin.isNotEmpty) {
                        context.read<CreatePinBloc>().add(
                          CreatePinEvent.pinChanged(state.pin.substring(0, state.pin.length - 1)),
                        );
                      }
                    },
                  ),
                ),
                WindowSizeScope.of(context)
                    .maybeMap(compact: () => const SizedBox(height: 20), orElse: () => const Spacer()),
              ],
            );
          },
        ),
      ),
    );
  }
}
