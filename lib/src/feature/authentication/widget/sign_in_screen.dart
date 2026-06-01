import 'package:bag24/src/core/constant/constants.dart';
import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:bag24/src/feature/authentication/model/input_phone_data.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/gradient_button.dart';
import 'package:bag24/src/feature/shared_widgets/button/tonal_button.dart';
import 'package:bag24/src/feature/shared_widgets/loading/full_screen_loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class const SignInScreen({super.key}) extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState() extends State<SignInScreen> {
  late final TextEditingController _controller = TextEditingController();
  PhoneCountryData? _countryData = PhoneCodes.getPhoneCountryDataByCountryCode('RU');
  static const _countryIsoCodes = ['AZ', 'AM', 'BY', 'GE', 'KZ', 'KG', 'MD', 'RU', 'TJ', 'TM', 'UA', 'UZ'];
  final ValueNotifier<String?> _phoneError = ValueNotifier<String?>(null);

  @override
  void dispose() {
    _phoneError.dispose();
    _controller.dispose();
    super.dispose();
  }

  late final List<String? Function(InputPhoneData data)> _validators = [
    (data) => _phoneError.value = data.isValidPhone(context),
  ];

  bool _validate(BuildContext context, InputPhoneData data) {
    var result = true;
    String? message;
    for (final String? Function(InputPhoneData data) validator in _validators) {
      final String? validMessage = validator(data);
      if (validMessage != null) {
        result = false;
        message = validMessage;
      }
    }
    if (message != null) {
      showErrorMessage(context, message);
    }
    return result;
  }

  void _onSubmitted(BuildContext context, SignInType type) {
    final data = InputPhoneData(
      phone: _controller.text.trim(),
      countryNumber: _countryData?.phoneCode ?? '',
      countryCode: _countryData?.countryCode ?? '',
      signInType: type,
    );
    if (!_validate(context, data)) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    context.read<SignInBloc>().add(SignInEvent.sendPhone(data.fullPhone, data.signInType));
  }

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final textField = _PhoneTextField(controller: _controller, countryData: _countryData);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          switch (state) {
            case final SignInFailure s:
              showCustomAppException(context, s.exception);
            case final SignInSuccess s:
              context.goNamed(Routes.otpCode.name, queryParameters: {'phone': s.phone});
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
                      Text(context.l10n.entrance, style: context.textStyles.title1Emphasized),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          context.l10n.loginToExistingAccountOrCreateNew,
                          style: context.textStyles.bodyRegular.copyWith(color: context.colors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: SizedBox(
                          height: 56,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 120,
                                child: CountryDropdown(
                                  printCountryName: true,
                                  iconSize: 0,
                                  elevation: 4,
                                  initialCountryData: _countryData,
                                  filter: PhoneCodes.findCountryDatasByCountryCodes(countryIsoCodes: _countryIsoCodes),
                                  style: context.textStyles.bodyRegular.copyWith(color: context.colors.textSecondary),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                    filled: true,
                                    fillColor: context.colors.inputBgPrimary,
                                  ),
                                  onCountrySelected: (data) => setState(() => _countryData = data),
                                ),
                              ),
                              const SizedBox(width: 8),
                              windowSize.maybeMap(
                                compact: () => Expanded(child: textField),
                                orElse: () =>
                                    ConstrainedBox(constraints: const BoxConstraints(maxWidth: 220), child: textField),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${context.l10n.byContinuingYouAgreeTo} ',
                              style: context.textStyles.caption1Regular.copyWith(color: context.colors.textTertiary),
                            ),
                            TextSpan(
                              text: context.l10n.withPrivacyPolicyAndUserAgreement,
                              style: context.textStyles.caption1Regular.copyWith(color: context.colors.textPrimary),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async => await launchUrl(Uri.parse(mobilePrivacyPolicyUrl)),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ListenableBuilder(
                          listenable: _controller,
                          builder: (context, child) => GradientElevatedButton(
                            onPressed: _controller.text.trim().isNotEmpty
                                ? () => _onSubmitted(context, SignInType.telegram)
                                : null,
                            text: 'Получить код в Telegram',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ListenableBuilder(
                          listenable: _controller,
                          builder: (context, child) => CustomTonalButton(
                            onPressed: _controller.text.trim().isNotEmpty
                                ? () => _onSubmitted(context, SignInType.sms)
                                : null,
                            text: 'Получить код в SMS',
                          ),
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

class const _PhoneTextField({
  required final TextEditingController controller,
  required final PhoneCountryData? countryData,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.send,
        keyboardType: TextInputType.phone,
        style: context.textStyles.bodyRegular,
        inputFormatters: [PhoneInputFormatter(defaultCountryCode: countryData?.countryCode)],
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          filled: true,
          fillColor: context.colors.inputBgPrimary,
          hintText: countryData?.phoneMaskWithoutCountryCode,
          hintStyle: context.textStyles.bodyRegular.copyWith(color: context.colors.textTertiary),
          suffixIcon: ListenableBuilder(
            listenable: controller,
            builder: (context, child) => (controller.text.isNotEmpty)
                ? IconButton(
                    onPressed: controller.clear,
                    visualDensity: VisualDensity.compact,
                    splashRadius: 24,
                    icon: SvgPicture.asset(
                      Assets.svg.closeCircle.path,
                      height: 20,
                      width: 20,
                      colorFilter: ColorFilter.mode(context.colors.iconSecondary, BlendMode.srcIn),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
