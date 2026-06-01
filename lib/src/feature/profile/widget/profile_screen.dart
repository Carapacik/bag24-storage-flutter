import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/resources/resources.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:bag24/src/feature/authentication/widget/authentication_scope.dart';
import 'package:bag24/src/feature/moa/bloc/moa/moa_bloc.dart';
import 'package:bag24/src/feature/moa/widget/moa_bottom_sheet.dart';
import 'package:bag24/src/feature/profile/bloc/profile/profile_bloc.dart';
import 'package:bag24/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/gradient_button.dart';
import 'package:bag24/src/feature/shared_widgets/loading/custom_circular_progress_indicator.dart';
import 'package:bag24/src/feature/shared_widgets/loading/shimmer.dart';
import 'package:bag24/src/feature/shared_widgets/modal/dialog.dart';
import 'package:bag24/src/feature/user/model/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class const ProfileScreen({super.key}) extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState() extends State<ProfileScreen> {
  late final DraggableScrollableController _controller = DraggableScrollableController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _logout(BuildContext context) {
    AuthenticationScope.of(context).add(const AuthenticationEvent.signOutPressed());
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double safeAreaPadding = MediaQuery.paddingOf(context).top;
    final double minChildSize = (size.height - 248 - safeAreaPadding) / size.height;
    final bool authenticated = AuthenticationScope.userOf(context).isAuthenticated;
    final WindowSize windowSize = WindowSizeScope.of(context);
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        state.mapOrNull(
          failure: (s) => showCustomAppException(context, s.exception),
          deletedFailure: (s) => showCustomAppException(context, s.exception),
          deletedSuccess: (_) {
            _logout(context);
            context.goNamed(Routes.signIn.name);
          },
        );
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: context.colors.baseBgSecondary,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            if (authenticated) const _EditProfileWidget() else const _NoUserWidget(),
            DraggableScrollableSheet(
              controller: _controller,
              minChildSize: minChildSize,
              initialChildSize: minChildSize,
              snap: true,
              maxChildSize: (size.height - safeAreaPadding) / size.height,
              builder: (context, scrollController) => Material(
                color: context.colors.baseBgPrimary,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Center(
                      child: SizedBox(
                        height: 4,
                        width: 32,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: context.colors.iconTertiary,
                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: compactMaxWidth),
                        child: ListView(
                          padding: windowSize.isCompact ? const EdgeInsets.symmetric(horizontal: 16) : EdgeInsets.zero,
                          controller: scrollController,
                          children: [
                            if (authenticated) ...[const _MOAWidget(), const SizedBox(height: 20)],
                            _TextTileWidget(
                              title: context.l10n.settings,
                              onTap: () async => await context.pushNamed(Routes.settings.name),
                              iconPath: Assets.svg.settings.path,
                              dividerBottom: authenticated,
                              roundTop: true,
                              roundBottom: !authenticated,
                            ),
                            // FlyPost
                            // _TextTileWidget(
                            //   title: 'Паспортные данные',
                            //   onTap: () async => context.pushNamed(Routes.editPassport.name),
                            //   iconPath: Assets.svg.user.path,
                            //   dividerBottom: authenticated,
                            //   roundBottom: !authenticated,
                            // ),
                            if (authenticated)
                              _TextTileWidget(
                                title: context.l10n.paymentMethod,
                                onTap: () async => await context.pushNamed(Routes.userBindingCards.name),
                                iconPath: Assets.svg.walletMoney.path,
                                roundBottom: true,
                              ),
                            const SizedBox(height: 20),
                            _TextTileWidget(
                              title: context.l10n.aboutBAG24,
                              onTap: () async => await context.pushNamed(Routes.aboutApp.name),
                              iconPath: Assets.svg.question.path,
                              dividerBottom: true,
                              roundTop: true,
                            ),
                            _TextTileWidget(
                              title: context.l10n.privacyPolicy,
                              onTap: () async => await launchUrl(Uri.parse('https://bag24.ru/privacy-policy-mobile')),
                              iconPath: Assets.svg.question.path,
                              dividerBottom: true,
                            ),
                            _TextTileWidget(
                              title: context.l10n.userAgreement,
                              onTap: () async => await launchUrl(Uri.parse('https://bag24.ru/user-agreement')),
                              iconPath: Assets.svg.document.path,
                              roundBottom: true,
                            ),
                            if (authenticated) ...[
                              const SizedBox(height: 20),
                              _TextTileWidget(
                                title: context.l10n.logOutOfYourProfile,
                                onTap: () async {
                                  final bool? result = await showCustomAlertDialog(
                                    context: context,
                                    title: context.l10n.logOutOfYourProfile,
                                    content: context.l10n.areYouSureYouWantLogOut,
                                    cancelText: context.l10n.cancel,
                                    actionText: context.l10n.yes,
                                    actionTextColor: context.colors.error,
                                    actionButtonColor: context.colors.errorLight,
                                    buttonDirection: Axis.vertical,
                                  );
                                  if ((result ?? false) && context.mounted) {
                                    _logout(context);
                                    await scrollController.animateTo(
                                      minChildSize,
                                      duration: const Duration(milliseconds: 200),
                                      curve: Curves.linear,
                                    );
                                    await _controller.animateTo(
                                      minChildSize,
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.linearToEaseOut,
                                    );
                                  }
                                },
                                iconPath: Assets.svg.logout.path,
                                roundBottom: true,
                                roundTop: true,
                                showTrailing: false,
                              ),
                              const SizedBox(height: 12),
                              _TextTileWidget(
                                title: context.l10n.deleteAnAccount,
                                onTap: () async {
                                  final bool? result = await showCustomAlertDialog(
                                    context: context,
                                    title: context.l10n.deleteAnAccount,
                                    content: context.l10n.areYouSureYouWantDeleteYourAccount,
                                    actionText: context.l10n.yes,
                                    cancelText: context.l10n.cancel,
                                    actionTextColor: context.colors.error,
                                    actionButtonColor: context.colors.errorLight,
                                    buttonDirection: Axis.vertical,
                                  );
                                  if ((result ?? false) && context.mounted) {
                                    context.read<ProfileBloc>().add(const ProfileEvent.deleteAccount());
                                  }
                                },
                                iconPath: Assets.svg.trash.path,
                                roundBottom: true,
                                roundTop: true,
                                backgroundColor: context.colors.errorLight,
                                foregroundColor: context.colors.error,
                                textColor: context.colors.error,
                                showTrailing: false,
                              ),
                            ],
                            const SafeArea(child: SizedBox(height: 8)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class const _NoUserWidget() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SvgPicture.asset(
          Assets.svg.profilePattern.path,
          fit: BoxFit.cover,
          width: windowSize.isCompact ? MediaQuery.sizeOf(context).width : 400,
          colorFilter: ColorFilter.mode(context.colors.iconTertiary, BlendMode.srcIn),
        ),
        SafeArea(
          child: SizedBox(
            height: 250,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 400,
                  child: Column(
                    children: [
                      const Spacer(),
                      Text(context.l10n.logInYourProfile, style: context.textStyles.title2Emphasized),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.logInYourProfileDescription,
                        style: context.textStyles.bodyRegular.copyWith(color: context.colors.textTertiary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: GradientElevatedButton(
                          text: context.l10n.logInOrRegister,
                          onPressed: () async => await context.pushNamed(Routes.signIn.name),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class const _EditProfileWidget() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProfileBloc bloc = context.read<ProfileBloc>();
    final WindowSize windowSize = WindowSizeScope.of(context);
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final UserProfile? profile = state.data;
        return Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SvgPicture.asset(
                Assets.svg.profilePattern.path,
                fit: BoxFit.cover,
                width: windowSize.isCompact ? MediaQuery.sizeOf(context).width : 400,
                colorFilter: ColorFilter.mode(context.colors.iconTertiary, BlendMode.srcIn),
              ),
            ),
            SafeArea(
              child: SizedBox(
                height: 250,
                child: Center(
                  child: profile == null
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SizedBox(
                            width: 400,
                            child: Column(
                              children: [
                                const Spacer(),
                                GestureDetector(
                                  onTap: () async {
                                    await context.pushNamed<bool>(Routes.editProfile.name).then((v) {
                                      if (v != null && v) {
                                        bloc.add(const ProfileEvent.start());
                                      }
                                    });
                                  },
                                  child: SizedBox(
                                    height: 74,
                                    width: 74,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: SizedBox(
                                            height: 72,
                                            width: 72,
                                            child: DecoratedBox(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(24)),
                                                gradient: LinearGradient(
                                                  colors: AppColors.gradientBAG24,
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                              ),
                                              child: Center(
                                                child: SvgPicture.asset(
                                                  Assets.svg.profile.path,
                                                  height: 28,
                                                  width: 28,
                                                  colorFilter: ColorFilter.mode(
                                                    context.colors.iconPrimary,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: context.colors.baseBgPrimary,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: context.colors.borderSecondary,
                                                  strokeAlign: BorderSide.strokeAlignOutside,
                                                ),
                                              ),
                                              child: Center(
                                                child: SvgPicture.asset(
                                                  Assets.svg.edit.path,
                                                  height: 16,
                                                  width: 16,
                                                  colorFilter: ColorFilter.mode(
                                                    context.colors.iconAccent,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                if (profile.firstName == null && profile.lastName == null)
                                  GestureDetector(
                                    onTap: () async {
                                      await context.pushNamed<bool>(Routes.editProfile.name).then((v) {
                                        if (v != null && v) {
                                          bloc.add(const ProfileEvent.start());
                                        }
                                      });
                                    },
                                    child: Text(
                                      context.l10n.whatIsYourName,
                                      style: context.textStyles.title2Emphasized.copyWith(
                                        color: context.colors.textAccent,
                                      ),
                                    ),
                                  )
                                else
                                  Text(
                                    '${profile.firstName} ${profile.lastName}',
                                    style: context.textStyles.title2Emphasized,
                                  ),
                                const SizedBox(height: 8),
                                Text(
                                  formatAsPhoneNumber(profile.phoneNumber) ?? '',
                                  style: context.textStyles.bodyRegular.copyWith(color: context.colors.textTertiary),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class const _TextTileWidget({
  required final String title,
  required final VoidCallback onTap,
  required final String iconPath,
  final bool roundTop = false,
  final bool roundBottom = false,
  final bool dividerBottom = false,
  final bool showTrailing = true,
  final Color? backgroundColor,
  final Color? foregroundColor,
  final Color? textColor,
}) extends StatelessWidget {
  this : assert(!dividerBottom | !roundBottom, 'dividerBottom and roundBottom can not use both');

  @override
  Widget build(BuildContext context) {
    final widget = Material(
      color: backgroundColor ?? (context.colors.baseBgSecondary),
      borderRadius: BorderRadius.vertical(
        top: roundTop ? const Radius.circular(24) : Radius.zero,
        bottom: roundBottom ? const Radius.circular(24) : Radius.zero,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              SvgPicture.asset(
                iconPath,
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(foregroundColor ?? (context.colors.iconTertiary), BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: context.textStyles.bodyRegular)),
              const SizedBox(width: 8),
              if (showTrailing)
                SvgPicture.asset(
                  Assets.svg.arrowRight.path,
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(foregroundColor ?? context.colors.iconTertiary, BlendMode.srcIn),
                ),
            ],
          ),
        ),
      ),
    );
    if (dividerBottom) {
      return Column(
        children: [
          widget,
          ColoredBox(
            color: context.colors.buttonBgTertiary,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1, thickness: 1, color: context.colors.borderPrimary),
            ),
          ),
        ],
      );
    }
    return widget;
  }
}

class const _MOAWidget() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<MOABloc, MOAState>(
      listener: (context, state) {
        state.mapOrNull(failure: (s) => showCustomAppException(context, s.exception));
      },
      child: SizedBox(
        height: 140,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.errorLight,
            borderRadius: const BorderRadius.all(Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<MOABloc, MOAState>(
              builder: (context, state) {
                if (state.inProgress) {
                  return const _MileOnAirShimmerWidget();
                }
                return _MileOnAirContentWidget(isMoaAvailable: state.isMoaAvailable, miles: state.miles);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class const _MileOnAirContentWidget({required final bool? isMoaAvailable, required final int miles})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool inJoined = (isMoaAvailable ?? false) && miles >= 0;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: SvgPicture.asset(context.icons.mileOnAirLogo, height: 16),
            ),
            Material(
              color: context.colors.badgeBgPrimary,
              shape: const StadiumBorder(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: SizedBox(
                        height: 6,
                        width: 6,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: inJoined ? context.colors.success : context.colors.error,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      !(isMoaAvailable ?? false)
                          ? context.l10n.temporarilyUnavailable
                          : inJoined
                          ? context.l10n.connected
                          : context.l10n.notConnected,
                      style: context.textStyles.caption1Regular.copyWith(color: context.colors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 36),
        if (inJoined) _ConnectedWidget(miles: miles) else _DisconnectedWidget(isLoading: isMoaAvailable == null),
      ],
    );
  }
}

class const _MileOnAirShimmerWidget() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: SvgPicture.asset(context.icons.mileOnAirLogo, height: 16),
              ),
              const ShimmerLoading(inProgress: true, child: SizedBox(height: 24, width: 100)),
            ],
          ),
          const SizedBox(height: 36),
          const ShimmerLoading(inProgress: true, child: SizedBox(height: 48, width: double.infinity)),
        ],
      ),
    );
  }
}

class const _ConnectedWidget({required final int miles}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.baseBgPrimary,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.read<MOABloc>().add(const MOAEvent.start()),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.balance,
                  style: context.textStyles.bodyEmphasized.copyWith(color: context.colors.mileOnAir),
                ),
              ),
              const SizedBox(width: 12),
              Material(
                shape: const StadiumBorder(),
                clipBehavior: Clip.antiAlias,
                child: DecoratedBox(
                  decoration: const BoxDecoration(gradient: LinearGradient(colors: AppColors.gradientMileOnAir)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      '$miles M',
                      style: context.textStyles.caption1Regular.copyWith(color: context.colors.textPrimaryInverse),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class const _DisconnectedWidget({final bool isLoading = false}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.mileOnAir,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async => await showMoaBottomSheet(
          context,
          onJoinPressed: () => context.read<MOABloc>().add(const MOAEvent.register()),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.toConnect,
                  style: context.textStyles.bodyRegular.copyWith(color: context.colors.textPrimaryInverse),
                ),
              ),
              const SizedBox(width: 12),
              if (isLoading)
                CustomLoadingSpinner(color: context.colors.textPrimaryInverse, diameter: 24)
              else
                SvgPicture.asset(
                  Assets.svg.arrowRight.path,
                  height: 24,
                  width: 24,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
