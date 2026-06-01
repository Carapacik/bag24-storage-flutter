import 'package:bag24/src/core/router/navigator_holder.dart';
import 'package:bag24/src/core/router/observer.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/authentication/bloc/otp_code/otp_code_bloc.dart';
import 'package:bag24/src/feature/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:bag24/src/feature/authentication/widget/authentication_scope.dart';
import 'package:bag24/src/feature/authentication/widget/otp_code_screen.dart';
import 'package:bag24/src/feature/authentication/widget/sign_in_screen.dart';
import 'package:bag24/src/feature/biometrics/bloc/biometrics_bloc.dart';
import 'package:bag24/src/feature/biometrics/widget/biometrics_screen.dart';
import 'package:bag24/src/feature/home/widget/home_screen.dart';
import 'package:bag24/src/feature/home/widget/main_screen.dart';
import 'package:bag24/src/feature/home/widget/select_send_service_screen.dart';
import 'package:bag24/src/feature/location/bloc/select_airport/select_airport_bloc.dart';
import 'package:bag24/src/feature/location/bloc/select_storage/select_storage_bloc.dart';
import 'package:bag24/src/feature/location/widget/select_airport_screen.dart';
import 'package:bag24/src/feature/location/widget/select_storage_screen.dart';
import 'package:bag24/src/feature/luggage_order/bloc/check_in_luggage/check_in_luggage_bloc.dart';
import 'package:bag24/src/feature/luggage_order/bloc/order_created/order_created_bloc.dart';
import 'package:bag24/src/feature/luggage_order/widget/check_in_luggage_screen.dart';
import 'package:bag24/src/feature/luggage_order/widget/order_created_screen.dart';
import 'package:bag24/src/feature/moa/bloc/moa/moa_bloc.dart';
import 'package:bag24/src/feature/notifications/widget/notifications_screen.dart';
import 'package:bag24/src/feature/onboarding/bloc/onboarding_bloc.dart';
import 'package:bag24/src/feature/onboarding/widget/onboarding_screen.dart';
import 'package:bag24/src/feature/order/bloc/cancel_order/cancel_order_bloc.dart';
import 'package:bag24/src/feature/order/bloc/order_composition/order_composition_bloc.dart';
import 'package:bag24/src/feature/order/bloc/order_detail/order_detail_bloc.dart';
import 'package:bag24/src/feature/order/model/order_status.dart';
import 'package:bag24/src/feature/order/widget/cancel_order_screen.dart';
import 'package:bag24/src/feature/order/widget/order_detail_screen.dart';
import 'package:bag24/src/feature/orders/widget/orders_screen.dart';
import 'package:bag24/src/feature/payment/bloc/binding_cards/binding_cards_bloc.dart';
import 'package:bag24/src/feature/payment/bloc/payment/payment_bloc.dart';
import 'package:bag24/src/feature/payment/widget/binding_cards_screen.dart';
import 'package:bag24/src/feature/payment/widget/screen/payment_in_progress_screen.dart';
import 'package:bag24/src/feature/payment/widget/screen/payment_result_screen.dart';
import 'package:bag24/src/feature/payment/widget/screen/payment_screen.dart';
import 'package:bag24/src/feature/payment/widget/screen/payment_webview.dart';
import 'package:bag24/src/feature/photo/widget/take_photo_screen.dart';
import 'package:bag24/src/feature/pin/bloc/create_pin/create_pin_bloc.dart';
import 'package:bag24/src/feature/pin/bloc/edit_pin/edit_pin_bloc.dart';
import 'package:bag24/src/feature/pin/bloc/enter_pin/enter_pin_bloc.dart';
import 'package:bag24/src/feature/pin/widget/create_pin_screen.dart';
import 'package:bag24/src/feature/pin/widget/edit_pin_screen.dart';
import 'package:bag24/src/feature/pin/widget/enter_pin_screen.dart';
import 'package:bag24/src/feature/profile/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:bag24/src/feature/profile/widget/about_app_screen.dart';
import 'package:bag24/src/feature/profile/widget/edit_profile_screen.dart';
import 'package:bag24/src/feature/profile/widget/profile_screen.dart';
import 'package:bag24/src/feature/settings/widget/select_language_screen.dart';
import 'package:bag24/src/feature/settings/widget/settings_screen.dart';
import 'package:bag24/src/feature/splash/widget/splash_screen.dart';
import 'package:bag24/src/feature/support/bloc/contact_support/contact_support_bloc.dart';
import 'package:bag24/src/feature/support/model/instruction_data.dart';
import 'package:bag24/src/feature/support/widget/faq_screen.dart';
import 'package:bag24/src/feature/support/widget/how_works_screen.dart';
import 'package:bag24/src/feature/support/widget/instructions_screen.dart';
import 'package:bag24/src/feature/support/widget/support_screen.dart';
import 'package:bag24/src/feature/system/widget/connection_error_screen.dart';
import 'package:bag24/src/feature/system/widget/technical_error_screen.dart';
import 'package:bag24/src/feature/system/widget/update_app_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

