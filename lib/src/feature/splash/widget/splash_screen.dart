import 'dart:async';

import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/resources/resources.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/splash/bloc/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class const SplashScreen({super.key}) extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState() extends State<SplashScreen> {
  late final SplashBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SplashBloc(
      packageInfo: context.dependencies.packageInfo,
      stateRepository: context.dependencies.appStateRepository,
      authenticationRepository: context.dependencies.authenticationRepository,
      userRepository: context.dependencies.userRepository,
      pinRepository: context.dependencies.pinRepository,
      permissionsRepository: context.dependencies.permissionsRepository,
      onboardingRepository: context.dependencies.onboardingRepository,
    )..add(const SplashEvent.start());
  }

  @override
  void didChangeDependencies() {
    _bloc.add(const SplashEvent.start());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    unawaited(_bloc.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      bloc: _bloc,
      listener: (context, state) => state.mapOrNull(
        success: (s) => context.goNamed(s.route.name),
        failure: (s) {
          if (s.route == Routes.updateApp) {
            return context.goNamed(Routes.updateApp.name, queryParameters: {'latestVersion': s.latestVersion});
          }
          return context.goNamed(s.route.name);
        },
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: DecoratedBox(
          decoration: const BoxDecoration(gradient: LinearGradient(colors: AppColors.gradientBAG24)),
          child: Center(
            child: SizedBox.square(
              dimension: 768,
              child: SvgPicture.asset(Assets.svg.bag24Splash.path, fit: BoxFit.none),
            ),
          ),
        ),
      ),
    );
  }
}
