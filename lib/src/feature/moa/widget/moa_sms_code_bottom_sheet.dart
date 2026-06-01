import 'dart:async';
import 'dart:ui' as ui;

import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/moa/bloc/moa_sms_code/moa_sms_code_bloc.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/countdown_button.dart';
import 'package:bag24/src/feature/shared_widgets/loading/full_screen_loading.dart';
import 'package:bag24/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:bag24/src/feature/user/model/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

Future<bool?> showMoaSmsCodeBottomSheet(BuildContext context, {required String orderId}) =>
    showCustomModalBottomSheet<bool>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      builder: (_) {
        final double height = MediaQuery.sizeOf(context).height;
        final EdgeInsets safeAreaPadding = MediaQueryData.fromView(ui.PlatformDispatcher.instance.implicitView!)
            .padding;
        return BlocProvider(
          create: (_) => MOASmsCodeBloc(orderRepository: context.dependencies.orderRepository, orderId: orderId),
          child: SizedBox(
            height: height - 16 - safeAreaPadding.top - safeAreaPadding.bottom,
            child: const _MOASmsCodePart(),
          ),
        );
      },
    );

class const _MOASmsCodePart() extends StatefulWidget {
  @override
  State<_MOASmsCodePart> createState() => _MOASmsCodePartState();
}

class _MOASmsCodePartState() extends State<_MOASmsCodePart> {
  late final Future<UserProfile?> _future = context.dependencies.userRepository.getLocalUser();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MOASmsCodeBloc, MOASmsCodeState>(
      listener: (context, state) {
        state.mapOrNull(
          success: (s) async {
            FocusManager.instance.primaryFocus?.unfocus();
            final GoRouter navigator = GoRouter.of(context);
            await Future<void>.delayed(const Duration(milliseconds: 300)).then((value) => navigator.pop(true));
          },
          failure: (s) => showCustomAppException(context, s.exception),
        );
      },
      builder: (context, state) {
        return FullScreenLoading(
          inProgress: state.inProgress,
          child: SafeArea(
            child: Column(
              children: [
                const Align(alignment: Alignment.topLeft, child: Bag24CloseButton()),
                const SizedBox(height: 16),
                SvgPicture.asset(context.icons.mileOnAirLogo, width: 80),
                const SizedBox(height: 16),
                Text(context.l10n.enterCode, style: context.textStyles.title1Emphasized),
                const SizedBox(height: 12),
                Text(
                  context.l10n.codeWillBeSentWithinMinute,
                  style: context.textStyles.bodyRegular.copyWith(color: context.colors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                FutureBuilder(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Text(
                        formatAsPhoneNumber(snapshot.data!.phoneNumber) ?? '',
                        style: context.textStyles.bodyRegular,
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const SizedBox(height: 16),
                const _MOATextField(),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: CountdownButton(
                    onPressed: () => context.read<MOASmsCodeBloc>().add(const MOASmsCodeEvent.resend()),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class const _MOATextField() extends StatefulWidget {
  @override
  State<_MOATextField> createState() => _MOATextFieldState();
}

class _MOATextFieldState() extends State<_MOATextField> {
  late final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 44,
      height: 58,
      textStyle: context.textStyles.largeTitleEmphasized,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: context.colors.inputBgPrimary),
    );

    final PinTheme focusedPinTheme = defaultPinTheme.copyDecorationWith(border: Border.all(color: Colors.transparent));
    final PinTheme successPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: context.colors.success),
    );
    final PinTheme errorPinTheme = defaultPinTheme.copyDecorationWith(border: Border.all(color: context.colors.error));
    final submittedPinTheme = defaultPinTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<MOASmsCodeBloc, MOASmsCodeState>(
        builder: (context, state) {
          final bool? isValid = state.mapOrNull(success: (_) => true, failure: (_) => false);
          return Column(
            children: [
              Pinput(
                controller: _controller,
                autofocus: true,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                errorPinTheme: errorPinTheme,
                submittedPinTheme: isValid == null
                    ? submittedPinTheme
                    : isValid
                    ? successPinTheme
                    : errorPinTheme,
                showCursor: false,
                onChanged: (code) {
                  if (code.length == 4) {
                    context.read<MOASmsCodeBloc>().add(MOASmsCodeEvent.send(code));
                  }
                },
                onCompleted: (value) {
                  Future.delayed(const Duration(milliseconds: 1500), () => _controller.clear());
                },
              ),
              const SizedBox(height: 8),
              if (isValid ?? false)
                Text(
                  context.l10n.correctCode,
                  style: context.textStyles.footnoteRegular.copyWith(color: context.colors.success),
                )
              else if (isValid != null)
                Text(
                  context.l10n.invalidCodeTryAgain,
                  style: context.textStyles.footnoteRegular.copyWith(color: context.colors.error),
                ),
            ],
          );
        },
      ),
    );
  }
}
