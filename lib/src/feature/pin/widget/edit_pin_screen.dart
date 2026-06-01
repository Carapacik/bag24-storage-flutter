import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/pin/bloc/edit_pin/edit_pin_bloc.dart';
import 'package:bag24/src/feature/pin/widget/pin_dots.dart';
import 'package:bag24/src/feature/pin/widget/pin_keyboard.dart';
import 'package:bag24/src/feature/shared_widgets/animation/shake_animation_widget.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class const EditPinScreen({super.key}) extends StatefulWidget {
  @override
  State<EditPinScreen> createState() => _EditPinScreenState();
}

class _EditPinScreenState() extends State<EditPinScreen> {
  final _shakeKey = GlobalKey<ShakeAnimationWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: context.l10n.changePinCode),
      body: SafeArea(
        child: BlocConsumer<EditPinBloc, EditPinState>(
          listener: (context, state) {
            state.mapOrNull(failure: (value) => _shakeKey.currentState?.shake(), success: (value) => context.pop());
          },
          builder: (context, state) {
            return Column(
              children: [
                const Spacer(),
                Text(
                  state.type.localizedText(context),
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
                        context.read<EditPinBloc>().add(EditPinEvent.pinChanged(fullPin));
                      }
                    },
                    onDeletePressed: () {
                      if (state.pin.isNotEmpty) {
                        context.read<EditPinBloc>().add(
                          EditPinEvent.pinChanged(state.pin.substring(0, state.pin.length - 1)),
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
