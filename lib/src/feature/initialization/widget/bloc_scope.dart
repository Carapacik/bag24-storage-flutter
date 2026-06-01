import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/home/bloc/banners/banners_bloc.dart';
import 'package:bag24/src/feature/orders/bloc/active_orders/active_orders_bloc.dart';
import 'package:bag24/src/feature/orders/bloc/inactive_orders/inactive_orders_bloc.dart';
import 'package:bag24/src/feature/profile/bloc/profile/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const BlocScope({required final Widget child, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (_) => BannersBloc(
            homeRepository: context.dependencies.homeRepository,
            permissionsRepository: context.dependencies.permissionsRepository,
            storageRepository: context.dependencies.storageRepository,
            geolocationRepository: context.dependencies.geolocationRepository,
          ),
        ),
        BlocProvider(create: (_) => ActiveOrdersBloc(orderRepository: context.dependencies.orderRepository)),
        BlocProvider(create: (_) => InactiveOrdersBloc(orderRepository: context.dependencies.orderRepository)),
        BlocProvider(lazy: false, create: (_) => ProfileBloc(userRepository: context.dependencies.userRepository)),
      ],
      child: child,
    );
  }
}