mixin RouterStateMixin<T extends StatefulWidget> on State<T> {
  late final GoRouter router;

  final GlobalKey<NavigatorState> _rootKey = NavigatorHolder.rootNavigatorKey;
  final _shellHomeKey = GlobalKey<NavigatorState>(debugLabel: 'home');
  final _shellOrdersKey = GlobalKey<NavigatorState>(debugLabel: 'orders');
  final _shellProfileKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

  @override
  void initState() {
    router = GoRouter(
      observers: [AppRouterObserver(context.dependencies.logger), RouteObserver()],
      navigatorKey: _rootKey,
      debugLogDiagnostics: kDebugMode,
      initialLocation: Routes.splash.path,
      restorationScopeId: 'ru.bag24.storage',
      redirect: (context, state) {
        final bool isAuthenticated = AuthenticationScope.userOf(context).isAuthenticated;
        final List<String> unAuthScreens = [
          '/',
          Routes.splash.path,
          Routes.onboarding.path,
          Routes.signIn.path,
          '${Routes.signIn.path}/${Routes.otpCode.path}',
          Routes.createPin.path,
          Routes.biometrics.path,
          Routes.home.path,
          Routes.selectStorage.path,
          Routes.selectAirport.path,
          Routes.faq.path,
          '${Routes.faq.path}/${Routes.support.path}',
          Routes.orders.path,
          Routes.howWorksScreen.path,
          Routes.profile.path,
          '${Routes.profile.path}/${Routes.settings.path}',
          '${Routes.profile.path}/${Routes.settings.path}/${Routes.selectLanguage.path}',
          '${Routes.profile.path}/${Routes.aboutApp.path}',
          Routes.aboutApp.path,
          Routes.instruction.path,
          Routes.connectionError.path,
          Routes.technicalError.path,
          Routes.updateApp.path,
        ];
        if (unAuthScreens.contains(state.fullPath?.split('?').first)) {
          return null;
        }
        if (!isAuthenticated) {
          return Routes.splash.path;
        }
        return null;
      },
      errorPageBuilder: (context, state) => const NoTransitionPage(child: TechnicalErrorScreen(knownError: true)),
      routes: [
        GoRoute(
          name: Routes.splash.name,
          path: Routes.splash.path,
          parentNavigatorKey: _rootKey,
          pageBuilder: (context, state) => const NoTransitionPage(child: SplashScreen()),
        ),
        GoRoute(
          name: Routes.onboarding.name,
          path: Routes.onboarding.path,
          builder: (context, state) => BlocProvider(
            create: (context) => OnboardingBloc(onboardingRepository: context.dependencies.onboardingRepository),
            child: const OnboardingScreen(),
          ),
        ),
        GoRoute(
          name: Routes.signIn.name,
          path: Routes.signIn.path,
          parentNavigatorKey: _rootKey,
          builder: (context, state) => BlocProvider(
            create: (context) => SignInBloc(authenticationRepository: context.dependencies.authenticationRepository),
            child: const SignInScreen(),
          ),
          routes: [
            GoRoute(
              name: Routes.otpCode.name,
              path: Routes.otpCode.path,
              builder: (context, state) {
                final String phone = state.uri.queryParameters['phone'] ?? '';
                return BlocProvider(
                  create: (context) => OtpCodeBloc(
                    phone: phone,
                    authenticationRepository: context.dependencies.authenticationRepository,
                    pinRepository: context.dependencies.pinRepository,
                    pushNotificationService: context.dependencies.pushNotificationProvider,
                    deviceInfoRepository: context.dependencies.deviceInfoRepository,
                    packageInfo: context.dependencies.packageInfo,
                    userRepository: context.dependencies.userRepository,
                  ),
                  child: OtpCodeScreen(phone: phone),
                );
              },
            ),
          ],
        ),
        GoRoute(
          name: Routes.instruction.name,
          path: Routes.instruction.path,
          parentNavigatorKey: _rootKey,
          builder: (context, state) {
            final String title = state.uri.queryParameters['title']!;
            final String description = state.uri.queryParameters['description']!;
            return InstructionsScreen(instruction: InstructionData(title, description));
          },
        ),
        GoRoute(
          name: Routes.createPin.name,
          path: Routes.createPin.path,
          parentNavigatorKey: _rootKey,
          builder: (context, state) => BlocProvider(
            create: (context) => CreatePinBloc(pinRepository: context.dependencies.pinRepository),
            child: const CreatePinScreen(),
          ),
        ),
        GoRoute(
          name: Routes.enterPin.name,
          path: Routes.enterPin.path,
          parentNavigatorKey: _rootKey,
          builder: (context, state) => BlocProvider(
            create: (context) => EnterPinBloc(pinRepository: context.dependencies.pinRepository),
            child: const EnterPinScreen(),
          ),
        ),
        GoRoute(
          name: Routes.biometrics.name,
          path: Routes.biometrics.path,
          parentNavigatorKey: _rootKey,
          builder: (context, state) => BlocProvider(
            create: (context) => BiometricsBloc(biometricsRepository: context.dependencies.biometricsRepository),
            child: BiometricsScreen(availableBiometrics: state.extra! as List<BiometricType>),
          ),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) => MainScreen(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              navigatorKey: _shellHomeKey,
              routes: [
                GoRoute(
                  name: Routes.home.name,
                  path: Routes.home.path,
                  pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
                  routes: [
                    GoRoute(
                      name: Routes.notifications.name,
                      path: Routes.notifications.path,
                      builder: (context, state) => const NotificationsScreen(),
                      parentNavigatorKey: _rootKey,
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _shellOrdersKey,
              routes: [
                GoRoute(
                  name: Routes.orders.name,
                  path: Routes.orders.path,
                  pageBuilder: (context, state) => const NoTransitionPage(child: OrdersScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _shellProfileKey,
              routes: [
                GoRoute(
                  name: Routes.profile.name,
                  path: Routes.profile.path,
                  pageBuilder: (context, state) => NoTransitionPage(
                    child: BlocProvider(
                      lazy: false,
                      create: (context) => MOABloc(
                        moaRepository: context.dependencies.moaRepository,
                        paymentRepository: context.dependencies.paymentRepository,
                      ),
                      child: const ProfileScreen(),
                    ),
                  ),
                  routes: [
                    GoRoute(
                      name: Routes.settings.name,
                      path: Routes.settings.path,
                      parentNavigatorKey: _rootKey,
                      builder: (context, state) => const SettingsScreen(),
                      routes: [
                        GoRoute(
                          name: Routes.selectLanguage.name,
                          path: Routes.selectLanguage.path,
                          parentNavigatorKey: _rootKey,
                          builder: (context, state) => const SelectLanguageScreen(),
                        ),
                        GoRoute(
                          name: Routes.editPin.name,
                          path: Routes.editPin.path,
                          parentNavigatorKey: _rootKey,
                          builder: (context, state) => BlocProvider(
                            create: (context) => EditPinBloc(pinRepository: context.dependencies.pinRepository),
                            child: const EditPinScreen(),
                          ),
                        ),
                      ],
                    ),
                    GoRoute(
                      name: Routes.userBindingCards.name,
                      path: Routes.userBindingCards.path,
                      parentNavigatorKey: _rootKey,
                      builder: (context, state) => BlocProvider(
                        lazy: false,
                        create: (context) =>
                            BindingCardsBloc(paymentRepository: context.dependencies.paymentRepository),
                        child: const BindingCardsScreen(),
                      ),
                    ),
                    GoRoute(
                      name: Routes.aboutApp.name,
                      path: Routes.aboutApp.path,
                      parentNavigatorKey: _rootKey,
                      builder: (context, state) => const AboutAppScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          name: Routes.paymentResult.name,
          path: Routes.paymentResult.path,
          builder: (context, state) {
            final Map<String, String> query = state.uri.queryParameters;
            return PaymentResultScreen(
              orderId: query['orderId'] ?? '',
              successResult: bool.tryParse(query['successResult'] ?? '') ?? false,
              orderStatus: OrderStatus.fromString(query['orderStatus'] ?? ''),
              luggageIds: (query['luggageIds'] ?? '').split('|'),
            );
          },
          parentNavigatorKey: _rootKey,
        ),
        GoRoute(
          name: Routes.paymentInProgress.name,
          path: Routes.paymentInProgress.path,
          builder: (context, state) => const PaymentInProgressScreen(),
          parentNavigatorKey: _rootKey,
        ),
        GoRoute(
          name: Routes.paymentWebView.name,
          path: Routes.paymentWebView.path,
          parentNavigatorKey: _rootKey,
          builder: (context, state) {
            return PaymentWebView(url: state.pathParameters['url']!);
          },
        ),
        GoRoute(
          name: Routes.selectAirport.name,
          path: Routes.selectAirport.path,
          parentNavigatorKey: _rootKey,
          builder: (context, state) => BlocProvider(
            lazy: false,
            create: (context) => SelectAirportBloc(
              geolocationRepository: context.dependencies.geolocationRepository,
              locationRepository: context.dependencies.locationRepository,
              permissionsRepository: context.dependencies.permissionsRepository,
            )..add(const SelectAirportEvent.start()),
            child: const SelectAirportScreen(),
          ),
        ),
        GoRoute(
          name: Routes.selectStorage.name,
          path: Routes.selectStorage.path,
          parentNavigatorKey: _rootKey,
          builder: (context, state) => BlocProvider(
            lazy: false,
            create: (context) => SelectStorageBloc(
              geolocationRepository: context.dependencies.geolocationRepository,
              permissionsRepository: context.dependencies.permissionsRepository,
              storageRepository: context.dependencies.storageRepository,
            )..add(const SelectStorageEvent.start()),
            child: const SelectStorageScreen(),
          ),
          routes: [
            GoRoute(
              name: Routes.checkInLuggageOrder.name,
              path: Routes.checkInLuggageOrder.path,
              parentNavigatorKey: _rootKey,
              builder: (context, state) {
                final String storageId = state.pathParameters['storageId']!;
                return BlocProvider(
                  lazy: false,
                  create: (context) => CheckInLuggageBloc(
                    storageId: storageId,
                    authenticationRepository: context.dependencies.authenticationRepository,
                    orderRepository: context.dependencies.orderRepository,
                    storageRepository: context.dependencies.storageRepository,
                  ),
                  child: const CheckInLuggageScreen(),
                );
              },
            ),
            GoRoute(
              name: Routes.orderCreated.name,
              path: Routes.orderCreated.path,
              parentNavigatorKey: _rootKey,
              builder: (context, state) {
                return BlocProvider(
                  lazy: false,
                  create: (context) => OrderCreatedBloc(
                    orderId: state.pathParameters['orderId']!,
                    orderRepository: context.dependencies.orderRepository,
                  ),
                  child: const OrderCreatedScreen(),
                );
              },
            ),
            GoRoute(
              name: Routes.chooseWhereToPay.name,
              path: Routes.chooseWhereToPay.path,
              builder: (context, state) {
                final Map<String, String> queryParameters = state.uri.queryParameters;
                final List<String> luggageIds = queryParameters['luggageIds'] == null
                    ? const <String>[]
                    : (queryParameters['luggageIds'] ?? '').split('|');
                final bool useAutoCharge = bool.tryParse(queryParameters['useAutoCharge'] ?? '') ?? true;
                return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      lazy: false,
                      create: (context) => MOABloc(
                        moaRepository: context.dependencies.moaRepository,
                        paymentRepository: context.dependencies.paymentRepository,
                      ),
                    ),
                    BlocProvider(
                      lazy: false,
                      create: (context) => BindingCardsBloc(paymentRepository: context.dependencies.paymentRepository),
                    ),
                    BlocProvider(
                      create: (context) => PaymentBloc(
                        orderId: queryParameters['orderId'] ?? '',
                        luggageIds: luggageIds,
                        paymentRepository: context.dependencies.paymentRepository,
                        orderRepository: context.dependencies.orderRepository,
                      ),
                    ),
                  ],
                  child: PaymentScreen(
                    orderId: queryParameters['orderId'] ?? '',
                    orderStatus: OrderStatus.fromString(queryParameters['orderStatus'] ?? ''),
                    costPerDay: int.tryParse(queryParameters['costPerDay'] ?? '') ?? 0,
                    discount: int.tryParse(queryParameters['discount'] ?? '') ?? 0,
                    amountToPay: int.tryParse(queryParameters['amountToPay'] ?? '') ?? 0,
                    useAutoCharge: useAutoCharge,
                  ),
                );
              },
              parentNavigatorKey: _rootKey,
            ),
          ],
        ),
        GoRoute(
          name: Routes.order.name,
          path: Routes.order.path,
          parentNavigatorKey: _rootKey,
          builder: (context, state) {
            final String orderId = state.pathParameters['orderId']!;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  lazy: false,
                  create: (context) => OrderDetailBloc(
                    orderId: orderId,
                    orderRepository: context.dependencies.orderRepository,
                    paymentRepository: context.dependencies.paymentRepository,
                    storageRepository: context.dependencies.storageRepository,
                  )..add(const OrderDetailEvent.start()),
                ),
                BlocProvider(
                  create: (context) =>
                      OrderCompositionBloc(orderId: orderId, orderRepository: context.dependencies.orderRepository),
                ),
              ],
              child: const OrderDetailScreen(),
            );
          },
          routes: [
            GoRoute(
              name: Routes.cancelOrder.name,
              path: Routes.cancelOrder.path,
              parentNavigatorKey: _rootKey,
              builder: (context, state) {
                final String orderId = state.pathParameters['orderId']!;
                return BlocProvider(
                  create: (context) =>
                      CancelOrderBloc(orderId: orderId, orderRepository: context.dependencies.orderRepository),
                  child: CancelOrderScreen(
                    orderId: orderId,
                    status: OrderStatus.fromString(state.uri.queryParameters['status'] ?? ''),
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          name: Routes.takePhoto.name,
          path: Routes.takePhoto.path,
          parentNavigatorKey: _rootKey,
          builder: (context, state) => const TakePhotoScreen(),
        ),
        GoRoute(
          name: Routes.faq.name,
          path: Routes.faq.path,
          parentNavigatorKey: _rootKey,
          builder: (context, state) {
            final String? airport = state.uri.queryParameters['airport'];
            final String? orderId = state.uri.queryParameters['orderId'];
            return FaqScreen(airport: airport, orderId: orderId);
          },
          routes: [
            GoRoute(
              name: Routes.support.name,
              path: Routes.support.path,
              parentNavigatorKey: _rootKey,
              builder: (context, state) {
                final String? airport = state.uri.queryParameters['airport'];
                final String? orderId = state.uri.queryParameters['orderId'];
                return BlocProvider(
                  create: (context) => ContactSupportBloc(
                    deviceInfoRepository: context.dependencies.deviceInfoRepository,
                    mailRepository: context.dependencies.mailRepository,
                    packageInfo: context.dependencies.packageInfo,
                    userRepository: context.dependencies.userRepository,
                  ),
                  child: SupportScreen(airport: airport, orderId: orderId),
                );
              },
            ),
          ],
        ),
        GoRoute(
          name: Routes.howWorksScreen.name,
          path: Routes.howWorksScreen.path,
          parentNavigatorKey: _rootKey,
          builder: (context, state) => const HowWorksScreen(),
        ),
        GoRoute(
          name: Routes.editProfile.name,
          path: Routes.editProfile.path,
          parentNavigatorKey: _rootKey,
          builder: (context, state) => BlocProvider(
            create: (context) =>
                EditProfileBloc(userRepository: context.dependencies.userRepository)
                  ..add(const EditProfileEvent.start()),
            child: const EditProfileScreen(),
          ),
        ),
        GoRoute(
          name: Routes.selectSendService.name,
          path: Routes.selectSendService.path,
          parentNavigatorKey: _rootKey,
          builder: (context, state) => const SelectSendServiceScreen(),
        ),
        GoRoute(
          name: Routes.connectionError.name,
          path: Routes.connectionError.path,
          parentNavigatorKey: _rootKey,
          pageBuilder: (context, state) => const NoTransitionPage(child: ConnectionErrorScreen()),
        ),
        GoRoute(
          name: Routes.technicalError.name,
          path: Routes.technicalError.path,
          parentNavigatorKey: _rootKey,
          pageBuilder: (context, state) => NoTransitionPage(
            child: TechnicalErrorScreen(
              knownError: bool.tryParse(state.uri.queryParameters['knownError'] ?? '') ?? false,
            ),
          ),
        ),
        GoRoute(
          name: Routes.updateApp.name,
          path: Routes.updateApp.path,
          parentNavigatorKey: _rootKey,
          pageBuilder: (context, state) {
            return NoTransitionPage(child: UpdateAppScreen(latestVersion: state.uri.queryParameters['latestVersion']!));
          },
        ),
      ],
    );
    super.initState();
  }
}
