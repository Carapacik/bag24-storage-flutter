import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/biometrics/bloc/biometrics_bloc.dart';
import 'package:bag24/src/feature/biometrics/data/biometrics_repository.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/gradient_button.dart';
import 'package:bag24/src/feature/shared_widgets/button/tonal_button.dart';
import 'package:bag24/src/feature/shared_widgets/layout/two_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

class const BiometricsScreen({required final List<BiometricType> availableBiometrics, super.key})
    extends StatefulWidget {
  @override
  State<BiometricsScreen> createState() => _BiometricsScreenState();
}

class _BiometricsScreenState() extends State<BiometricsScreen> {
  late final IBiometricsRepository _biometricsRepository = context.dependencies.biometricsRepository;

  Future<void> _localAuthenticate(BuildContext context) async {
    final GoRouter router = GoRouter.of(context);
    final BiometricsBloc bloc = context.read<BiometricsBloc>();
    await _biometricsRepository.localAuthenticate(
      context,
      onAuthenticate: (didAuthenticate) {
        if (didAuthenticate) {
          bloc.add(BiometricsEvent.setBiometrics(widget.availableBiometrics));
        } else {
          router.goNamed(Routes.home.name);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final double dimensions = windowSize.maybeMap(compact: () => 72.0, orElse: () => 90.0);
    return BlocListener<BiometricsBloc, BiometricsState>(
      listener: (context, state) {
        switch (state) {
          case final BiometricsSuccess _:
            context.goNamed(Routes.home.name);
          case final BiometricsFailure _:
            showErrorMessage(context, context.l10n.unknownAppException);
          default:
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(automaticallyImplyLeading: false),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Spacer(),
                SvgPicture.asset(
                  widget.availableBiometrics.contains(BiometricType.face)
                      ? Assets.svg.faceId.path
                      : Assets.svg.touchId.path,
                  height: dimensions,
                  width: dimensions,
                  colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
                ),
                const SizedBox(height: 24),
                Text(
                  context.l10n.connectLoginBy(widget.availableBiometrics.title),
                  style: context.textStyles.bodyRegular,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                TwoButtons(
                  firstWidget: GradientElevatedButton(
                    onPressed: () async => await _localAuthenticate(context),
                    text: context.l10n.useBy(widget.availableBiometrics.title),
                  ),
                  secondWidget: CustomTonalButton(
                    onPressed: () => context.goNamed(Routes.home.name),
                    text: context.l10n.skip,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on List<BiometricType> {
  String get title => contains(BiometricType.face) ? 'Face ID' : 'Touch ID';
}
