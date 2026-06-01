import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/authentication/bloc/otp_code/otp_code_bloc.dart';
import 'package:bag24/src/feature/profile/bloc/profile/profile_bloc.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/countdown_button.dart';
import 'package:bag24/src/feature/shared_widgets/loading/full_screen_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class const OtpCodeScreen({required final String phone, super.key}) extends StatefulWidget {
  @override
  State<OtpCodeScreen> createState() => _OtpCodeScreenState();
}

class _OtpCodeScreenState() extends State<OtpCodeScreen> {
  late final _codeController = TextEditingController();
  late final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocConsumer<OtpCodeBloc, OtpCodeState>(
        listener: (context, state) async {
          switch (state) {
            case final OtpCodeFailure s:
              _codeController.clear();
              _focusNode.requestFocus();
              showCustomAppException(context, s.exception);
            case final OtpCodeSuccess s:
              final GoRouter router = GoRouter.of(context);
              final ProfileBloc profileBloc = context.read<ProfileBloc>();
              await Future<void>.delayed(const Duration(milliseconds: 300)).then((value) {
                router.goNamed(s.route.name);
                profileBloc.add(const ProfileEvent.start());
              });
            default:
          }
        },
        builder: (context, state) {
          return FullScreenLoading(
            inProgress: state.inProgress,
            child: Scaffold(
              appBar: const CustomAppBar(),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      Text(context.l10n.enterCode, style: context.textStyles.title1Emphasized),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${context.l10n.codeWillBeSentWithinMinute}\n',
                                style: context.textStyles.bodyRegular.copyWith(color: context.colors.textSecondary),
                              ),
                              TextSpan(
                                text: formatAsPhoneNumber(widget.phone) ?? '',
                                style: context.textStyles.bodyRegular.copyWith(color: context.colors.textPrimary),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: _OtpTextField(controller: _codeController, focusNode: _focusNode),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: CountdownButton(
                          onPressed: () => context.read<OtpCodeBloc>().add(const OtpCodeEvent.resend()),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class const _OtpTextField({required final TextEditingController controller, required final FocusNode focusNode})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final defaultPinTheme = PinTheme(
      width: windowSize.maybeMap(compact: () => 44, orElse: () => 52),
      height: windowSize.maybeMap(compact: () => 58, orElse: () => 72),
      textStyle: context.textStyles.largeTitleEmphasized,
      decoration: BoxDecoration(color: context.colors.inputBgPrimary, borderRadius: BorderRadius.circular(12)),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Pinput(
        length: 6,
        controller: controller,
        focusNode: focusNode,
        autofocus: true,
        showCursor: false,
        onChanged: (code) {
          if (code.length == 6) {
            context.read<OtpCodeBloc>().add(
              OtpCodeEvent.verifyPressed(
                code,
                '${MediaQuery.sizeOf(context).width.toInt()}x${MediaQuery.sizeOf(context).height.toInt()}',
              ),
            );
          }
        },
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: defaultPinTheme,
      ),
    );
  }
}
